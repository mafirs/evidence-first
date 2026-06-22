# Plan Stage

Use this stage to write a surgical implementation plan. Do not edit code.

## Small plan

Use when the change is local and low risk. Output:

1. What you read.
2. What to change, organized by file with diff and reason.
3. Business impact in plain language.
4. Regression checks.
5. Extra findings, not included in the diff.

## Large plan

Use when the change spans multiple files, front/back end boundaries, or non-trivial behavior.

Required sections:

1. Read scope: files, symbols, line ranges.
2. Plan details per file: path, location method, unified diff, classification `(a)` required / `(b)` safety / `(c)` other, current-state evidence, and reason.
3. Business impact.
4. Regression checklist.
5. Extra findings.
6. Not modified.
7. Final self-check.

Rules:

- Files not read must not appear in the plan.
- Ask at most three critical questions if needed.
- Remove or move all `(c)` changes.
- Do not rename, reformat, reorder imports, refactor, or change unrelated signatures.
