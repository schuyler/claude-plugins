# claude-plugins

Schuyler's Claude Code plugin marketplace.

## Usage

```
/plugin marketplace add schuyler/claude-plugins
/plugin install rule-of-two@schuyler
```

## Plugins

### rule-of-two

A skill that sequences Standard-tier work (anything touching multiple files, involving design decisions, or refactoring) through requirements, design, red/green TDD, and documentation. Each phase ends in a gate, and no work is accepted until a second party, a different subagent or you, has reviewed it cold. The author never reviews their own work.

Invoke it with `/rule-of-two:rule-of-two`, or let Claude pick it up from the task.

It's opinionated and written for my own workflow. It assumes subagents are available, and it expects a CLAUDE.md that classifies tasks into tiers before work starts. Without that, it'll still run, but you'll want to read it first.
