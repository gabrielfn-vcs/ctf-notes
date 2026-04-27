# 🧠 CTF Notes and Knowledge Base
![GitHub last commit](https://img.shields.io/github/last-commit/gabrielfn-vcs/ctf-notes)
![GitHub repo size](https://img.shields.io/github/repo-size/gabrielfn-vcs/ctf-notes)
![License](https://img.shields.io/github/license/gabrielfn-vcs/ctf-notes)

## 📑 Table of Contents
- [🧠 CTF Notes and Knowledge Base](#-ctf-notes-and-knowledge-base)
  - [📑 Table of Contents](#-table-of-contents)
  - [📖 Overview](#-overview)
  - [📚 Documentation](#-documentation)
  - [🧩 Project Structure](#-project-structure)
  - [🚀 Site Generation](#-site-generation)
    - [mkdocs-material](#mkdocs-material)
    - [mkdocs-awesome-nav](#mkdocs-awesome-nav)
    - [mkdocs-callouts](#mkdocs-callouts)
    - [mdx\_truly\_sane\_lists](#mdx_truly_sane_lists)
    - [Generating the Site Locally](#generating-the-site-locally)
  - [🚧 Disclaimer](#-disclaimer)
  - [📜 License](#-license)

---

## 📖 Overview

A structured knowledge base of **CTF (Capture The Flag) techniques and challenge writeups**, designed for learning, quick reference, and reuse across competitions and security labs.

The project separates **techniques** (reusable knowledge) from **writeups** (real-world application), allowing each to reinforce the other.

---

## 📚 Documentation

- 🌐 **Browse the site:** [GitHub Pages](https://gabrielfn-vcs.github.io/ctf-notes/)
- 📂 **View source:** [`docs/`](docs/README.md)

The documentation site is built with [MkDocs](https://www.mkdocs.org/) and optimized for fast navigation between techniques and real-world writeups.

---

## 🧩 Project Structure

Below is a high-level view of the repository structure:
```
ctf-notes/
├── docs/                # MkDocs documentation source
│   ├── ctf-techniques/  # Reusable techniques by topic
│   └── ctf-writeups/    # Challenge writeups by platform/event
├── .github/             # CI/CD workflows (GitHub Actions)
├── mkdocs.yml           # MkDocs configuration
├── README.md            # Repository overview
└── LICENSE              # License information
```

Each directory includes a `README.md` that serves as its entry point, with relative links connecting related techniques and writeups.

---

## 🚀 Site Generation

The documentation site is generated with [MkDocs](https://www.mkdocs.org/) using the `README.md` files in each directory as the documentation source.

The following tools enhance navigation, formatting, and overall usability:

### mkdocs-material
A modern, responsive [theme and framework](https://squidfunk.github.io/mkdocs-material/) based on Google's Material Design principles.

- Clean UI with built-in dark/light mode.
- Responsive layout that works on desktops, tablets, and mobile devices.
- Fast client-side search.
- Rich components (admonitions, icons, code features).
- Easy customization via `mkdocs.yml`.

### mkdocs-awesome-nav 
Manages navigation using local `.nav.yml` files instead of a central configuration.

- Keeps navigation close to content.
- Supports ordering, hiding, and grouping pages.
- Reduces complexity in` mkdocs.yml`.

### mkdocs-callouts
Converts Obsidian-style callouts into MkDocs admonitions used by the MAterial theme.

- Supports collapsible blocks (`+` / `-`).
- Recognizes aliases and layout hints.
- Improves compatibility with Obsidian-style notes.

### mdx_truly_sane_lists
Fixes Markdown list rendering inconsistencies.

- Ensures proper nesting and spacing.
- Prevents unwanted paragraph breaks.
- Aligns behavior with GitHub-style Markdown.

### Generating the Site Locally
1. Clone this repository.

2. Install dependencies:
    ```bash
    python3 -m pip install mkdocs mkdocs-material mkdocs-awesome-nav mkdocs-callouts mdx_truly_sane_lists
    ```

3. Generate site and start the local server:
    ```bash
    mkdocs serve
    ```

4. Open the site:
    ```
    http://127.0.0.1:8000
    ```

---

## 🚧 Disclaimer

This repository is provided for **educational and informational purposes only**. All content is derived from authorized CTF competitions, sanctioned security training platforms, and controlled lab environments.

The techniques and methods documented here are intended to support learning, research, and the improvement of defensive security practices. They must **not** be used for unauthorized or unlawful activities.

Use of this information is at your own risk. You are solely responsible for ensuring that your actions comply with all applicable laws and regulations.

**Do not use any techniques from this repository against systems, networks, or applications without explicit authorization from the owner.**

---

## 📜 License

The content in this repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.

Attribution is appreciated but not required.
