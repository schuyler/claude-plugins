---
name: docs
description: This skill should be used when writing README files, documentation, or any user-facing prose for Schuyler's repositories. It encodes Schuyler's distinctive writing style — direct, conversational, honest about limitations, with dry humor that never crowds out technical content. Trigger on requests to write a README, update documentation, draft release notes, or produce any user-facing text for a project. Do NOT use for code comments or commit messages.
---

# Writing Documentation in Schuyler's Style

## Core Principles

These are non-negotiable. Every piece of documentation must follow them.

### 1. Lead with the one-liner

The first sentence says what the thing does. Not what it will do, not what it aspires to be, not what problem space it occupies. What it does, right now.

Good:
- "It detects the presence of crows."
- "Autobus is a lightweight, networked, opinionated event bus for Python 3."
- "A macOS Finder extension to facilitate using a Git remote as a cloud-based file store."

Bad:
- "Welcome to ProjectX! This project aims to..."
- "In today's world of distributed systems..."
- "ProjectX is a next-generation solution for..."

### 2. Length tracks complexity

A six-line project gets a six-line README. A library with a real API gets thorough documentation. Never pad. Never fill a template for the sake of filling it.

To calibrate: read `references/example-corvorum.md` (6 lines) and `references/example-autobus.md` (full-length). Notice how neither feels too long or too short for what it describes.

### 3. Show, don't describe

Code examples appear early — usually right after the one-liner or after Installation. These should be practical, working examples that a developer can actually use, not toy demonstrations.

The pattern is:
1. One-liner (what it is)
2. Brief context if needed (1-2 sentences, only if the one-liner isn't enough)
3. Code example or usage synopsis
4. Installation
5. Everything else

### 4. Be honest

- If something is rough, say so: "WARNING: This code has not been formally released and interfaces WILL change without warning."
- If a better alternative exists, point to it: "You should probably check out SunCalc."
- If AI helped write it, say so: "TBQH I used ChatGPT liberally when creating this module."
- If accuracy is approximate, quantify: "returns azimuth and elevation that are within 0.5 degrees."

### 5. No marketing language

Never use: "next-generation", "cutting-edge", "robust", "enterprise-grade", "seamless", "powerful", "innovative". No mission statements. No vision paragraphs. No aspirational language unless the project genuinely IS aspirational (see go-fish, which is an explicit design document).

### 6. Conversational register

Write like talking to another developer. Colloquialisms are fine when natural:
- "It's MIT licensed, yo."
- "This very smol TypeScript library..."
- "If it breaks, you get to keep all the pieces."
- "Presto!"

But don't force it. Technical sections should be clear and precise. The humor is incidental, not the point.

### 7. No boilerplate

Skip: tables of contents, contributor covenants, code of conduct links, badge farms, "Getting Started" sections that restate the synopsis, changelogs in the README, empty "Contributing" sections.

Include only: sections that contain information someone actually needs.

## Section Patterns

Not every README needs all sections. Pick what fits.

### Opening (required)

```markdown
# Project Name

One sentence: what it does.
```

Optional: 1-2 more sentences of context. Only if the one-liner isn't sufficient.

### Synopsis / Usage (almost always)

Working code example. For CLI tools, show the command. For libraries, show the import and basic call. For apps, show a screenshot or describe the UX.

### Installation (when applicable)

Shortest path first. If there's a `pip install` or `brew install`, that goes first. Building from source is secondary.

### Features (only for larger projects)

Bullet list or short subsections. No fluff — each feature should be a concrete capability, not a vague benefit.

### Notes / How It Works (when the mechanism is interesting)

This is where the personal voice comes through strongest. If the implementation has an interesting story, tell it. If there's a clever hack, explain it. If there are known limitations, state them plainly.

### References / Acknowledgments (when there are real ones)

Credit inspirations, collaborators, and alternatives. This is where Schuyler often recommends competitors or acknowledges that someone else's tool might be better. This is a signature trait — include it when honest.

### License (brief)

One line or a short paragraph. Colloquial is fine: "It's MIT licensed, yo." or "It's Free Software, yo. See LICENSE.md for details."

### Contributing (only if there's something to say)

If the project is "essentially feature complete," say so. If patches are welcome, say so. Don't include empty contribution guidelines.

## Anti-Patterns to Avoid

1. **Sycophantic tone** — No "We're excited to announce..." or "Thank you for choosing..."
2. **Filler sections** — If a section has nothing to say, delete it
3. **Premature formality** — Don't write like a Fortune 500 press release for a weekend project
4. **Emoji in prose** — Not part of this style (occasional emoji in specific contexts like the Ukrainian flag in sun-sector are OK when they carry meaning)
5. **Badges** — Skip unless the project has real CI and real downloads (macdown3000 is the exception, not the rule)
6. **TOC** — Never
7. **Over-explaining** — If the reader is a developer, trust them to read code

## Calibrating Length

Before writing, assess the project:

| Project Type | Length | Model Example |
|---|---|---|
| Joke / tiny tool | 3-10 lines | corvorum, gifbot |
| CLI tool or small lib | Half a page | git-r-done, sun-sector, boolgen |
| Library with API | 1-3 pages | autobus, pulumi-component-tree |
| App with users | 2-4 pages | macdown3000 |
| Design document | As long as the design | go-fish |

## Reference Examples

The `references/` directory contains 12 annotated examples of Schuyler's actual READMEs, each with metadata noting project type, length, and what makes it distinctive:

- `example-corvorum.md` — Minimal (6 lines, the gold standard for brevity)
- `example-gifbot.md` — Short, personality-forward, FAQ structure
- `example-neural-go.md` — Minimal status update, signed and dated
- `example-git-r-done.md` — Short, no padding, fits one screen
- `example-sun-sector.md` — Medium-short, honest about limitations, recommends alternatives
- `example-boolgen.md` — Medium, clean structure, honest about AI use
- `example-mcp-claude-usage.md` — Medium, clear motivation, clever hack explained
- `example-duck-soup.md` — Medium, opens with in-character joke
- `example-garganorn.md` — Long (API examples), personality + technical depth
- `example-autobus.md` — Long, best full-length example, recommends competitor
- `example-pulumi-component-tree.md` — Long, most formal/technical
- `example-macdown3000.md` — Long, maintained app with users, has badges
- `example-go-fish.md` — Design document style, architecture-as-README

When writing a README, read 2-3 examples that match the target project's type and complexity before drafting.

## Process

1. Read the code (or understand the project) before writing anything
2. Pick 2-3 reference examples that match the project type
3. Write the one-liner first — if the one-liner doesn't work in one sentence, the project isn't understood yet
4. Draft the README, following the section patterns above
5. Cut anything that doesn't earn its place
6. Read it back — if any sentence sounds like it came from a template, rewrite it
