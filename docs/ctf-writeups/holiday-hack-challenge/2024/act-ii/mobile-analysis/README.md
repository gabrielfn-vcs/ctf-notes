# Mobile Analysis

## Table of Contents
- [Mobile Analysis](#mobile-analysis)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Introduction](#introduction)
  - [Hints](#hints)
    - [Hint 1: Mobile Analysis Easy - Tools](#hint-1-mobile-analysis-easy---tools)
    - [Hint 2: Mobile Analysis Easy - Missing](#hint-2-mobile-analysis-easy---missing)
    - [Hint 3: Mobile Analysis Hard - Format](#hint-3-mobile-analysis-hard---format)
    - [Hint 4: Mobile Analysis Hard - Encryption and Obfuscation](#hint-4-mobile-analysis-hard---encryption-and-obfuscation)
  - [Items](#items)
  - [Silver](#silver)
    - [Silver Analysis](#silver-analysis)
      - [Initial Review](#initial-review)
      - [Additional Exploring](#additional-exploring)
    - [Silver Solution](#silver-solution)
  - [Gold](#gold)
    - [Gold Analysis](#gold-analysis)
      - [Convert File (Optional)](#convert-file-optional)
      - [Explore File](#explore-file)
    - [Gold Solution](#gold-solution)
  - [Outro](#outro)
  - [Files](#files)
  - [References](#references)
  - [Navigation](#navigation)

---

## Overview

Eve Snowshoes is to the left side of the front yard and is asking for help with a new mobile application.

## Introduction

**Eve Snowshoes**

Hi there, tech saviour! Eve Snowshoes and Team Alabaster in need of assistance.

I've been busy creating and testing a modern solution to Santa's Naughty-Nice List, and I even built an Android app to streamline things for Alabaster's team.

But here's my tiny reindeer-sized problem: I made a debug version and a release version of the app.

I accidentally left out a child's name on each version, but for the life of me, I can't remember who!

Could you start with the debug version first, figure out which child's name isn't shown in the list within the app, then we can move on to release? I'd be eternally grateful!

## Hints

### Hint 1: Mobile Analysis Easy - Tools
Try using [apktool](https://github.com/iBotPeaches/Apktool/releases) or [jadx](https://github.com/skylot/jadx).

### Hint 2: Mobile Analysis Easy - Missing
Maybe look for what names are included and work back from that?

### Hint 3: Mobile Analysis Hard - Format
So yeah, have you heard about this new Android app format? Want to convert it to an APK file?

### Hint 4: Mobile Analysis Hard - Encryption and Obfuscation
Obfuscated and encrypted? Hmph. Shame you can't just run strings on the file.

## Items
The conversation with the elf gives us two files:

- [`SantaSwipe.apk`](./SantaSwipe.apk): a debug version in APK format.
- [`SantaSwipeSecure.aab`](./SantaSwipeSecure.aab): a release version in AAB format.

---

## Silver

### Silver Analysis

To be able to read the `SantaSwipe.apk` file properly, we can use [`Jadx`](https://github.com/skylot/jadx). There are two version of Jadx, the GUI and command line version. We can use the GUI version using `jadx-gui` like so:
```bash
jadx-gui SantaSwipe.apk
```

Or we can use the CLI to extract the files to a folder, in this case the folder `out/`.
```bash
jadx -d out SantaSwipe.apk
```

#### Initial Review
In either case, let's navigate to the source code and go to `com.northpole.santaswipe.MainActivity` to get an understanding of what the application does.

It is an Android application made in Kotlin with a few methods to choose from: `onCreate`, `addToNaughtyList`, `addToNiceList`, `getNaughtyList`, `getNiceList`, `getNormalList` and `removeFromAllLists`.

Let's start with the `onCreate` method since it is called first when the application is opened.

We can start by ignoring/removing all lines with `Intrinsics.`, since that just adds some validation stuff that we don't need to know about. There are also some `if` conditions that do nothing, so we can forget about those as well. The code shows five different `webView` variables from the decompilation that are set to `this.myWebView`. We can also clean that up. If we format the remaining code, we get something like this.

```java
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    DatabaseHelper dbHelper = new DatabaseHelper(this);
    SQLiteDatabase writableDatabase = dbHelper.getWritableDatabase();
    this.database = writableDatabase;

    View findViewById = findViewById(R.id.webview);
    this.myWebView = (WebView) findViewById;

    this.myWebView.getSettings().setJavaScriptEnabled(true);

    final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
        .addPathHandler("/assets/", new WebViewAssetLoader.AssetsPathHandler(this))
        .addPathHandler("/res/", new WebViewAssetLoader.ResourcesPathHandler(this))
        .build();

    this.myWebView.setWebViewClient(new WebViewClient() {
        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
            return WebViewAssetLoader.this.shouldInterceptRequest(Uri.parse(url));
        }
    });

    this.myWebView.addJavascriptInterface(new WebAppInterface(), "Android");

    this.myWebView.loadUrl("https://appassets.androidplatform.net/assets/index.html");
}
```

The code starts by setting up a database connection. Then, finds the webview, enables JavaScript, sets the asset locations, and finally loads `/assets/index.html`.

#### Additional Exploring

The `index.html` file mentioned above can be found under the `resources/assets` folder. It contains the layout of the app and the logic to load three lists:

- Normal (`getNormalList()`)
- Nice (`getNiceList()`)
- Naughty (`getNaughtyList()`)

To find which user is missing, let's look at the methods above in the `MainActivity` class.

All three methods start with a SQL query to get the items from the applicable table. However, the one in the `getNormalList()` method has an additional filter:
```java
@JavascriptInterface
public final void getNormalList() {
    final String jsonItems;
    try {
        SQLiteDatabase sQLiteDatabase = MainActivity.this.database;
        Cursor cursor = sQLiteDatabase.rawQuery("SELECT Item FROM NormalList WHERE Item NOT LIKE '%Ellie%'", null);
        List items = new ArrayList();
        Log.d("WebAppInterface", "Fetching items from NormalList table");
        while (cursor.moveToNext()) {
            String item = cursor.getString(0);
            items.add(item);
            Log.d("WebAppInterface", "Fetched item: " + item);
        }
        cursor.close();
        if (items.isEmpty()) {
            jsonItems = "[]";
        } else {
            jsonItems = CollectionsKt.joinToString$default(items, "\",\"", "[\"", "\"]", 0, null, null, 56, null);
        }
        MainActivity.this.runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                MainActivity.WebAppInterface.getNormalList$lambda$0(jsonItems, MainActivity.this);
            }
        });
    } catch (Exception e) {
        Log.e("WebAppInterface", "Error fetching NormalList: " + e.getMessage());
    }
}
```

### Silver Solution
Here is the SQL query by itself:
```sql
SELECT Item FROM NormalList WHERE Item NOT LIKE '%Ellie%'
```

The query gets all items on the list except those with the name `Ellie`.

**Flag (Silver):** `Ellie` is the first missing child's name.

---

## Gold

Aha! Success! You found it!

Thanks for staying on your toes and helping me out—every step forward keeps Alabaster's plans on track. You're a real lifesaver!

Nice job completing the debug version—smooth as a sleigh ride on fresh snow!

But now, the real challenge lies in the obfuscated release version. Ready to dig deeper and show Alabaster's faction your skills?

### Gold Analysis
For this one, we have to work with the Android App Bundle (AAB) file.

The Jadx application supports AAB files natively. However, if we want to, the AAB file can be converted into an APK file.

#### Convert File (Optional)
To convert an Android App Bundle (AAB) file into an APK file, we can use `bundletool` to generate a universal APK.

**Pre-requisites:**

* Java
* Bundletools from https://github.com/google/bundletool/releases

**Steps:**

1. Run the following command to build the APK from the AAB file using Bundletool:
   ```bash
   bundletool build-apks --bundle=SantaSwipeSecure.aab --output=SantaSwipeSecure.apks --mode=universal
   ```
2. The command above will generate a `.apks` file. Change the `.apks` extension to `.zip` so that the content can be extracted:
   ```bash
   mv SantaSwipeSecure.apks SantaSwipeSecure.zip
   ```
3. Once renamed, unzip the file and extract the `universal.apk` file. This is the APK file to analyze.
   ```bash
   unzip SantaSwipeSecure.zip -d ./
   ```
4. The `universal.apk` file will be in the extracted folder.

#### Explore File
Let's use Jadx in the AAB or APK file and follow the same exploration as we did for Silver.

This time, the `onCreate` contains some encrypting logic.
```java
@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    try {
        String string = getString(R.string.iv);
        byte[] decode = Base64.decode(StringsKt.trim((CharSequence) string).toString(), 0);
        this.staticIv = decode;
        String string2 = getString(R.string.ek);
        byte[] decode2 = Base64.decode(StringsKt.trim((CharSequence) string2).toString(), 0);
        this.secretKey = new SecretKeySpec(decode2, 0, decode2.length, "AES");
        initializeDatabase();
        initializeWebView();
        initializeEncryption();
    } catch (IllegalArgumentException e) {
        Log.e("MainActivity", "Error during initialization: " + e.getMessage());
    }
}
```

There is a reference to AES and a couple of strings values (`iv`and `ek`) that are Base64 decoded and saved in two class variables (`staticIv` and `secretKey`).

To get the values of these strings, we can look in the `resources/res/values/strings.xml` file, which is where Android stores strings for localization.

> [!NOTE]
> The actual path when using Jadx GUI depends on the file loaded:
> - **AAB file path:** `Resources/base/resources.pb/res/values/strings.xml`
> - **APK file path:** `Resources/resources.arsc/res/values/strings.xml`

```xml
<!-- ... -->
<string name="ek">rmDJ1wJ7ZtKy3lkLs6X9bZ2Jvpt6jL6YWiDsXtgjkXw=</string>
<!-- ... -->
<string name="iv">Q2hlY2tNYXRlcml4</string>
<!-- ... -->
```

Since the `index.html` file is also the same as before, let's check the `getNormalList` method.
```java
@JavascriptInterface
public final void getNormalList() {
    try {
        SQLiteDatabase sQLiteDatabase = MainActivity.this.database;
        Cursor rawQuery = sQLiteDatabase.rawQuery("SELECT Item FROM NormalList", null);
        ArrayList arrayList = new ArrayList();
        while (rawQuery.moveToNext()) {
            String string = rawQuery.getString(R.xml.backup_rules);
            String decryptData = decryptData(string);
            if (decryptData != null) {
                arrayList.add(decryptData);
            }
        }
        rawQuery.close();
        final String joinToString$default = arrayList.isEmpty() ? "[]"
                : CollectionsKt.joinToString$default(arrayList, "\",\"", "[\"", "\"]", R.xml.backup_rules, null,
                        null, R.string.m3c_bottom_sheet_pane_title, null);
        MainActivity.this.runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                MainActivity.WebAppInterface.getNormalList$lambda$0(MainActivity.this, joinToString$default);
            }
        });
    } catch (Exception unused) {
    }
}
```

The SQL is no longer doing the filtering, but there is additional decryption logic `String decryptData = decryptData(string)` indicating that the data from the database is coming encrypted.

Let's check the implementation of the `decryptData` method:
```java
private final String decryptData(String encryptedData) {
   try {
         Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
         byte[] bArr = MainActivity.this.staticIv;
         if (bArr == null) {
            Intrinsics.throwUninitializedPropertyAccessException("staticIv");
            bArr = null;
         }
         GCMParameterSpec gCMParameterSpec = new GCMParameterSpec(128, bArr);
         SecretKey secretKey = MainActivity.this.secretKey;
         if (secretKey == null) {
            Intrinsics.throwUninitializedPropertyAccessException("secretKey");
            secretKey = null;
         }
         cipher.init(2, secretKey, gCMParameterSpec);
         byte[] bArrDoFinal = cipher.doFinal(Base64.decode(encryptedData, 0));
         Intrinsics.checkNotNull(bArrDoFinal);
         return new String(bArrDoFinal, Charsets.UTF_8);
   } catch (Exception unused) {
         return null;
   }
}
```

The logic is using the AES cipher with the `staticIv` and `secretKey` values we saw before to decrypt the data.

The `onCreate` method in the `MainActivity` class calls the `initializeDatabase` method where an instance of the database is created using the `DatabaseHelper` class.

Looking at the constructor, we can see the same initialization logic for the AES encryption:
```java
public DatabaseHelper(Context context) {
    super(context, DATABASE_NAME, (SQLiteDatabase.CursorFactory) null, R.xml.data_extraction_rules);
    String string = context.getString(R.string.ek);
    String obj = StringsKt.trim((CharSequence) string).toString();
    String string2 = context.getString(R.string.iv);
    String obj2 = StringsKt.trim((CharSequence) string2).toString();
    byte[] decode = Base64.decode(obj, R.xml.backup_rules);
    this.encryptionKey = decode;
    byte[] decode2 = Base64.decode(obj2, R.xml.backup_rules);
    this.iv = decode2;
    this.secretKeySpec = new SecretKeySpec(decode, "AES");
}
```

And the `onCreate` method contains the SQL queries to create all the lists:
```java
@Override
public void onCreate(SQLiteDatabase db) {
    db.execSQL("CREATE TABLE IF NOT EXISTS NiceList (Item TEXT);");
    db.execSQL("CREATE TABLE IF NOT EXISTS NaughtyList (Item TEXT);");
    db.execSQL("CREATE TABLE IF NOT EXISTS NormalList (Item TEXT);");
    db.execSQL(decryptData("IVrt+9Zct4oUePZeQqFwyhBix8cSCIxtsa+lJZkMNpNFBgoHeJlwp73l2oyEh1Y6AfqnfH7gcU9Yfov6u70cUA2/OwcxVt7Ubdn0UD2kImNsclEQ9M8PpnevBX3mXlW2QnH8+Q+SC7JaMUc9CIvxB2HYQG2JujQf6skpVaPAKGxfLqDj+2UyTAVLoeUlQjc18swZVtTQO7Zwe6sTCYlrw7GpFXCAuI6Ex29gfeVIeB7pK7M4kZGy3OIaFxfTdevCoTMwkoPvJuRupA6ybp36vmLLMXaAWsrDHRUbKfE6UKvGoC9d5vqmKeIO9elASuagxjBJ"));
    insertInitialData(db);
}
```
However, one of the SQL queries is encrypted, but it uses a similar `decryptData` method to decrypt it:
```java
private final String decryptData(String encryptedData) {
   try {
      Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
      cipher.init(2, this.secretKeySpec, new GCMParameterSpec(128, this.iv));
      byte[] bArrDoFinal = cipher.doFinal(Base64.decode(encryptedData, 0));
      Intrinsics.checkNotNull(bArrDoFinal);
      return new String(bArrDoFinal, Charsets.UTF_8);
   } catch (Exception e) {
      Log.e("DatabaseHelper", "Decryption failed: " + e.getMessage());
      return null;
   }
}
```

Since we already found the encrypted key (`ek`) and initialization vector (`iv`), we should be able to decrypt the string.

### Gold Solution

Let's use the [`decrypt_data.py`](./decrypt_data.py) Python script with the given `iv` and `ek` values to decrypt the encrypted SQL query. This returns the following:
```sql
CREATE TRIGGER DeleteIfInsertedSpecificValue
    AFTER INSERT ON NormalList
    FOR EACH ROW
    BEGIN
        DELETE FROM NormalList WHERE Item = 'KGfb0vd4u/4EWMN0bp035hRjjpMiL4NQurjgHIQHNaRaDnIYbKQ9JusGaa1aAkGEVV8=';
    END;
```

In this SQL query there is logic to remove entries from the `NormalList` that match another encrypted value. Let's use the same Python script to decrypt this value as well. This returns the following:
```
Joshua, Birmingham, United Kingdom
```

The query deletes entries from the list that match the name `Joshua`.

**Flag (Gold):** `Joshua` is the second missing child's name.

---

## Outro

**Eve Snowshoes**

Aha! Success! You found it!

Thanks for staying on your toes and helping me out—every step forward keeps Alabaster's plans on track. You're a real lifesaver!

**Alabaster Snowball**

Drat, I guess the mobile app is not a secure way to store the Naughty-Nice List. We've just got to think of a better way. It can't fall into Wombley's hands! Maybe just on our secure file share? Hmm...

**Wombley Cube**

Darn that Alabaster! He has the Naughty-Nice List. No matter.

I will get it from his frozen hands after we bury their forces in snow with our arsenal of snow weaponry and armada of drone bombers.

Soon, our snowballs will blot out the sun! And our malware will... well, you'll see.

---

## Files

| File | Description |
|---|---|
| [`SantaSwipe.apk`](./SantaSwipe.apk) | Debug APK — analyzed for Silver |
| [`SantaSwipeSecure.aab`](./SantaSwipeSecure.aab) | Release AAB — analyzed for Gold |
| [`universal.apk`](./universal.apk) | Universal APK extracted from the AAB via `bundletool` |
| [`decrypt_data.py`](./decrypt_data.py) | Python script to decrypt the AES-GCM encrypted SQL query and name |

## References

- [`ctf-techniques/mobile/`](../../../../../ctf-techniques/mobile/README.md) — Android APK analysis technique reference
- [jadx on GitHub](https://github.com/skylot/jadx)
- [apktool](https://apktool.org/)
- [bundletool](https://github.com/google/bundletool/releases)
- [AES-GCM — Wikipedia](https://en.wikipedia.org/wiki/Galois/Counter_Mode)

---

## Navigation

| | |
|:---|---:|
| ← [Drone Path](../drone-path/README.md) | [PowerShell](../powershell/README.md) → |
