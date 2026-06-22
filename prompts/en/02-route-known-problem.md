# 02 — Route a Known Problem

Use this after diagnosis is complete. This stage is read-only: produce route comparison and recommendation only. Do not output diffs, file-level change lists, or implementation details.

## Generate routes

- Produce 1-3 routes based on the problem. If only one route is reasonable, provide one and explain why there is no second route.
- Do not pad the list. Writing-style or parameter differences are variants, not independent routes.
- For each route, explain:
  1. Whether it removes the root cause or only the trigger, marked `[read-confirmed]` or `[assumption-needs-validation]`.
  2. Why this route exists: the core tradeoff in one sentence.
  3. Whether it fits this project, anchored to an existing mechanism using `file:symbol`.
- If the problem may be an upstream issue, search for the issue or official fix and link it. If you cannot find one, say so.
- List stopgap routes separately with their conditions. Do not include them in ranking.

## Comparison table

Compare every route across these dimensions. Each cell needs one evidence location or one clearly marked inference.

Dimensions: root-cause removal / regression risk / intrusion surface / compatibility impact / implementation effort

## Recommendation

Rate each route as `[preferred]`, `[viable]`, or `[not recommended]`.

The rating must follow from the comparison table, using this priority: root-cause removal > lower regression risk > smaller intrusion surface > lower effort.

For the preferred route, include reversal conditions: when it should lose to another route.

## Handoff

End with a handoff paragraph for the design stage: architecture landing point + key constraints + declared assumptions.
