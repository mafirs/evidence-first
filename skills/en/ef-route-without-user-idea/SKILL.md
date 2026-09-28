---
name: ef-route-without-user-idea
description: "Route without an idea: ground the symptom in a root cause, then diverge, converge and recommend routes; read-only. Send to the main agent."
disable-model-invocation: true
---

Above is our discussion of the current problem's symptoms. I have no preset direction; you lay out the routes. This round is read-only.

## First ground the "symptom" in a "root cause / leverage point"

(Required before diverging; discussion cannot replace reading the code)
- What was discussed above are symptoms, not conclusions. First read the relevant code and pin the symptom down to where it actually originates / where the real bottleneck is (file:symbol), labeled [read-confirmed] or [assumption-needs-validation].
- Symptom ≠ root cause: if the root cause was already confirmed in the discussion, cite the confirming point in one sentence; if the discussion only reached the symptom, the root cause is undetermined, or it forks into several candidates, list the branches and their trigger conditions truthfully — in that case organize routes by root-cause branch, and do not pick one root cause by default and start diverging.
- Anti-anchoring: if some preferred direction has already surfaced in the discussion, it is only a by-product of collecting symptoms, not a starting point; the solution space stays fully open.
- Until the root cause is confirmed or the branches are fully listed, do not start parallel route divergence.

## Diverge

(Broad rather than precise; do not judge merits yet)
- Spread out across the spectrum as far as possible: incremental changes that stay close to the existing architecture / structural changes / borrowing external implementations / reframing the problem (the leverage point may be elsewhere).
- One line each: mechanism + landing point (file:symbol; if something new is needed, write "new + a one-sentence reason").
- This step does not apply the gates "must be provably optimal" or "must reuse existing mechanisms"; loosen them on purpose and list the non-obvious ones too.
- For external references give repo + file location, and state whether they can map back to this codebase; those that cannot are marked "reference only, cannot land in this codebase".
- Once the root cause or branches are clear, if the current tool supports sub-agents and there are at least two route directions that can be researched independently, dispatch sub-agents in parallel by route or root-cause branch; each sub-agent studies only one route direction or root-cause branch that you define, and returns the mechanisms actually found in code or external sources, evidence of where they land in the project, counter-evidence, assumptions, and what it did not cover, without designing the final solution or giving recommendations.

## Converge

- Cluster and merge variants into 2–4 genuinely different routes (different architectural landing point or mechanism; differences in wording/parameters do not count).
- Eliminate what cannot land or is pure noise, with one sentence on why.
- For each surviving route add: what it bets on / under what premise it is optimal; if routes hang under different root-cause branches, mark which branch each belongs to.
- Clustering, merging, elimination, comparison, and recommendation are all done by you; do not simply concatenate or decide by vote.

## Comparison table

Go through every dimension for every route; each cell gets one sentence of evidence location or reasoning (mark the source for what was actually read, and state explicitly when something is inferred):
Fit with the existing architecture / Intrusion and blast radius / Compatibility breakage / Future extensibility / Implementation effort

## Recommendation

- Do not force convergence to one route with a single priority order. Lay the routes out along "conservative increment ↔ structural refactor", give a default leaning + reason, and state "if you care more about X (long-term extensibility / minimal blast radius / fast results), switch to which route".
- If the root cause still forks, give recommendations per branch: if the root cause is A, recommend which route; if B, which one.
- Add reversal conditions.

## Task boundary + handoff

- This round outputs only the route comparison and recommendation; file-level change lists, diffs, and implementation details belong to the next-stage design Prompt — do not output them.
- At the end, summarize one paragraph for me to carry into the design stage: the chosen route's architectural landing point + key constraints + declared assumptions (including the chosen root-cause branch).

## Uncertainties

Ask only questions that would change the root-cause judgment, the set of routes, or the recommendation leaning, at most 3; for everything else proceed on the most reasonable assumption and note it on the corresponding route.
