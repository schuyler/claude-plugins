# claude-plugins

Schuyler's Claude Code skills, packaged as one plugin called `schuyler` so they show up as `/schuyler:<skill>`.

## Usage

```
/plugin marketplace add schuyler/claude-plugins
/plugin install schuyler@schuyler
```

The marketplace and the plugin are both named `schuyler`. The plugin is the whole bundle, so you can't install one skill without the rest.

## Skills

### /schuyler:rule-of-two

Sequences Standard-tier work (anything touching multiple files, involving design decisions, or refactoring) through requirements, design, red/green TDD, and documentation. Each phase ends in a gate, and no work is accepted until a second party, a different subagent or you, has reviewed it cold. The author never reviews their own work.

It's opinionated and written for my own workflow. It assumes subagents are available, and it expects a CLAUDE.md that classifies tasks into tiers before work starts. Without that, it'll still run, but you'll want to read it first.

### /schuyler:docs

Writes READMEs and other user-facing documentation in my style: one-liner first, code early, honest about limitations, no marketing language. It ships with a dozen of my actual READMEs as reference examples. Don't use it for code comments or commit messages.
