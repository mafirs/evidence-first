Execute the implementation plan in `<PLAN_DOCUMENT_PATH>`.

## Scope

- Apply only required and safety/robustness diffs from the plan.
- Do not touch files, functions, or lines not listed in the plan.
- Business impact, regression checklist, extra findings, and not-modified sections are reference only.

## Before starting

1. Run `git status` and show the result. If tracked files have uncommitted changes, stop and ask whether to stash or continue. Ignore untracked files.
2. Read every file listed in the plan’s read scope.
3. Check each diff against the current code:
   - Exact context match: apply normally.
   - Line drift but function/anchor remains: apply by anchor and report anchor-aligned execution.
   - Function missing, key code changed, or logic contradicts the plan: stop that diff and record it as a plan/current-code conflict.
4. If a plan assumption is false, record it as a conflict. Do not guess.

## During execution

- Apply diffs mechanically. Do not reformat, comment, refactor, or fix unrelated bugs.
- Record unrelated findings without changing them.
- If the project already has a relevant test framework and the change is a bug fix or non-trivial behavior change, add or update the smallest behavior test before implementation. If no suitable test framework exists, say so and do not introduce a large framework just for this task.
- If build/typecheck fails:
  - Mechanical mistakes may be fixed and must be reported.
  - Plan logic issues must not be fixed without user decision.

## Completion report

1. Tracked pre-existing changes, if any.
2. Git diff stat and any file changed outside the plan.
3. Skipped diffs and reasons.
4. Plan/current-code conflicts.
5. Build/typecheck/test results, with commands.
6. Self-review: behavior boundary, callers, dependencies, edge cases, doubts.
7. Manual regression points triggered by the change.
8. Findings not handled.
9. Untouched areas confirmation.
