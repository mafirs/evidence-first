# Execute Stage

Use this stage only after a plan has been reviewed, triaged, and approved for execution.

## Before execution

- Run `git status`. If tracked files have uncommitted changes, stop for user decision unless the user already allowed continuing.
- Read every file listed in the plan's read scope.
- Check each diff against current code:
  - Exact context match: apply normally.
  - Anchor still exists: apply by anchor and report anchor-aligned execution.
  - Anchor missing or plan contradicts current code: record conflict and stop that diff.
- If an assumption is false, record conflict. Do not guess.

## During execution

- Apply only approved required or safety diffs.
- Do not reformat, comment, refactor, or fix unrelated bugs.
- If a relevant test framework exists and the change affects behavior, add or update the smallest behavior test. If no suitable framework exists, state that; do not add a large framework.
- Mechanical mistakes may be fixed and must be reported. Plan logic issues require user decision.

## Completion report

Report changed files, skipped diffs, conflicts, verification commands and results, self-review doubts, manual regression points, unhandled findings, and untouched areas.
