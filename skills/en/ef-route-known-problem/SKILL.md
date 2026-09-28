---
name: ef-route-known-problem
description: "Known-problem route: after a bug is located, compare 1-3 fix routes and recommend one; read-only, no diff. Send to the main agent."
disable-model-invocation: true
---

Enter the plan stage based on the diagnosis already completed in this session. This round is read-only: produce only a route comparison and recommendation; do not output a diff / file change list / implementation details (those belong to the next-stage design Prompt).

## Route generation

- 1–3 routes, determined by the problem itself. If there is only one reasonable route, give only one and explain why there is no second; no padding — differences in wording/parameters are variants of the same route, and independent routes must genuinely differ in architectural landing point or fix mechanism.
- Each route must make three things clear:
  1. Whether it removes the root cause or the trigger condition — label [read-confirmed] or [assumption-needs-validation]
  2. Why propose it: what the core trade-off is; say in one sentence what it trades for what
  3. Whether it fits this project: which existing mechanism it builds on (file:symbol); state both the fit and the awkward points, not just the good parts
- If you suspect a known dependency/upstream issue: search its issues and official fixes and attach links; if nothing is found, write "not found" — do not make it up.
- If a stopgap (does not cure the root cause, restores service quickly) exists, list it separately with its applicable conditions; it does not take part in the ranking and rating below.
- If the current tool supports sub-agents and there are at least two genuinely different fix mechanisms or several independently verifiable upstream leads, then, without re-choosing the established root cause, dispatch read-only sub-agents in parallel; each sub-agent studies only one candidate route or one upstream lead that you define, and returns the existing basis for that mechanism, evidence of where it lands in the project, counter-evidence, assumptions, and what it did not cover, without redesigning routes or giving recommendations
- Merging routes, rating, reversal conditions, and the recommendation are all done by you; do not decide by vote; parallel work does not reduce the actual reading and verification required for any route

## Comparison table

Go through every dimension for every route; each cell gets one sentence of evidence location or reasoning (mark the source for what was actually read, and state explicitly when something is inferred):
Root-cause fix / Regression risk / Intrusion surface / Compatibility impact / Implementation effort

## Recommendation level

Give each route one rating + one sentence of reason, for me to choose from:
- [preferred] / [optional] / [not recommended]
- Ratings may only be derived from the comparison table, with a fixed priority order: root-cause fix > lower regression risk > smaller intrusion surface > less effort; do not introduce reasons from outside the table.
- A route rated [preferred] must come with reversal conditions: under what premise it would give way to another route.

## Handoff

At the end of the verdict, summarize one paragraph I can carry directly into the design stage after choosing a route: the route's architectural landing point + key constraints + declared assumptions.

## Uncertainties

Ask only questions that would change the ranking or the rating, at most 3; for everything else proceed on the most reasonable assumption and note it on the corresponding route.
