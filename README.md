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

`/schuyler:standard-task` is an alias for it, because my CLAUDE.md names a `standard-task` skill. It isn't in the release ZIPs, since it's useless without this one.

### /schuyler:afk

Tells the agent to finish the current task without me, in the same session, while its context is still cached. A cold restart re-reads everything and roughly doubles what the session costs, which I almost never want. It runs on top of rule-of-two: the agent decides every gate I would normally hold, reviews its subagents' output critically so they don't sneak in new requirements, and keeps going as long as review feedback is still worth acting on. When the work is done, it squash-merges a PR once CI passes, or once the local tests pass if there's no CI. Out-of-scope problems get filed as GitHub issues, except security holes, which only go in the report and handoff.

It stops short of anything outward-facing beyond pushing, PRs, merging and issues, and it won't merge with a severe problem on record. Unfinished work gets pushed to a branch, and every session ends with a report of the decisions it made and a handoff prompt for whatever's left. The model can't invoke it; you have to type `/schuyler:afk`.

### /schuyler:wrap

Runs an end-of-session retrospective in the main conversation: what went well, what needed correcting, what was merely notable. It saves the lessons that would change a future decision to project memory, refreshes memories the session made stale, and, if there's unfinished work, ends with a handoff prompt for the next session. It drops any lesson that wouldn't change a future decision, so zero new memories is a normal result. It expects the memory layout described in `CLAUDE.md`, and it mentions a `/finish` command that isn't in this repo.

### /schuyler:memory-sweep

Validates the whole memory directory: dead links, orphan files, duplicates, contradictions, stale claims, and memories that have grown too long to be useful at recall time. It snapshots the directory first, applies its own verdicts, and reports what went wrong with the corpus rather than asking you to sign off on each file. Nothing is deleted; retired memories go to `archive/`. It assumes my setup: a `MEMORY.md` index and a `CLAUDE.md` to check memories against.

### /schuyler:docs

Writes READMEs and other user-facing documentation in my style: one-liner first, code early, honest about limitations, no marketing language. It ships with a dozen of my actual READMEs as reference examples. Don't use it for code comments or commit messages.

### /schuyler:ntfy

Sends a push notification to my phone via ntfy when I ask to be pinged. It reads the topic URL from `~/.claude/ntfy-url.txt` and a bearer token from `~/.claude/ntfy-token.txt`, neither of which is in this repo, so it's useless on a machine without them. It's here so my setup syncs, not because you need it.
