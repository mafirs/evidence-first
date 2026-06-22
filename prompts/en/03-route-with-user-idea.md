# 03 — Route When the User Has an Idea

The user has already provided a focus point, current gap, and their own idea. This stage is read-only: produce route comparison and recommendation.

## Validate input before routing

- Verify whether the stated gap is real by reading the relevant code. Mark it `[read-confirmed]` or `[assumption-needs-validation]`.
- Evaluate the user's idea without defaulting to it. State whether it is technically valid, where it would land using `file:symbol`, and whether it has blockers.

## Route discipline

- The scope is eliminating the stated gap, not implementing the user's idea. The user's idea is a candidate, not a constraint.
- Compare the user's idea against other routes in the same table. If it loses, say exactly where and by how much. Do not politely accept it by default.
- Routes must differ in architecture landing point or mechanism. Produce 1-3 routes. Do not pad.
- Anchor each route to an existing mechanism or extension point. If a route requires new structure, explain why existing mechanisms cannot be reused.
- External references are allowed only when they map back to this repository.
- Each route must state the condition under which it is best.

## Comparison table

Dimensions: architecture fit / intrusion and blast radius / compatibility impact / future extensibility / implementation effort

## Recommendation

Derive the recommendation from the table using this priority: architecture fit > smaller blast radius > compatibility > extensibility > effort.

If the user's idea is not preferred, say exactly where it loses. Include reversal conditions.

## Handoff

End with: selected landing point + key constraints + declared assumptions.
