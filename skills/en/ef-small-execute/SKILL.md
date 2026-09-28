---
name: ef-small-execute
description: "Small execute: mechanically apply the small plan just produced and report. Send to the main agent."
disable-model-invocation: true
---

Execute the code changes according to the plan you just output.

## Execution scope

- Execute the diffs in [What to change]: all (a) required and (b) safety/robustness-required changes; skip (c) optional optimizations
- Do not change files, functions, or lines not listed in the plan
- The other sections (business impact, regression testing, etc.) are reference information, not execution items
- Do not start sub-agents to modify code in parallel this round; apply the plan item by item, verify, and report as a whole yourself; do not split a small task among several writers

## Execution

- Check whether tracked files have uncommitted changes; if so, note it in one sentence at the start of the report (ignore untracked files)
- Apply the diffs mechanically: no reformatting, no added comments, no refactoring, no fixing bugs along the way
- If a diff does not match the current code, or a plan [assumption] does not hold, skip that diff; do not guess how to apply it
- If compilation / type checking fails, paste it as is; do not fix it yourself
- If you find bugs or hidden risks outside the plan, note them and do not touch them

## Report

1. Which files were changed + which plan diff each corresponds to
2. Diffs not executed and why
3. Compilation / type-check results
4. Brief self-review: do the changes match the plan, any doubts
5. Problems found but not handled
6. Confirmation of untouched areas
