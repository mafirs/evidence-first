# Evidence-first Dev Workflow

A staged AI-native development workflow that forces coding agents to read code, cite evidence, compare routes, write surgical plans, execute only confirmed diffs, and review adversarially.

## Why this exists

AI coding agents are strong at writing code, but they often fail in predictable ways:

- They assume instead of reading the code.
- They mix diagnosis, planning, and execution.
- They refactor or reformat unrelated code.
- They treat type checks as proof of behavior.
- They accept or reject another AI's review without re-checking evidence.

This workflow turns coding with AI into five separate stages:

1. Diagnose with code evidence.
2. Compare routes before choosing a fix.
3. Write a surgical implementation plan.
4. Execute only the confirmed diff.
5. Run adversarial review and close out with verification.

## Quick start

Use the prompt that matches your current stage:

| Stage | Use this prompt |
|---|---|
| Find the cause of a bug | `prompts/en/01-diagnose.md` |
| Compare fixes after diagnosis | `prompts/en/02-route-known-problem.md` |
| Challenge your own idea | `prompts/en/03-route-with-user-idea.md` |
| Explore routes from symptoms | `prompts/en/04-route-without-user-idea.md` |
| Ask for a small plan | `prompts/en/05-small-plan.md` |
| Ask for a large plan | `prompts/en/06-large-plan.md` |
| Execute an approved plan | `prompts/en/08-strict-execute.md` |
| Review another AI's critique | `prompts/en/12-review-response-triage.md` |

## Codex Skill

Install or copy `skills/evidence-first-dev-workflow/` into your Codex skills directory.

The Skill acts as a router. It loads only the workflow reference needed for the current stage instead of loading every prompt into context.

## Integrations

- `integrations/AGENTS.md` for Codex-style project instructions.
- `integrations/CLAUDE.md` for Claude Code.
- `integrations/cursor-rules.mdc` for Cursor.

## License

MIT
