# Workflow

This workflow is not a straight line from route selection to execution. It has one main path and two review loops.

## Main path

1. Diagnose the issue by reading the relevant code.
2. Compare routes and choose a direction.
3. Run an early adversarial review of that direction.
4. Triage the early review: Codex verifies the critique and decides whether the direction holds.
5. Repeat early review and triage until the direction is stable.
6. Write the plan document.
7. Send the plan document to another agent for review.
8. Triage the plan review: Codex verifies the critique and decides whether to revise the plan, return to route selection, run another review, or execute.
9. Execute only after the plan is accepted.

## Direction review loop

Use this loop before writing the plan document. The reviewer challenges whether the current route solves the original problem, whether it is grounded in code, and whether a smaller route exists. Codex then verifies the review and either keeps the direction, changes it, or asks for a user decision.

## Plan review loop

Use this loop after the plan document exists. The reviewer checks whether the plan still solves the original request, stays inside scope, uses read-confirmed code facts, and avoids execution risks. Codex then verifies the review and either revises the plan, sends it for another review, returns to route selection, or executes.

## Execution

Execution is the last step. Apply only the confirmed diff. Do not refactor, reformat, rename, or fix unrelated issues. If the plan no longer matches the current code, stop and report the conflict.
