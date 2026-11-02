---
name: memory-sweep
description: This skill validates all memory files for accuracy and relevance, checks the index for structural drift, looks for duplicates and contradictions across memories, and reshapes memories that have grown too long or tangled to be read at recall time. Use when memory maintenance is needed, the memory index is growing, a memory file has become unwieldy, or before acting on memories in a new project. Triggered by "/memory-sweep" or requests to clean up, validate, review, consolidate, or trim memories.
---

# Memory Sweep

Validate all memory files for accuracy and relevance, apply the
verdicts, and report what the corpus got wrong.

## Workflow

### 1. Locate the memory system

Read `MEMORY.md` in the project memory directory (its path is in the
system prompt). Extract the project description at the top of the index
and all linked memory file paths.

### 2. Snapshot the corpus

The memory store is not tracked in git, so an errant sweep edit is
unrecoverable. Before any edit, copy the whole memory directory
(including `archive/`) to the session scratchpad and print the path.
Content loss is caught by diffing edited files against this snapshot.

### 3. Validate the index

Check `MEMORY.md` for structural issues:
- **Dead links**: entries pointing to files that no longer exist
- **Orphan files**: memory files in the directory not listed in the index
- **Stale project description**: does the top-of-file sketch still match
  the project? (The inline overview is required — it's the only content
  guaranteed to be seen each session.)
- **Inline content**: substantive memory content below the overview
  belongs in a separate file
- **Description drift**: does each index line still match its file's
  actual content?
- **Broken cross-links**: `[[name]]` links matching no live memory's
  `name:` slug. If the target exists in `archive/`, or matches a file the
  sweep renames or moves, the link is rot — repair or rehome it. If the
  name is not a memory at all (a skill, a doc), rewrite it as plain text.
  A link whose target exists nowhere is a forward reference: list it in
  the report, but it is not a defect
- **Length**: flag if MEMORY.md exceeds 150 lines or ~15 kB (`wc -l -c`).
  The harness read cap is 200 lines / 25 kB — content beyond it is
  silently dropped at session load — and its size warning starts firing
  near 17 kB; the sweep must end below both with margin (step 8).
  Overweight at a legal line count means fat lines, not too many
  entries.

### 4. Corpus-level defect pass

Per-file agents are blind to defect classes that span files: each can
report "this file says X," none can say "this is 1 of 32." Before the
fan-out, grep the whole corpus for defect shapes and count each class.

- Derive the grep from the **property**, not the vocabulary. Name the
  property that makes an instance a defect (e.g. an assertion about
  mutable world-state the memory cannot re-verify), then list every
  phrasing that could carry it and grep for all of them. A grep built
  from one instance's wording sweeps that wording clean and leaves the
  same defect standing in other words.
- State each class's count before any edit; an edit that deletes or
  renames re-runs its enumeration afterward and states both counts. A
  report or reviewer naming N instances never establishes that N is all.
- Hand the class counts to the per-file agents as context.

### 5. Validate each memory file

**Fewer than ~10 memory files: validate inline.** The main agent reads
and judges them directly — fan-out costs more tokens than it saves at
this scale. **At ~10 or more**, batch the files into groups of roughly
8–10, grouped by topic so one agent can share context across its batch,
and launch one agent per batch in parallel (`model: "haiku"`,
`subagent_type: "Explore"`), giving each its file paths, the checklist
below, the corpus-pass class counts, and today's date (delegated agents
don't know it).

Checklist (same whether inline or delegated):

> 1. Read the memory file and note its `metadata.type` (user/feedback/project/reference).
> 2. Read CLAUDE.md and check: is any claim in this memory now **redundant**
>    with CLAUDE.md? Redundant means CLAUDE.md carries *everything* this
>    memory carries — partial overlap is not redundancy; the worked
>    example, the incident, and the why are usually exactly what
>    CLAUDE.md lacks. Where the overlap is partial because the rule
>    *graduated* to CLAUDE.md, the memory keeps the reasoning and the
>    worked example, drops its own restatement of the rule, and names the
>    document that now holds it. Two copies of a rule drift apart; a rule
>    and its reasoning do not.
> 3. For **factual claims** (a file exists, a system behaves a certain way):
>    verify against the current codebase or environment. Name what you
>    checked — file paths read, commands run — so the verdict can be
>    spot-checked. Rewrite line-number citations to symbol form
>    (`send_message` in `irc.py`, not `irc.py:192`) as you verify, even
>    when the line is still right — line numbers rot on the next edit.
> 4. Classify what kind of claim each is and what would make it stale:
>    a durable mechanism, a measured constant, a mutable world-state
>    assertion, or a standing rule. Mutable world-state generally
>    should not be in memory at all. A claim about how this project's own
>    code behaves is never the durable category — it changes with the code
>    while reading as timeless; it gets item-3 verification before any
>    KEEP. Judge age by the harness's "This
>    memory is N days old" reminder, not `modified:` frontmatter — a
>    missing `modified:` is evidence of age, not freshness.
> 5. For **project memories**: consider whether the context is still active
>    or has been resolved. Use today's date to judge time-sensitive items.
> 6. For **reference memories**: check if the referenced resource is still
>    reachable or relevant.
> 7. For **user memories**: factual claims (tools used, environment) get
>    verified per step 3; stated preferences and expertise stay valid
>    unless contradicted by later feedback.
> 8. For **feedback memories** that aren't redundant with CLAUDE.md: these
>    generally stay valid unless explicitly revoked. Note if the feedback
>    seems to contradict current CLAUDE.md rules.
> 9. Check the file's **shape**, not only its claims. Verbatim repetition
>    within a file is a defect at any length. Flag any single memory
>    over ~100 lines (`wc -l`). Length alone is not a defect, but past that
>    ask: have corollaries since grown their own files and been left
>    duplicated here? Is the file's own rule still findable in the first
>    screen? Prune accreted history too — a feedback memory tends to grow a
>    dated log of recurrences, and a date earns its place only when it
>    changes what you would do. Keep the detail that shows *why* a mechanism
>    fails; drop the tally of times it failed.
> 10. Return a verdict:
>    - **KEEP** -- still accurate and relevant
>    - **UPDATE** -- accurate but needs changes; include the proposed
>      replacement text, not just a description of the problem
>    - **RESHAPE** -- accurate and relevant throughout, but too long or too
>      tangled to be read at recall time. Give the proposed structure, not
>      just the observation. A memory that accumulated recurrences until its
>      own rule is hard to find has failed at its job while every individual
>      claim stayed true — no other verdict catches this, because every
>      other verdict asks about truth or relevance.
>    - **REMOVE (reason)** -- no longer accurate or relevant. A rule
>      that generalizes survives the incident that produced it; retiring
>      a safety rail because its triggering incident closed is backwards.
>      A stale status mixed with a durable rule is UPDATE, not REMOVE.
>    - **CANT_VERIFY** -- say what evidence *would* settle it, so the
>      user can decide whether to chase it or rewrite the memory to be
>      verifiable
> 11. Provide 1-2 sentences of reasoning plus the evidence checked.

### 6. Cross-memory pass

Per-file validation can't see relationships between files. With all
results in hand, the main agent checks across them:
- **Duplicates / overlap**: memories covering the same ground → merge
  them
- **Misfiled content**: a memory holding material that belongs in a
  sibling — common in a root rule whose refinements later grew their own
  files. The operation is redistribution, not merging, and it has an
  order: **rehome the content into the sibling first, confirm it landed,
  then delete it from the source.** The step-2 snapshot recovers content
  lost this way; doing it in order means not losing it.
- **Contradictions**: memories that disagree with each other
- **Missing links**: closely related memories that should reference each
  other with `[[name]]`

### 7. Apply and report

Collect everything into a table:

| Memory | Type | Verdict | Reasoning |
|--------|------|---------|-----------|

Include index issues (step 3) and cross-memory findings (step 6) as
separate line items below the table.

Before presenting, the main agent verifies independently: any finding
that would delete a memory, or that contradicts a bolded / "Read first"
index entry, gets an independent command before it is acted on. Never
accept "no matches" without seeing the command that produced it — a
shell error can read as a false zero.

**Apply the verdicts, then report.** The report is a summary of what
changed and — the part worth the user's attention — the lessons: which
defect classes appeared, what caused them, and what writing practice
would have prevented them. It is not a request for sign-off. The memory
store's value is its utility to the agent, not to the user; asking him to
adjudicate a hundred per-file verdicts spends his attention on a document
written for someone else.

Before any file moves to `archive/`, grep the corpus for `[[its-name]]`
and repair or rehome what points at it — step 3 ran before these moves
and cannot catch the links they break.

Three things still do not move without him:

- Retiring a memory that records an explicit instruction, veto, or
  standing prohibition. Fixing staleness around such a rule is fine;
  retiring the rule is his call.
- Anything touching tracked repository files.
- Deletions. Memories go to `archive/`, never `rm`.

The snapshot (step 2) is now the only undo, and the independent
verification above is the only check on a wrong verdict. Neither is
optional.

### 8. Write back

Run `wc -l -c` on the finished index: the sweep does not end with
MEMORY.md over 150 lines or ~15 kB. If it's overweight, tighten the
sketch and the per-entry hooks to one terse line each — never drop
validated entries or add sub-index levels to make weight; the hierarchy
stays one level deep.

Stamp the index with a corpus-level
swept-date header, and mark entries asserting state the sweep could not
verify (e.g. live-server claims needing SSH) with ⚠. One header plus
exception markers, not a per-line date: a date repeated identically on
every entry carries no information — a date signals only when it
differs.
