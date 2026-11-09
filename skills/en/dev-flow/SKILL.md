---
name: dev-flow
description: The user's code development workflow, run end to end or one stage at a time. End to end: from a one-line request to a PR-ready state (changes committed on a local branch, PR description written, nothing pushed, no PR created); use when the user says "follow my dev flow", "run dev-flow", "run the full flow", or hands over a code change (fix a bug, build a feature, a small change) and asks you to go through planning, review and testing yourself. One stage: use when the user names a dev-flow stage, for example "dev-flow locate this", "dev-flow plan only", "dev-flow execute this plan", "dev-flow review this plan / this branch", "dev-flow self-check", "dev-flow triage this review", "dev-flow continue". Covers: requirement doc, locating, planning, plan review, writing the acceptance test first, executing, command checks, fork self-check, independent review, triaging outside reviews, preparing the PR; hands-on testing in the UI is off by default and up to the user. Ordinary questions and analysis requests that don't name dev-flow don't go here.
---

# dev-flow

Quality is the goal; the process is the minimum bar. Each stage below defines only "what to deliver and what counts as passing"; how to read the code and how to design the plan is your call. When a gate's requirement conflicts with the quality of the deliverable, choose quality and state in the report which rule you departed from and why.

The execution-layer rules in `references/execution-rules.md` (phase separation, minimal change, (a)/(b)/(c) classification, safety rules, verification and reporting) apply as usual; read them before you start. When the user's own global rules or an explicit instruction in this conversation conflicts with them, the user's wins; the user's explicit instructions in this conversation take precedence over this skill.

## Entry points

When the user names a stage, do only that stage. Stop when it is done and don't move on to the next one; report which files this stage produced, what needs the user's decision, and what they can say to continue (for example "dev-flow continue executing <run dir>"). When the user doesn't name a stage, run the full flow.

- **Full flow**: Setup → stages 0-10.
- **Locate**: stage 0, stage 1 (for both large and small changes). Read-only, no branch. Produces `requirement.md`.
- **Plan**: stage 0, stage 1 (large changes only), stage 2, stage 3. Read-only, no branch. Produces `requirement.md`, `plan.md`, `scope.txt`, the plan review records and `closed.md`.
- **Execute**: use `plan.md` in the run dir; when the user hands you a plan directly, save it verbatim as `plan.md` with its source noted at the top. If the run dir has no `requirement.md`, write it per stage 0; if it has no `scope.txt`, write it from the files the plan's diff touches. Then Setup → stages 4-7 → commit the changes to the feature branch. No plan review and no independent review unless the user asks.
- **Review a plan**: review `plan.md` in the run dir, or a plan the user gives you (saved verbatim as `plan.md` with its source noted at the top). Fill in missing `requirement.md` and `scope.txt` as above. Run round 1 of stage 3, judge every finding per "Handling review findings", and record the judgments in `closed.md`. Review only, don't change the plan; when the user says to revise per the review, revise and run the targeted re-review per stages 2-3.
- **Review code**: review committed changes: the feature branch in the run dir, or a branch or commit range the user names. First prepare per "Preparing a code review" below, then run round 1 of stage 8 and record the judgment of every finding in `closed.md`. Review only, don't change the code.
- **Self-check**: run one round per stage 7; report only, don't fix.
- **Triage a review**: see "Triaging an outside review" below. Judge only; don't change code or the plan.
- **Continue**: the user gives a run dir, or a task short name (look under `~/.vibe-runs/<repo name>/`; if several match, ask the user). Find the next step per "Working out where things stand" below and go on until the end of the stage the user named; if none was named, finish the full flow.

### Working out where things stand

Look only at the files in the run dir and the state of the repository; don't keep a separate progress record:

- `requirement.md` exists: stage 0 is done.
- `plan.md` exists: the plan is written; `review-plan-<n>.md` exists: plan review has run n rounds.
- `base` exists and the branch recorded in `branch` has commits after `base` or uncommitted changes: execution has started. Which checks are in `checks.log` and their results decide whether stage 6 has passed.
- `closed.md` has entries starting with self: the fork self-check has run.
- `review-code-<n>.md` exists: independent review has run n rounds.
- `pr.md` exists: done.

When the files disagree (for example `plan.md` is newer than the snapshot from the last plan review round, yet there is no re-review record), state your judgment and the evidence at the top of the report.

## How to use the user's words

The user's words are the final authority, but different sentences carry different weight:

- **Decisions** (what to do, what not to do, scope, limits): follow them. Success criteria and things not to do come only from decisions.
- **Examples / reasons** (examples, analogies, explanations and motives): use them to understand what the user wants; don't derive standalone rules from them, and don't use them to override evidence.
- **Factual claims** (the user's statements about the current code or the cause of a problem): verify them by reading the code; don't assume they hold.

Any doubt about the user's words (a premise doesn't hold, following them won't reach the goal, there is a better path) may only be written as a question for the user; it never justifies widening or changing the change. Until the user replies, follow the words as given. The scope of the change is always bounded by `scope.txt` and stop condition 2, and is never loosened because you doubt the user's words.

## Run directory

One run directory per task, outside the repository so nothing ends up in the PR:

```
~/.vibe-runs/<repo name>/<YYYYMMDD>-<task short name>/
  requirement.md      requirement doc (template: templates/requirement.md)
  scope.txt           change map: allowed paths, one per line, * allowed (* matches across directories)
  base                starting commit; branch is the branch you were on at setup
  untracked-at-start  untracked files that existed at setup, with their sha1; unchanged ones don't count as part of this change
  plan.md             the plan; plan-review-<round>.snapshot.md is the plan as it was at each plan review round
  checks.log          raw output of check commands, written only by scripts/run_check.sh
  closed.md           closed list: the judgment on every review finding (adopted / rejected / void / unverifiable + evidence)
  review-note.md      the user's extra instructions for the reviewer (the user's words), appended to every review message when present
  review-<stage>-<round>.md        review text (counts as a round); the matching .reviewer records which reviewer actually ran
  review-<stage>-<round>.failed.md invalid review output (doesn't count as a round); .stderr.log is the review process log
  review-external-<n>.md           an outside review the user pasted, verbatim
  diff-code-<round>.patch          the diff handed to the reviewer this round
  pr.md               PR title and description
```

Below, `<SKILL>` means the absolute path of this skill's directory and `<RUN>` the absolute path of the run directory. Substitute the real paths when running commands (many tools don't keep shell variables between commands, so don't rely on variables like `RUN=...`).

## Setup

Only when code is about to change: the full flow does it at the very start, the Execute entry point does it when it starts. Read-only entry points skip it. If the run dir already has `base` (work has started before), skip all of it and switch to the feature branch recorded in `<RUN>/branch`.

- Check the working tree: if tracked files have uncommitted changes, stop and ask the user.
- Sync the latest base branch (the user's choice if they named one; otherwise the default branch `origin/HEAD` points to; with no remote, the local default branch) and create the feature branch from it.
- Create the run dir (reuse it if it exists), then record the starting point:

  ```bash
  mkdir -p <RUN>
  bash <SKILL>/scripts/check_scope.sh --init <RUN>
  ```

## Stages

### 0. Take the request, write the requirement doc

- Write `requirement.md` from `templates/requirement.md`. Copy the user's words **verbatim**, and do it now; once the context is compressed later, the original wording is lost. When the words refer back to earlier context ("go with your idea"), also quote the referenced conclusion verbatim and say who said it.
- Classify the user's words sentence by sentence per "How to use the user's words" above; when unsure, classify as a decision. Verify every factual claim by reading the code and record the result under "Premise check"; if any doesn't hold, handle it per stop condition 6.
- When the user asks you to keep a task baseline (the requirement needs many rounds of discussion and they worry context compression will lose information), create and maintain `BASELINE_<task short name>.md` at the repository root per `references/task-baseline.md`; don't create one unless asked.
- When the repository root has a `BASELINE_*.md`: copy only its confirmed content — "Current effective plan" items (with their S numbers), "Immutable constraints", and from "Initial goals" the task goal and the stage success criteria marked as confirmed (with the section name); unconfirmed success criteria, "Pending confirmation items" and "Reference information" are not requirements. When it conflicts with what the user said in the conversation, stop and ask the user.
- Decide the change size and record it in the requirement doc (provisional threshold, to be tuned after a few runs): more than 3 files expected to actually change, or the change touches interfaces, data structures or permissions, is a large change; anything else is a small change.

Passing: every success criterion maps to a decision, a confirmed decision or a confirmed BASELINE item; every factual claim has a verification result.

### 1. Locate (in the full flow and the Plan entry point, large changes only)

Read-only. Find the relevant code paths and write the findings into "Known facts" in `requirement.md`, each with file:line; mark inferences [inferred].

### 2. Plan

Write `plan.md`:

- **Candidate routes (large changes only)**: first list 1-3 routes that genuinely differ in the fix mechanism or where in the architecture the change lands (differences only in wording or parameters count as the same route). For each, write: whether it removes the root cause or the trigger; what it trades for what; which existing mechanism in the project it builds on (file:symbol); the behavior the user will see. Compare the user-visible behavior first: if the routes behave differently, stop and ask the user to choose (stop condition 1) instead of choosing yourself; if they behave the same, pick one and give the reason. If only one route is reasonable, write just that one and explain why there is no second.
- **When the user specified an approach** (large and small changes alike): treat it as one of the candidate routes and compare it with the ones you came up with; don't assume it is right because the user proposed it, and don't ignore it. When another route is clearly better and would give the user different visible behavior or need a different scope, ask the user per stop condition 6; when the difference is invisible to the user (wording, internal implementation), write it the user's way and mention the other route in one sentence in the report.
- Which files you read; each file's diff (with context), each hunk marked (a)/(b)/(c), with (c) moved into "Extra findings"; statements about the current code marked [read-confirmed] or [inferred]; how the acceptance cases will be tested; the statement of what is not modified. A file you haven't read must not appear in the diff.

After the plan, write `scope.txt` to match the files the plan's diff touches. Test files count as changes and must be listed. List concrete files where possible; use `dir/*` only for new files whose location is settled.

### 3. Plan review (independent review, 1 round, plus 1 targeted re-review when needed)

```bash
bash <SKILL>/scripts/review.sh plan <RUN>
```

Judge every finding per "Handling review findings" below, record them in `closed.md`, and revise `plan.md`.

Only when you adopted a [core] finding from round 1 and revised the plan because of it, run the same command again for a targeted re-review: the reviewer looks only at the revised parts of the plan and whether the adopted findings were fixed correctly. If no [core] finding was adopted, skip the re-review and go to the next stage. Whatever remains after the re-review is caught by the code review.

### 4. Write the acceptance test first and confirm it fails

When the project has a test framework, first write a test that proves the requirement and run it once with `run_check.sh`; `checks.log` must show it failing. When there is no test framework or the requirement can only be verified in the UI, write the manual test steps and expected results in `plan.md` and handle them per stage 9; don't set up a test framework for this.

### 5. Execute

Single writer: apply the diff per `plan.md`. When the diff doesn't match the current code or an [inferred] statement doesn't hold, handle the conflict per `references/execution-rules.md`.

### 6. Command checks

```bash
bash <SKILL>/scripts/run_check.sh <RUN> -- <test command>
bash <SKILL>/scripts/run_check.sh <RUN> -- <lint / typecheck command>
bash <SKILL>/scripts/run_check.sh <RUN> -- bash <SKILL>/scripts/check_scope.sh <RUN>
```

Passing: the acceptance test goes from failing to passing; existing tests have no new failures; `check_scope.sh` exits 0. When a change falls outside the change map, stop per stop condition 2 and let the user decide whether to widen the scope; change `scope.txt` only after the user agrees, and record the user's words in the change log of `requirement.md`. Never widen `scope.txt` yourself to make the check pass.

### 7. Fork self-check (1 round)

Use the current tool's fork capability (a sub-agent that inherits this conversation's context), hand it the full text of `prompts/self-check.md` verbatim, and tell it the run dir path. When the tool has no fork capability, go through that checklist yourself. Open the code to check every self-check finding and record the judgments in `closed.md`; fix the ones that hold and go back to stage 6 afterwards (the Self-check entry point reports only and doesn't fix).

### 8. Independent review (at most 2 rounds)

Commit the changes to the feature branch before reviewing (the script requires no uncommitted changes to tracked files and no new untracked files, and uses commits to mark where each round starts).

```bash
bash <SKILL>/scripts/review.sh code <RUN>
```

When the verdict is PASS and no [core] finding was adopted by you, the review is done. Otherwise fix the adopted findings, commit, and run round 2. If [core] findings remain unresolved after round 2, write them verbatim into the final report and `pr.md`, and go on preparing the PR.

### 9. Hands-on testing (off by default, up to the user)

Only when the user asks for hands-on testing (for example the requirement says "test it in the browser"): use whatever browser automation tool or skill is available to walk through the acceptance cases, and write the results into the final report: the actions, what you saw, whether it matched the expectation. When the user didn't ask and some acceptance cases can only be tested by hand, don't test them; list their steps and expected results in the final report and let the user decide whether to test.

### 10. Prepare the PR, and stop here

The changes are committed on the local feature branch; don't push and don't create the PR — the user does both. Commit messages are in English, with no AI attribution of any kind (including Co-Authored-By). Write the PR title and description into `<RUN>/pr.md`: what it solves, how it was accepted (including manual tests not done), and unresolved review findings.

## Preparing a code review

When the changes under review were not written in this flow (a branch or commit range written by the user or someone else), do this first:

- The version under review must be the checked-out HEAD. If it isn't: when tracked files have no uncommitted changes, switch to it, switch back to the original branch after the review, and say so in the report; when there are uncommitted changes, stop and ask the user.
- When part of the changes under review isn't committed yet, stop and ask the user: the review only covers committed changes, and the user commits them.
- Create the run dir and record the starting point. Use the start of the commit range if the user gave one, otherwise the base branch:

  ```bash
  mkdir -p <RUN>
  bash <SKILL>/scripts/check_scope.sh --init <RUN> <start commit or base branch>
  ```

  The script writes the fork point between that start and the current HEAD into `base`.
- Write `requirement.md`: the user's words, plus the PR description and commit messages (`git log <base>..HEAD`) quoted verbatim with their source, then classify and verify per stage 0. When there is no description of the requirement at all, write only the user's words; the reviewer will skip the requirement check.
- When the project has a test command, run the tests once with `run_check.sh`.
- No need to create `plan.md` or `scope.txt`; the script tells the reviewer which materials are missing, and the reviewer skips the checks that depend on them.

## Reviewers

- `review.sh` looks for a reviewer in order: the names listed in the environment variable `DEV_FLOW_REVIEWERS` (default `codex claude dsh`), skipping those not on PATH. When a reviewer exits non-zero, produces empty output or output without a valid verdict line, it moves on to the next one, and states in its output and in the `.reviewer` file which reviewer actually ran this round.
  - `codex`: `codex exec -s read-only` (read-only sandbox).
  - `claude`: `claude -p --permission-mode plan` (read-only mode).
  - `dsh`: `dsh --profile <profile>`, with the profile from the environment variable `DEV_FLOW_DSH_PROFILE`, default `headless`.
- When the user specifies another review command, set the environment variable `DEV_FLOW_REVIEWER` (for example `DEV_FLOW_REVIEWER="claude -p"`); only simple commands without quotes are accepted. Once set, only that command is used, with no fallback on failure.
- The review prompts are always the files in `prompts/`, sent verbatim by the script; don't rewrite them or write your own. When the user has extra instructions for the reviewer (for example "focus on concurrency this time"), write the user's words verbatim into `<RUN>/review-note.md`; the script appends it to the end of every review message.
- Every review round is a new reviewer process that doesn't continue the previous round's session. Everything the reviewer knows comes from files in the run dir:
  - Plan review round 1: the requirement doc, the plan, the change map, `closed.md` (if any).
  - Plan review round 2 (targeted re-review): additionally the round 1 review text, the plan snapshot from round 1 and the updated `closed.md`; it looks only at what changed.
  - Code review round 1: the requirement doc, the change map, `checks.log`, the full diff, the list of untracked files that existed at setup, `closed.md`; it first judges from the requirement doc and the diff on its own, then reads `plan.md` to understand the intent and check the plan's statements about the code. The script lists any of these files that are missing in the review message.
  - Code review round 2: on top of round 1, the incremental diff since round 1, the previous review text and the updated `closed.md`.
  - So the rejection reasons in `closed.md` must carry complete evidence; that file is the only place the reviewer learns why you rejected something.

`review.sh` exit codes:

- 3: this stage has reached its round limit; write the remaining findings into the report and move on.
- 4: the reviewer changed tracked files or the run dir, so this round is void; undo the changes and rerun once; if it happens again, stop and ask the user.
- 5: no reviewer available (every listed reviewer is missing from PATH or failed). Stop per stop condition 5; don't skip the review and carry on.
- When the script lists "new untracked files appeared during the review", they are most likely artifacts of the reviewer running tests; after confirming they aren't your changes, delete them.

## Handling review findings

Applies to every finding from plan review and independent review; fork self-check findings are exempt from the void rule — just open the code and check each one.

- **Void**: a finding missing a location (file:line, or a specific item in the requirement doc / plan), or missing a concrete trigger scenario (and with no failing test attached). Void findings need no reply to the reviewer.
- **Adopted**: holds after you open the code and check it yourself. Change only what this finding covers; don't use it as an excuse to widen the diff.
- **Rejected**: doesn't hold after checking; must carry evidence (file:line + observed value, or command output); reasoning alone can't reject a finding.
- Record each one in `closed.md`: `<stage>-<round>-<number> | adopted/rejected/void | level | one sentence | evidence` (stage is plan / self / code / external).
- A reviewer's finding is a claim to be verified; don't adopt it because it sounds confident. When the verdict says PASS but the findings list has [core] items, judge them one by one all the same.
- Points listed under "Needs user decision" in the review output are judged against "When to stop and ask the user" below, whether or not the verdict is PASS.

### Triaging an outside review

When the user pastes a review written by someone else or produced by another tool:

- Save it verbatim as `<RUN>/review-external-<n>.md`. Put it in the related run dir if there is one; otherwise create a new run dir and write the requirement doc per stage 0 (the requirement doc describes the requirement of the thing being reviewed).
- Open the code to check every item. Outside reviews don't necessarily follow the format, so the void rule doesn't apply: find missing locations yourself; when you can't find them or can't obtain the evidence needed, judge the item "unverifiable" and state what evidence is missing. Items that can be judged by reading the code may not be judged "unverifiable".
- Check `closed.md` first: when the same issue was closed before, state the earlier judgment and its number, and don't re-judge it without new evidence.
- Record the judgments in `closed.md` (stage is external; judgment is adopted / rejected / unverifiable).
- Report: first, how the adopted findings would change the plan or code (what stays, what is added, what is removed); then the judgment and evidence for each item; finally the points needing the user's decision, listed per "How to stop". Don't change code or the plan; once the user confirms, make the changes through the matching entry point.

## When to stop and ask the user

Stop only in these six situations:

1. The requirement is ambiguous: the user's words can be read two ways, or the candidate routes would give the user different visible behavior, or classifying a sentence as a decision versus an example/reason leads to different actions.
2. Fixing an issue requires changing files outside the change map, or changing interfaces, data, permissions or existing behavior.
3. Deadlock: you rejected a [core] finding with evidence, and the reviewer insists with new evidence in the next round.
4. The same problem is still there after two fixes.
5. No reviewer available (`review.sh` exit code 5).
6. The user's words themselves may be wrong, and you have evidence: a factual claim contradicts the code (with file:line); following the words won't solve the problem the words themselves set out to solve (with a concrete scenario); there is a clearly better path than the approach the user specified, and it would give the user different visible behavior or need a different scope. Try to find and raise these before writing code (stages 0-3).

Other disagreements ([edge], [filler], technical choices where both options pass acceptance) are yours to decide; record the reasons in `closed.md` and list them in the report.

How to stop: first finish judging every finding of the current round and fix the adopted ones that don't depend on the user's decision, then list everything that needs a decision at once (at most 3 points), each with the options, their real differences and your recommendation. Save issues found in stages 0-3 to ask together after the plan review where possible; ask separately before writing the plan only when a false premise leaves the plan nowhere to start. Record the user's answers verbatim under "Confirmed decisions" in the requirement doc. When a notification skill is available (for example Feishu or Slack notifications), send a "task not finished" notification in its format.

## Reporting

When running a single stage, report only that stage: which files it produced (paths), the conclusion, the points needing the user's decision, and what to say to continue. For the full flow or the Execute entry point, the final report covers:

- The feature branch name; for the full flow, also the path of `<RUN>/pr.md` and the commands the user runs to push and create the PR; what changed (`git diff --stat`)
- Verification: cite the commands and results in `checks.log`; give the hands-on test results if done, otherwise list the cases awaiting hands-on testing
- Review record: the reviewer and verdict of each round, how many findings were adopted / rejected / void, one sentence per rejection reason
- Unresolved issues, departures from this skill and why
- Where you followed the user's words but disagree (one sentence each: what the words were, your view, the evidence)
- The run dir path
