---
name: evidence-first-dev-workflow
description: Use when Codex is asked to diagnose, plan, implement, review, or execute software changes using an evidence-first AI-native development workflow. Triggers include bug investigation, codebase diagnosis, route comparison, implementation planning, surgical diff execution, adversarial code review, responding to another AI's critique, or preventing speculative/overbroad AI coding changes. The workflow enforces code reading before claims, file:line evidence, fact-vs-inference labels, staged separation, minimal changes, and verification before completion.
---

# Evidence-first Dev Workflow

Use this Skill as a stage router. Do not load every reference by default. Load only the reference that matches the current task.

## Stage router

- Diagnose a bug or locate relevant code: read `references/01-diagnose.md`.
- Compare possible routes: read `references/02-route.md`.
- Write an implementation plan without editing code: read `references/03-plan.md`.
- Execute an approved plan: read `references/04-execute.md`.
- Review a plan or another AI's critique: read `references/05-review.md`.
- Prepare final delivery: read `references/06-closeout.md`.

## Always-on protocol

Read `references/00-core-protocol.md` when the task involves code claims, file edits, plan review, or execution.

## Non-negotiables

- Do not mix diagnosis, route selection, planning, and execution.
- Do not edit files during diagnosis, route, plan, or review stages.
- Every key code claim needs file:line evidence or an explicit assumption label.
- Touch only what the confirmed stage allows.
- Report unrelated findings separately.
- Stop on real blockers: missing required input, missing files, destructive operation approval, or conflict between the approved plan and current code.
