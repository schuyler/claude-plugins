---
name: wrap
description: This skill runs an end-of-session retrospective that mines the conversation for procedural and behavioral lessons, records the generalizable ones in project memory, updates memories the session's work rendered out of date, retires completed scratchpad memories, and hands off open threads with a suggested next-session prompt. Use at the end of a long working session, on request. Triggered by "/wrap" or requests to run a retrospective, capture session lessons, review how the session went, or wrap up with a prompt for next time.
---

# Wrap

Run a retrospective on the current session and persist the lessons that
make future work more likely to succeed.

Run this inline — never delegate the retrospective to a subagent. The
session transcript is the input, and only the main agent has it; a
subagent would be retrospecting on a summary of a summary. (Memory
writes are the main agent's job anyway.)

## Workflow

### 1. Walk the session

Re-read the conversation from the beginning. If earlier turns were
compacted, the summary is the record — do not reconstruct detail it no
longer contains. Collect candidate moments in three categories, each
anchored to the specific exchange that produced it:

- **What went well** — prompts, choices, and process decisions that led
  to efficient and correct outcomes. Name what made them work: was it
  how the request was framed, a classification call, a tool choice, an
  ordering of steps?
- **What needs improvement** — mistakes that needed correction,
  redirecting feedback from Schuyler, wrong assumptions, rework, gates
  that failed. Feedback corrections are the highest-value class of
  memory; treat every correction in the transcript as a candidate.
- **General observations** — notable things that fit neither bucket:
  friction, surprises, tooling behavior, recurring patterns.

Anchoring matters: a lesson that cannot point to the moment that taught
it is speculation, not retrospective. Carry the anchor forward as
one-line evidence.

While walking, also list every memory the session accessed. A memory
counts as accessed when its body entered the conversation: read with
the Read tool, injected by a recall reminder, or quoted in a subagent's
report. MEMORY.md is the index, not a memory — an index line alone does
not qualify. Whether the session acted on the memory doesn't matter.

### 2. Generalize and filter

For each candidate, extract the general principle — save the lesson, not
the incident. State it so it applies to the *next* problem of the same
class, not only to the situation that prompted it.

Then apply the recording filter from CLAUDE.md's "What to save"
section — it binds every recording mechanism, this one included: a
lesson must be procedural or behavioral and name the future decision
it would change, and a project-implementation fact must also clear
the rediscoverability bar. Discard what fails; a retrospective that
records everything teaches nothing, because recall runs on scannable
descriptions and dilution buries the lessons that matter. Zero
surviving lessons is a valuable outcome if correct — do not invent a
lesson to have something to record.

### 3. Dedupe against what's already written

For each surviving lesson, in order:

1. **CLAUDE.md**: if it already carries everything the lesson carries,
   drop the lesson — but partial overlap is not redundancy; the incident
   and the *why* are usually exactly what CLAUDE.md lacks. If the lesson
   suggests a new or changed rule, do not edit CLAUDE.md — flag it in
   the report as a rule candidate for Schuyler to decide.
2. **Existing memories**: if one covers the same ground, fold the lesson
   into that file — sharpen its principle, add the new evidence — rather
   than creating a near-duplicate the next sweep will have to merge.

### 4. Refresh the memories the session used

For each memory on the step-1 accessed list not already edited in
step 3 (a lesson folded into a memory there carries any staleness fix
in the same edit), check for either of two things, both of which
warrant an update:

- the session's work **changed what the memory describes** — a
  referenced file or mechanism was altered, a project status advanced;
- the session's work **showed the memory was already wrong** — its
  claim was contradicted in practice during the session.

Update the file — including its description line and its MEMORY.md
index line if the summary shifted — so the next session inherits what
this one learned rather than what this one started with. A memory that
needs refreshing because it asserts mutable world-state is the wrong
shape; flag it in the report for reshaping rather than only updating
the value.

A working memory — one carrying a `retire_when:` line in its
frontmatter metadata, per CLAUDE.md's What-to-save exception — gets
different treatment: if the session satisfied the condition, retire it
to the memory directory's `archive/` (never `rm`) and remove its index
line; the `retire_when:` marker is Schuyler's standing approval for
the retirement. If the
condition isn't met, the work is still pending — refresh it like any
other memory.

Scope stays narrow: only memories the session accessed, only changes
the session's own work evidences — full-corpus validation is
`/memory-sweep`'s job. A memory recording an explicit instruction or
standing prohibition from Schuyler does not get retired here; flag it
in the report instead.

### 5. Record

Write each remaining lesson to the project memory system per its
conventions: one lesson per file, frontmatter (`name`, `description`,
`metadata.type`), an index line in MEMORY.md. Most retrospective lessons
carry `feedback` as their metadata type, with **Why:** and **How to
apply:** lines — the
*why* is what lets a future session judge whether the rule's reason
applies at an edge case, not just its letter. Link related memories
with `[[name]]`.

Write the description line for recall, not for archiving: it is matched
against future tasks cold, so it should state the situation the lesson
applies to, not summarize the session that produced it.

### 6. Report

The report is the full retrospective, not just the bookkeeping:

- The three sections from step 1, each item with its anchor.
- The disposition of every candidate lesson: recorded (with filename),
  folded into which existing memory, or dropped and why. Dropped items
  stay visible — the filter is a judgment call and Schuyler may overrule
  it.
- Memories refreshed in step 4: for each, what the session's work
  established and the substance of the edit — what the memory asserted
  before and asserts now — so the call can be overruled without
  diffing files. Include any memories flagged for reshaping, and any
  working memories retired to `archive/` with the condition that was
  met.
- Any CLAUDE.md rule candidates from step 3, stated as concrete
  proposed rules with their rationale, for Schuyler to accept or
  reject.
- If there's a next step worth carrying into the next session: the
  open threads and a suggested prompt for picking them up. This is the
  forward handoff `/finish` relies on when it runs this retrospective;
  when in doubt, emit it.

The memory writes are already done by the time the report lands; they
are cheap for Schuyler to amend or revert, and the report tells him
exactly what changed and where.
