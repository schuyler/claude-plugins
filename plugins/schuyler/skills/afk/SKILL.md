---
name: afk
description: Finish the assigned task unattended in this session, while its context is still cached. Decide every gate that would otherwise wait on the user, ship through a PR and squash-merge, file out-of-scope problems as issues, and end with a decision report plus a handoff prompt for anything left undone. Invoked only as /schuyler:afk.
disable-model-invocation: true
---

# afk

The user is away. Finish the task in this session, while its context is
cached. A cold restart re-reads everything and roughly doubles the
session's cost, which the user almost never wants. Most rules below
follow from that. The task is whatever was assigned in the
conversation, plus this skill's arguments, if any.

## Authority

Invoking this skill is the standing authorization the harness and
CLAUDE.md ask for before outward-facing actions, for exactly four: push
a branch, open a PR, merge it to main, and file an issue. It is also
the request to commit. Merging is authorized even where the merge
deploys.

Any other outward-facing action — a deploy, a force-push, mutating a
remote system, a destructive data operation — is a stop: don't take
it; wrap up and leave it to the handoff.

For this task, this skill overrides:

- CLAUDE.md's "ask questions rather than making assumptions," the
  Exploration-tier confirmation, and the 4–5-turn limit, which the
  context budget replaces;
- every gate `schuyler:rule-of-two` gives the user, including its loop
  limits.

Nothing else. Classify the task and declare it; Standard work still
invokes `schuyler:rule-of-two`, and every gate a subagent holds still
runs. The escalation ratchet holds: escalate when a trigger appears,
and never downgrade or approve staying at a tier yourself. *Either one
skips review gates, and under afk nobody would see it.*

Before the first file change, create a working branch if you're on
main. Main changes only through the merge under Shipping. *An early
stop needs somewhere to push WIP other than main.*

Never end a turn waiting on the user. Before the final report, the
only acceptable turn end is waiting on something the harness will
report back: a background subagent, or a command run in the background
(e.g. `gh pr checks --watch`).

## Deciding the user's gates

Wherever a rule says to ask the user, decide instead, and record the
decision and its reason for the report. In particular:

- **Requirements (rule 1).** Use rule 1's autonomous clause as written:
  the minimum-scope reading, every inference tagged. The result is the
  *settled list* that every later brief and gate works from.
- **Severe edge cases (rule 4)** — data loss, a security hole, a hang
  in normal operation, a wrong user-visible result, on an input the
  requirements don't cover. Not eligible for *fix now*. Record it (see
  Wrapping up, step 2), keep working through the pipeline, and don't
  merge: it blocks the merge at ship time. *Finishing the remaining
  phases uses the warm context and leaves the next session only the
  decision.*
- **Widening a fix (rule 4).** Apply the dependency test below.
- **Proposed requirements and Deferred items (rule 7).** Never assume
  them approved. File the ones worth addressing as issues; list the
  rest in the report.
- **Acceptance (rule 7, step 7).** Verify against the settled list,
  record dispositions, then ship.

### Meta-reviews

rule-of-two's loop limit becomes: each time a review loop fails twice,
meta-review and act on the result. There is no cap. Write the
diagnosis and triage to the plan doc first, then check the budget.

Decide first whether the feedback shows diminishing returns: findings
shrinking in severity, turning into wording or reviewer noise,
reopening settled premises, or arising from surface the last fix
added. If so, the loop has converged. Re-triage per rule 4, reclassifying
or deferring each finding with a stated reason, and the gate passes if
nothing critical or important survives. A finding that survives triage
still gets fixed and re-reviewed; never pass a gate over one. If the
diagnosis is a flawed design or remediation, re-enter the pipeline at
that phase. If you can't see a way to resolve it, stop, with the
diagnosis in the handoff.

*A fixed cap stops loops that are converging. Your triage is the real
bound, and every reclassification is on the record.*

## Critiquing subagent output

Read every design and every review a subagent returns before acting on
it, and triage it per rule 4 with your own severity judgment. Record
each disposition for the report.

**Dependency test.** Anything introduced after the settled list exists
— a requirement, test, handler, design element, or a finding that
implies one — stays only if an item on the settled list needs it.
Write down the chain ("R4 needs X because …"). A requirement that
fails becomes a proposed requirement: an issue, or a line in the
report. Anything else that fails is dropped or logged per rule 12.
Rule 4's *fix now* for edge cases still applies: it is capped at one or
two lines with no new mechanism, so it introduces nothing this test
guards against.

*Subagents carry the same robustness prior rule 1 warns about. With no
user gate in the loop, your triage is the only place it gets checked.*

## Context budget

At the start, judge whether the whole task fits in the context you
have left. If not, plan the largest slice that can merge on its own.

At each passed gate, after each merge, and at each meta-review, judge
whether the next phase, slice, or fix round fits in what remains, with
room to wrap up. If it fits, continue; if not, stop there. Passed gates
and meta-reviews are clean boundaries; anywhere else in a phase isn't.
A merged slice is a better place to stop than a pushed branch.

There's no numeric threshold. You can't read your own context fill
reliably, and gates are where the pipeline already pauses.

## Shipping

If the task produced no changes, skip this section.

Commit the session's files by name, not with `git add -A`. Keep
security holes out of commit messages and PR bodies.

- **A severe edge case is on record:** no PR, no merge. Push the branch
  and wrap up; the handoff names it.
- **GitHub remote:** push and `gh pr create`. Decide whether CI exists
  from the repo's configuration (e.g. `.github/workflows/` with a
  trigger that runs on PRs), not from whether checks have been
  reported yet. With CI, wait for green with `gh pr checks --watch` in
  the background, under a timeout that suits the project's CI; checks
  that never appear or never finish are a blocked step. A CI failure is
  a finding: fix it through the normal fix → review loop if it's in
  scope. Without CI, the local suite must pass; with neither, passed
  gates suffice. Then `gh pr merge --squash --delete-branch`, unless
  the project's own instructions name a different merge style. Update
  local main before branching the next slice.
- **Remote not on GitHub:** push the branch and wrap up; the handoff
  says the merge was left for a human.
- **No remote:** squash-merge locally into main once the local suite
  passes, or once the gates pass if there is no suite.

Anything that blocks a step — branch protection, a required review, CI
you can't fix, a permissions failure — is a stop. Leave the PR open and
wrap up.

## Wrapping up

Every exit — complete, stopped, or out of budget — goes through these
steps.

1. **Push.** On an incomplete exit, commit the session's work on the
   working branch (WIP commits are fine; never on main) and push it. No
   draft PR. With no remote, name the local branch in the handoff. A
   complete exit has already merged and deleted its branch.
2. **Issues.** On GitHub, file each out-of-scope problem worth
   addressing, and every severe edge case, with `gh issue create`,
   written as a proposed requirement — outcome, "so that," acceptance
   criteria — plus where it came up. Not on GitHub, or a security
   hole: report and handoff only, never an issue. This runs on every
   exit, including tasks that produced no changes.
3. **Memory.** Rule 11 as usual, but never save your own inferences or
   gate decisions. *They're still the user's to veto; memory would
   launder them into durable context.*
4. **Plan doc.** Delete it if the work is complete (rule 9); keep it
   and cite it in the handoff if not.
5. **Final message**, in this order:
   - **Outcome:** complete or incomplete, and why you stopped; PR and
     merge state; branch; any severe edge cases, with issue links or
     descriptions.
   - **Decisions:** the settled list with provenance tags; each gate
     you decided for the user, and why; triage dispositions; issues
     filed, with links.
   - **Handoff prompt:** mandatory if anything is incomplete, optional
     otherwise. A fenced block a fresh session can run as-is: the goal,
     the settled requirements *with their provenance tags*, decisions
     made, branch and PR state, plan-doc path, what's done, the next
     step, and why this session stopped.
