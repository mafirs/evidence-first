# Bugfix Flow Example

This example shows how to move from a bug symptom to diagnosis, route comparison, surgical plan, strict execution, and closeout.

The codebase and file names are fictional. The goal is to demonstrate the workflow shape without leaking private project context.

## Flow

1. Start with `prompts/en/01-diagnose.md` to prove the symptom from code.
2. Use `prompts/en/02-route-known-problem.md` to compare root-cause and stopgap routes.
3. Use `prompts/en/05-small-plan.md` or `prompts/en/06-large-plan.md` to write the surgical diff.
4. Use `prompts/en/08-strict-execute.md` to apply only the approved diff.
5. Close out with verification, skipped items, and manual regression points.
