# duck-soup README

Source: https://github.com/schuyler/duck-soup
Type: Claude Code plugin
Length: Medium
Notable: Opens with an in-character joke quote. Structured but personality-forward.

---

# Duck Soup

A structured development workflow for Claude Code with a team of specialized agents.

## Overview

> Four stooges in a trench coat posing as your dev team? Why, that's the oldest gag in software!
>
> You got Groucho telling you where to put the code, Chico checking if you actually put it there, Zeppo making sure it doesn't explode the moment you turn your back, and Harpo... well, somebody's gotta write the docs, might as well be the one who never talks.
>
> It's a structured workflow, which in Hollywood means you fire everyone in the right order!

— Groucho, your new technical architect

## Installation

In Claude Code:

```bash
/plugin marketplace add schuyler/duck-soup
/plugin install dev
```

## Usage

Start the development workflow with:

```bash
/dev:start <task description>
```

**Example:**

```bash
/dev:start Add user authentication with JWT tokens
```

The `/dev:start` command runs a structured workflow starting with requirements gathering and continuing through documentation and feedback. To resume an interrupted session, mention the session slug (e.g., "continue session-resumption").

## Your All-Star Development Team

Four specialized agents:

### Groucho (Project Architect)
- Checks for existing patterns in codebase
- Reviews architectural decisions
- Recommends solutions that match project conventions

### Chico (Code Reviewer)
- Reviews completed implementations
- Verifies requirements adherence
- Identifies issues

### Zeppo (Debugging Specialist)
- Investigates errors and unexpected behavior
- Provides testing plans

### Harpo (Documentation Specialist)
- Creates and updates project documentation
- Updates README, API docs, changelogs

## Workflow Phases

The workflow consists of 7 sequential phases:

### 1. GATHER REQUIREMENTS
### 2. PLAN
### 3. IMPLEMENT
### 4. REVIEW
### 5. VERIFY
### 6. DOCUMENT
### 7. REFLECT

## License

BSD 3-Clause License - see [LICENSE](LICENSE) for details.

## Author

Schuyler Erle <schuyler@nocat.net>
