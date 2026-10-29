# macdown3000 README

Source: https://github.com/schuyler/macdown3000

Type: Desktop application (macOS), continuation of existing project
Length: Long, comprehensive
Notable: Has badges (unusual for Schuyler), structured sections — this is a maintained/released app with users

---

# MacDown 3000

[![Tests](https://github.com/schuyler/macdown3000/workflows/Tests/badge.svg)](https://github.com/schuyler/macdown3000/actions)
[![Downloads](https://img.shields.io/github/downloads/schuyler/macdown3000/total)](https://github.com/schuyler/macdown3000/releases)

MacDown 3000 is a free Markdown editor for macOS, available under the MIT License. It continues the legacy started by Chen Luo's [Mou](http://25.io/mou/) and carried forward by Tzu-ping Chung's [MacDown](https://macdown.uranusjr.com).

Visit the [project website](https://schuyler.github.io/macdown3000/) for more information, or download from the [releases](https://github.com/schuyler/macdown3000/releases) page.

## About MacDown 3000

In 2026, there's still a need for a modern, lightweight Markdown editor for macOS with live preview capabilities. MacDown 3000 is essentially *MacDown Continued*. The focus is on keeping MacDown up to date with modern Markdown best practices and maintaining compatibility with current library dependencies.

MacDown 3000 supports macOS 11.0 (Big Sur) and later on both Apple Silicon and Intel Macs.

This project honors the original intentions and contributions of both Mou and MacDown while ensuring that this valuable tool remains available and actively maintained for today's Mac users.

## Download & Install

**Version 3000.0.4** - Available Now

### Homebrew

The easiest way to install MacDown 3000 is with [Homebrew](https://brew.sh):

```bash
brew install --cask macdown-3000
```

### Manual Download

Download the latest release from the [GitHub Releases](https://github.com/schuyler/macdown3000/releases) page. Open the DMG file and drag MacDown 3000 to your Applications folder.

### System Requirements

- macOS 11.0 (Big Sur) or later
- Universal binary supporting both:
  - Apple Silicon (M-series processors)
  - Intel x86_64 processors

## Screenshot

![screenshot](assets/screenshot.png)

## Features

### Live Preview & Markdown Rendering

MacDown 3000 uses Hoedown to convert Markdown to HTML with live preview as you type. It supports:

- **Fenced code blocks** with language identifiers
- **GitHub Flavored Markdown** including tables, strikethrough (enabled by default), and autolinks
- **Task lists** for GFM-style checkboxes
- **Customizable rendering options** in Preferences

### Syntax Highlighting

Code blocks get syntax highlighting via Prism, supporting numerous programming and markup languages.

### Additional Rendering Tools

- **Math notation** using TeX-like syntax ($$...$$, \[...\], \(...\), and optional $...$ blocks)
- **Jekyll front-matter** for static site generators
- **Export to HTML or PDF** with customizable styling

### Editor Features

- **Auto-completion**: Automatic bracket and quote pairing, list continuation, and formatting shortcuts (customizable or disable)
- **Universal binary**: Built natively for both Apple Silicon (M-series) and Intel Macs
- **Modern Markdown**: Supports CommonMark and GitHub Flavored Markdown

## Development

### Requirements

If you wish to build MacDown 3000 yourself, you will need the following components/tools:

* macOS SDK (11.0 or later)
* Git
* [Bundler](http://bundler.io)

### Environment Setup

After cloning the repository, run the following commands inside the repository root (directory containing this `README.md` file):

    git submodule update --init
    bundle install
    bundle exec pod install
    make -C Dependency/peg-markdown-highlight

and open `MacDown 3000.xcworkspace` in Xcode.

## License

MacDown 3000 is released under the terms of MIT License.

## Contributing & Support

MacDown 3000 is Free Software under the MIT License. Contributions are welcome!

Please [file an issue](https://github.com/schuyler/macdown3000/issues/new) on GitHub for bug reports, feature requests, or questions.
