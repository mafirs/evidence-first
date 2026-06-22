# Route Stage

Use this stage after diagnosis, before writing diffs.

## Known problem

Generate 1-3 genuinely different routes. Each route must say whether it removes the root cause or only the trigger, what tradeoff it makes, and where it lands in the existing code.

## User has an idea

Verify the stated gap first. Treat the user's idea as a candidate, not a constraint. Compare it fairly with other routes and state where it wins or loses.

## No preset idea

Ground the symptom in code before generating routes. If root cause is forked, organize routes by cause branch. Diverge broadly, then converge into 2-4 real routes.

## Recommendation

Use an explicit comparison table. Mark evidence and inference. Include reversal conditions for the preferred route.

Do not output file-level change lists, diffs, or implementation details in this stage.
