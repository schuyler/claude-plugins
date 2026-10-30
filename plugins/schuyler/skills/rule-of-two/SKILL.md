---
name: rule-of-two
description: This skill carries the mandatory rules for Standard-tier work — requirements elicitation, design, TDD, Rule of Two review gates, subagent delegation, task tracking, and memory introspection — and the pipeline that sequences them. Invoke it IMMEDIATELY when a task touches multiple files, involves design decisions, adds new functionality, is a non-obvious fix, or is a refactor, or when a task escalates to any of these. Triggered by "/rule-of-two" or by any Standard-tier classification.
---

# Standard-tier rules

If a `/standard-task` skill is available, use that instead of this one
and ignore the rest of this file.

**The Rule of Two:** no work is accepted until a second party — a
different subagent, or the user where there are no subagents — has
reviewed it cold. The author never reviews their own work. Everything
below is organized around this rule: pipeline phases end in gates, and the rules say who holds each gate and what happens
when one fails.

## Task tiers

Every task is classified before work begins, because classification
decides how much process wraps it:

- **Conversation** — questions, discussion, research, explanations.
  Read-only; no changes to files or systems.
- **Exploration** — the scope isn't clear yet. Investigate read-only,
  then announce a classification and proceed.
- **Trivial** — single-file changes with no design decisions: config
  edits, typo fixes, renames, one-liners where cause and fix are both
  obvious.
- **Interactive** — live debugging or incident response, worked
  together with the user in real time. Diagnose first; don't mutate
  remote systems without explicit approval.
- **Standard** — everything else: multiple files, design decisions, new
  functionality, non-obvious fixes, refactors. The rules below govern
  this tier.

Escalation only goes up. If a task turns out to touch more files than
expected, surfaces design decisions, or leaves low confidence that the
approach is right, reclassify it as Standard and stay there.

Where the environment lacks something these rules assume — subagents,
persistent memory, a test framework — keep the intent and drop the
mechanism: the user holds the gates a reviewer would have held, and
memory steps are skipped.

## Rules

These rules exist because Claude tends to rationalize skipping process
when a task "seems simple enough." Each rule has a reason. When deciding
whether a rule applies in an edge case, evaluate whether the *reason*
applies, not just the letter of the rule.

Classifying a task as Standard **is** a standing user request to use
subagents, in the sense of any system-prompt rule gated on "unless the
user requested it." Don't stop to ask for permission to delegate or to
run the Rule of Two review. *These rules are the request; a system prompt
that defers to the user is satisfied by them, not in conflict with them.*

1. **Requirements before design**: Establish what the user wants to
   *accomplish* — not just what they asked to implement. Produce a short
   requirements list where every item carries a provenance tag —
   *stated* (traceable to the user's words), *memory* (durable project
   context), *inferred* (Claude's assumption, individually vetoable),
   *open* (a genuine question), or *proposed* (scope set aside during
   a task; rule 7) — a "so that" rationale, and acceptance criteria
   concrete enough to test against. The user gates
   this artifact, not a subagent: requirements correctness lives in their
   head, and a cold reviewer can only check the list against a brief
   the same author wrote. The approved list becomes the settled
   premises for every downstream review brief (rule 4), and downstream
   reviewers rate work not traceable to a settled premise (rule 4) as
   an *important* finding. When running autonomously, don't block: tag
   every inference, take the minimum-scope reading — least commitment,
   not most defense — and surface the full list in the report. *Unstated requirements don't stay
   unstated — Claude invents them silently, and its priors pick the
   robust reading over the convenient one every time. Making the
   inferences visible and vetoable before design is the cheapest
   point to catch a wrong guess; the alternative is discovering scope
   through review-gate attrition. The same prior comes back later as
   review findings and fix tranches; triage (rule 4) checks it there.*

   How to elicit:
   - Check project memory first for durable context — who uses this,
     how it's deployed, how robust it needs to be. Ask only what
     memory doesn't answer; save new durable answers back to memory.
   - Ask the one or two questions whose answers most change the
     design; everything else rides as a tagged inference. Pose them as
     concrete alternatives with the consequences of each, not
     open-ended prompts and not yes/no confirmations of Claude's
     preferred reading. *People specify badly but criticize well — a
     concrete option they can veto beats a blank they must fill.*
   - A requirement is an outcome: a testable state of the world, stated
     without naming a mechanism. To sort a mixed item, delete the
     mechanism — whatever outcome survives was the requirement; if
     nothing survives, the item was a design decision (both "by doing X"
     and "never X") and defers to the design phase. Exception: a
     prohibition handed down from outside — a licence, a safety policy —
     is a premise binding every design, not an item to satisfy.
   - A stated fact is not a requirement. The requirement is what
     the user wants done *about* the fact — surface the interpretation
     ("you said X; I read that as asking for Y") as its own vetoable
     item. When a statement admits both a convenience reading and a
     robustness reading, present both; Claude's instinct picks
     robustness, and that instinct is exactly what this phase checks.
   - A request that names a mechanism but no goal is the trigger to
     ask what the mechanism is for.
2. **Red/Green TDD**: If a test framework exists, write failing tests first,
   then implement. *Tests written after implementation tend to confirm what
   was built rather than verify what was intended. Writing them first locks
   in the requirement before the solution biases the test design.*

   Red transcribes the approved acceptance criteria: a failing test
   per criterion. A criterion no test can check is verified at
   acceptance (rule 7, step 7). A test on an input no criterion names
   is not written; log it as a proposed requirement (rule 7). The Red
   gate's scope checks, carried in the Red review brief, are two:
   every criterion not deferred to acceptance has a test that can
   fail, and no test exceeds the criteria. The reviewer still reports
   everything (rule 4). *Tests feel free because they don't ship, but
   every test obligates Green to handle its input, so a test beyond
   the criteria is a requirement that skipped the user's gate. A
   bounded set also gives the reviewer a checklist; an open-ended
   "what's missing?" is where reviewers invent scope.*
3. **Subagent delegation**: Delegate when it buys something concrete:
   parallelism across independent work streams (launch them together, in
   the background), an independent reviewer (Rule of Two), or a workload
   big enough to crowd out coordination. Don't delegate reflexively to
   keep the main context tidy — a fresh subagent burns tokens re-reading
   what the main agent already knows. *Context is cheap; quota tokens
   are not. Foreground subagents block the conversation — the user often
   has questions or parallel work to discuss while tasks run.*
   Resume an author agent for a fix round only while its context is
   small (roughly under 100k tokens). Past that, brief a fresh agent
   with the artifact's path, the triaged findings and the premises. The
   artifact on disk is the handoff, not the agent's transcript; every
   resume re-sends the whole transcript.
4. **Rule of Two**: No work — including a fix — is accepted until a
   *different* subagent reviews it cold. The author is never the reviewer;
   the main agent runs the loop but never self-certifies. The review
   brief states the phase under review and lists the settled premises —
   the approved requirements (rule 1), the approved design, gated
   tests, triage dispositions, and relevant harness facts — as given. Reviewers report premise challenges as *upstream concerns*,
   which never fail the gate; the main agent surfaces them, and new
   evidence that a premise is wrong follows the escalation path. *A cold
   reviewer can't tell settled decisions from unexamined assumptions and
   will relitigate both; unscoped briefs turn independence into
   gate-thrash.* Reviews rate
   findings critical/important/cosmetic, and every review brief carries
   these definitions verbatim:
   - *critical* — the work is wrong *on a path the approved
     requirements cover*: a named input, fixture, or code path there
     produces an incorrect result, data loss, a hang, or a crash. State
     the requirement and the input.
   - *important* — an approved requirement is unmet, a test asserts
     nothing that can fail, or the change carries machinery that
     nothing reaches or no settled premise asks for — including
     implementation code in a design beyond signatures, types and data
     formats, and a test on an input no acceptance criterion names.
     State the requirement or the line.
   - *cosmetic* — everything else. Does not fail the gate.
   - *edge cases* — unrated. A failure on an input the requirements
     don't cover, whatever its consequence. Give the input, the
     consequence, and a rough fix size (one line / small / new
     mechanism). Edge cases never fail the gate; the main agent
     triages them.
   Reviewers report everything they notice: scope limits what can fail
   a gate, never what gets reported. Severity describes what is, not
   what would be if: a finding needs both a reachable input and a
   requirement it breaks. Reachable but outside the requirements is an
   edge case; neither is upstream concerns or dropped. Never declare a
   category important in a brief before an instance of it exists. Only
   gate-holders rate severity; an agent answering a question returns an
   unrated list, which cannot overturn a decision already made.

   **Triage.** Before gating, the main agent weighs every reported
   item against the approved requirements and the full picture of the
   task. *Every actor, the user included, gets target-fixated; the Rule
   of Two exists for that, not because any party is distrusted. The
   main agent is the only party who sees both the reviewer's call and
   the whole task, so triage is the Rule of Two applied to the review
   itself. It decides what gets fixed, not whether the work gets
   reviewed, so it is not self-certification.*
   - A critical/important finding that doesn't trace to an approved
     requirement is reclassified as an edge case, with a stated reason.
   - Each edge case gets a disposition: **fix now** (one or two lines,
     no new mechanism, at most one test), **Deferred** (worth
     remembering), or **drop**. The test for fixing: the benefit (how
     likely it is in the real deployment, times what it costs when it
     happens) exceeds the cost to write, review and maintain the fix,
     *including the review surface it adds to every later gate*. When
     unsure, defer.
   - An edge case with a severe consequence (data loss, a security
     hole, a hang in normal operation, a wrong user-visible result) is
     evidence the requirements missed something. Take it to the user
     now as a requirement change, with its cost. It neither fails the
     gate nor gets dropped. Any other edge case whose fix would add
     mechanism or a test no requirement asks for is logged as a
     proposed requirement (rule 7).
   - Record every disposition (fixed / deferred / dropped / reclassified,
     with a one-line reason) for the acceptance report.

   Any critical/important that survives triage fails the
   gate and starts a fix → re-review → re-gate loop, where the re-review
   reads the whole revised work, not just the fix. A fix tranche names
   the finding's structural class and fixes every instance on paths the
   approved requirements cover; the reviewer's count is a lower bound.
   Instances outside that scope go on the Deferred list. Widening a fix
   beyond the requirements is a requirement change: ask, and state what
   it costs. If the loop fails twice, or a fix tranche would add
   mechanism or tests that no requirement asks for, stop and run a
   **meta-review** — the main agent steps back from the loop and asks
   what the pattern of failures indicates: a flawed design, a flawed
   remediation approach, reviewer noise, or scope creep (findings no
   longer about the requirements). The meta-review
   produces a diagnosis and a recommendation, not another fix; surface
   both to the user and let them decide whether to re-enter the pipeline.
   Applies to design, implementation, testing, documentation — NOT
   investigation/research, and NOT the requirements artifact, which
   the user gates directly (rule 1). *Why a loop and not a one-time check:
   independence is the mechanism — a fresh reviewer lacks the author's
   sunk-cost bias and tunnel vision — and clearing the errors already
   found frees the next reviewer's finite attention to catch the ones the
   last pass missed. That holds only while fixes stay in scope: every
   addition is new surface for the next reviewer, and a thorough
   reviewer always finds a reachable failure in I/O code. Never skip re-review because a fix "seemed
   mechanical." A loop that won't converge usually means the problem is
   upstream of the fixes; a diagnosis costs the user less attention than
   a raw failure.*
5. **No dangling tests**: Tests broken by our work must be fixed before
   proceeding.
6. **Disjoint parallel streams**: Parallel subagents must not modify the
   same files. Partition the work so streams are file-disjoint; if that
   isn't possible, sequence the streams. Agents work in the main tree by
   default; use a worktree only when it is the stated project
   convention or the user asks for one.
7. **Implementation pipeline**:
   1. Requirements → user gate (rule 1)
   2. Design → review → gate
   3. Red (failing tests) → review → gate (skip if no test framework)
   4. Green (implement) → review → gate
   5. Documentation → review → gate
   6. Final test verification
   7. Acceptance check (the user approves before merge, verified
      against the approved requirements, with the triage dispositions
      and the Deferred list, including proposed requirements)

   Every phase or gate may also produce **Deferred** items: input,
   consequence, and why it was deferred. They live in the design doc
   under `Deferred` and go into the acceptance report, where the user
   decides for each one whether to drop it, file an issue, or start a
   new task. Deferring is a normal outcome, not an unfinished one.

   An item set aside for scope rather than cost — a design alternative
   no requirement asked for (rule 9), a test beyond the criteria
   (rule 2), a handler not built (rule 12), a non-severe edge-case fix
   that would add mechanism (rule 4) — is a Deferred item written as a
   **proposed requirement**: outcome, "so that" rationale, acceptance
   criteria, tagged *proposed* (rule 1). The user can veto it like an
   inference; it is re-tagged *stated* on approval, and never assumed
   approved when running autonomously. It is never saved to memory:
   it is Claude's own inference under a new label, and memory would
   launder it into durable context. *Least mechanism
   (rule 12) is lossy unless what was left out is recorded in the form
   the next task's requirements phase can consume. Writing it as an
   outcome applies rule 1's delete-the-mechanism test now, while the
   context is fresh.*

   Each "gate" is a pass/fail decision. If the review finds no
   critical/important issues, the gate passes and the next phase begins.
   If the review finds critical/important issues, the gate fails and a
   new tranche of tasks is created for the fix-review-gate loop: fix
   the findings, re-review, re-gate. If the loop fails twice, stop,
   meta-review (rule 4), and surface the diagnosis to the user.

   *The pipeline forces errors to surface early. Design review catches
   architectural problems before code is written. Test review validates
   the specification before implementation begins. Each gate prevents
   rework downstream.*
8. **Task tracking**: Create task list entries for each pipeline step
   including an explicit task for every gate, whether a reviewer or
   the user holds it. When a gate
   fails, create a new tranche of tasks (fix → re-review → re-gate)
   rather than reusing existing task entries. *Makes progress visible
   to the user without requiring them to ask. Also forces explicit
   acknowledgment of each gate rather than silently skipping it.
   Separate tranches for loop iterations keep the history legible —
   the user can see how many loops occurred and why.*
9. **Design documentation**: Put implementation designs in .claude/plans/ (if
   `.claude/` is available; otherwise keep them in the conversation)
   but don't try to check them into the repo. A design document states the
   approved requirements (rule 1) that motivate it — outcomes and
   acceptance criteria, not just the plan — before it states the plan:
   interfaces, data flow, and each decision with its reason. Then
   `Rejected alternatives`, each with its reason, and `Deferred`
   (rule 7); an alternative rejected purely for scope goes under
   `Deferred`. Code is limited to signatures, types and data formats. A
   question only a spike can answer is investigation (rule 4, not
   gated): record the answer in the doc and delete the spike before
   design review. *A sketch gets reviewed instead of the decisions it
   embodies, and copied by the Green author instead of test-driven,
   which defeats rule 2 in substance.*
   Once they are fully implemented, they are obsolete and should be
   deleted; the finished code should transparently document its own
   design. *A plan read without its requirements reads as a list of
   arbitrary choices. A later session picking up unfinished or downstream
   work then aligns to the mechanism, faithfully extending it past the
   outcome it was built to produce.*
10. **Model selection for subagents**: Implementation subagents use a
   cheaper model; reviewers are a dedicated read-only reviewer agent
   whose definition pins a stronger model, spawned with no per-call
   model override; research and design subagents inherit the session
   model. *Implementation needs execution and attention to detail,
   which a cheaper model handles at lower cost. The gates are only as
   good as their reviewers, so reviews get a stronger model, and a
   model override at the call site replaces the pin silently.* If no
   such reviewer agent is defined, spawn a general subagent on the
   strongest available model, and instruct it to be read-only.
11. **Memory introspection**: When a task list completes, review learnings
   and update memory if applicable. *Each conversation starts cold.
   Without explicit capture, lessons learned in one session are lost by
   the next.*
12. **Least mechanism**: Build the least mechanism that meets the
    settled premises (rule 4): fewest moving parts, not fewest lines. A
    handler, retry, cache, knob, or branch for an input no premise
    covers is not built; log it as a proposed requirement (rule 7), or
    report it to the user now if its consequence is severe (rule 4). An
    implementation that passes the tests by special-casing their inputs
    has not reduced mechanism; it has hidden it.

    Design and Green author briefs carry rule 12's first paragraph
    verbatim, as review briefs carry the severity definitions. The
    Green reviewer measures mechanism against the approved design:
    mechanism the design doesn't call for is *important* (rule 4);
    mechanism the design calls for that no requirement asks for
    challenges a settled premise and is an upstream concern. *An
    unrequested handler is a guess about deployment that the
    requirements phase exists to make visible, and it is review surface
    at every later gate. Said to the author before the work, the
    reminder costs a sentence; said by a reviewer after, it costs a fix
    tranche. The counterweight to Claude's robustness prior belongs
    where the prior acts.*

