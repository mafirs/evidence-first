Execute the plan you just output.

## Execution scope

- Execute every diff listed under "what to change": apply required and safety/robustness items; skip optional items.
- Do not touch files, functions, or lines not listed in the plan.
- Business impact, regression tests, extra findings, and other sections are reference information, not execution items.

## Execute

- Check whether any tracked files have uncommitted changes. If so, note this in one sentence at the start of your report. Ignore untracked files.
- Apply diffs mechanically: no reformatting, no added comments, no refactoring, no opportunistic bug fixes.
- If a diff does not match the current code, or if a plan assumption no longer holds, skip that diff and record it — do not guess at how to apply it.
- If compilation or type checking fails, report it as-is. Do not self-correct unless the failure is a purely mechanical slip from applying the diff (missing import, mismatched bracket, obvious typo) — if you self-correct, list what you fixed.
- If you find a bug or risk outside the plan, note it and do not touch it.

## Report

1. Which files you changed and which plan diff each corresponds to.
2. Diffs you skipped and why.
3. Compilation and type checking result.
4. Brief self-review: does the change match the plan? Any doubts?
5. Issues found but not handled.
6. Confirmation that files outside the plan were not touched.
