The prior discussion describes symptoms, not a solution. The user has no preset direction. This stage is read-only.

## Ground symptoms in cause or leverage

Before generating routes, read the relevant code and connect the symptom to its actual origin or leverage point using `file:symbol`.

If the cause is still forked, list the branches and their triggers. Organize routes by cause branch instead of silently choosing one.

Avoid anchoring on directions that surfaced during discussion. Treat them as symptom notes, not starting constraints.

## Diverge

Explore broadly before judging:

- Incremental changes close to existing architecture.
- Structural changes.
- External implementation patterns.
- Reframing the problem if the leverage point is elsewhere.

Each idea should be one line: mechanism + landing point. If new structure is needed, say `new + reason`.

## Converge

Cluster and merge variants into 2-4 genuinely different routes. Writing or parameter differences do not count.

Drop routes that cannot land in this repo or are pure noise, with one sentence explaining why.

For each surviving route, state what it is betting on and when it is best. If routes depend on different cause branches, label the branch.

## Comparison table

Dimensions: architecture fit / intrusion and blast radius / compatibility impact / future extensibility / implementation effort

## Recommendation

Do not force a single winner if the cause is still forked. Lay routes across the conservative-to-structural spectrum. Give a default leaning and explain which route wins if the user prioritizes long-term extensibility, minimal blast radius, or fast recovery.

End with: selected route or branch-based route + landing point + constraints + assumptions.
