---
name: ef-route-with-user-idea
description: "Route with your idea: verify the gap, compare your idea fairly with other routes and recommend; read-only. Send to the main agent."
disable-model-invocation: true
---

Above I have given: the focus + the current gap + my own optimization idea. This round is read-only; produce a route comparison and recommendation.

## Verify the input before proposing routes

- Verify whether the "current gap" is real: read the relevant code to confirm, and label [read-confirmed] or [assumption-needs-validation]; if you cannot reproduce it, or the actual cause differs from what I said, say so clearly before going further — do not propose routes on a false premise.
- Evaluate my optimization idea: is it technically sound, where does it land (file:symbol), does it have blocking problems. This step only evaluates and does not take sides — do not assume it is right because I proposed it.

## Route generation discipline

- The scope is locked to "removing the gap above", not to "implementing my idea" — my idea is one candidate, not a constraint.
- By default my idea is one candidate route, compared in the same table and ranked on equal terms with the others: if it is good, recommend it; if another route beats it, say truthfully which dimension it loses on and by how much. No polite acceptance, and no ignoring it either. If the previous step found a blocking problem, instead explain separately why it is out, without forcing it into the comparison table.
- Real diversity: routes differ in architectural landing point or implementation mechanism; 1–3 routes; if only one route is reasonable, explain why; no padding (differences in wording/parameters do not count as independent routes).
- Anchor each route to an existing mechanism or extension point (file:symbol); if a route builds a new system from scratch, explain why the existing mechanism cannot be reused.
- You may search broadly for external references (how similar open-source projects/upstream libraries do it), citing repo + file location; an external approach must map back to a concrete landing point in this codebase, and those that cannot land are not listed.
- Each route declares "under what premise it is the optimal solution"; a route that cannot answer this does not appear.
- After the input verification above is complete, if the current tool supports sub-agents and there are at least two candidate mechanisms or external reference paths that can be researched independently, dispatch sub-agents in parallel; all sub-agents must use the same verified gap, requirement scope, and evaluation dimensions, and must not apply a different standard to my idea
- Each sub-agent studies only one candidate mechanism or external reference path, and returns evidence for that mechanism and its landing point in the project, counter-evidence, unresolved assumptions for each evaluation dimension, and what it did not cover, without ranking or recommending; you make the final comparison and recommendation yourself, not by counting votes

## Comparison table

Go through every dimension for every route; each cell gets one sentence of evidence location or reasoning (mark the source for what was actually read, and state explicitly when something is inferred):
Fit with the existing architecture / Intrusion and blast radius / Compatibility breakage / Future extensibility / Implementation effort

## Recommendation verdict

- Derive with a fixed priority order: architectural fit > smaller blast radius > compatibility > extensibility > effort; the recommendation may only follow from the comparison table + this order; no reasons from outside the table.
- If my idea is not preferred, say plainly where it loses and by how much, without hedging.
- Add reversal conditions: under what premise the recommendation would switch to another route.

## Task boundary + handoff

- This round outputs only the route comparison and recommendation; file-level change lists, diffs, and implementation details belong to the next-stage design Prompt — do not output them.
- At the end of the verdict, summarize one paragraph for me to carry into the design stage: the chosen route's architectural landing point + key constraints + declared assumptions.

## Uncertainties

Ask only questions that would change the ranking or the recommendation, at most 3; for everything else proceed on the most reasonable assumption and note it on the corresponding route.
