Only produce an implementation plan. Do not modify, create, or delete project files. Do not run commands that change project state.

## Preconditions

1. Read code before planning. Files not read must not appear in the plan.
2. Ask first if a critical uncertainty would materially change the plan. Ask at most three questions.
3. Keep changes minimal: only what the request requires plus directly related safety or boundary handling.
4. Put unrelated bugs or improvements in “Extra findings”. Do not include them in the diff.
5. Do not rename, reformat, reorder imports, remove existing code, refactor, extract functions, or change unrelated types/signatures.

## Output structure

### 1. Read scope

List files, key functions/classes/modules, and line ranges.

### 2. Plan details

One section per file:

- File path
- Location method: function, class, or anchor
- Unified diff with context
- Change classification:
  - (a) required by the request
  - (b) required for safety, robustness, or boundary handling
  - (c) other; remove it or move it to Extra findings
- Current-state evidence:
  - `[read-confirmed]` based on code read
  - `[assumption-needs-validation]` with how the plan changes if false
- Why this change is necessary

### 3. Business impact

Plain language: what changes, which pages or flows change, what remains unchanged, and what the user should see.

### 4. Regression checklist

List existing flows to manually check: action, input, expected result, and why this could be affected.

### 5. Extra findings

Unrelated issues only: location, description, risk, suggested handling, and whether to handle now.

### 6. Not modified

List related files/modules/features intentionally left untouched.

## Final self-check

Answer before final output:

1. Can I give a plan now, or must I ask first?
2. Are all diffs classified as (a) or (b), with (c) removed or moved?
3. Does read scope cover every file in the plan?
4. Is every current-state claim marked as read-confirmed or assumption-needs-validation?
5. Does the regression checklist cover affected existing behavior?
