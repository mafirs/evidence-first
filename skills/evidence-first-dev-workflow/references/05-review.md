# Review Stage

Use this stage for early idea review, final plan review, or triaging another AI's critique.

## Early idea review

Check whether the current direction solves the original request, whether its code claims are read-confirmed, whether a smaller route exists, and whether the direction can advance to a plan document. Do not write implementation code.

## Final plan review

Only point out issues that would cause the plan to fail, drift from the original request, or cross stated boundaries. Do not suggest drive-by refactors, generic tests, logs, comments, or style changes.

Check:

- Does the plan still solve the original request?
- Did scope expand beyond the red line?
- Are code facts suspicious or inferred rather than read?
- Does a concrete boundary case break the plan?
- Did the not-modified section exclude something that must be touched?

## Critique triage

Do not accept another AI's critique blindly. Verify core findings, claimed read conflicts, missed code facts, smaller routes, alternative route claims, and product semantics.

For each important item, decide: true / partly true / false / cannot determine. Evidence is required for true, partly true, and false. Without reading the relevant file, do not call it false.

Archive low-value, speculative, duplicate, or already-covered items in one line each.
