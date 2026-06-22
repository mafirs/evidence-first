# Stage Guide

Use this guide to choose the right workflow stage and the right usage mode.

## Two usage modes

### Prompt template mode

Use this when you want to manually copy a prompt.

1. Open the matching file under `prompts/en/` or `prompts/zh-CN/`.
2. Paste task context into the placeholder if the prompt needs it.
3. Copy the full prompt into your AI coding tool.
4. Do not commit private task context.

### Skill mode

Use this when Codex can invoke `evidence-first-dev-workflow`.

Do not edit Skill files or references to paste task context. Provide context in the chat message, a linked file, or a plan document path. The Skill provides stable workflow rules; the user message provides task-specific context.

See `docs/context-injection.md` for examples.

## Choose the stage

| Situation | Stage | Prompt template | Skill-mode request |
|---|---|---|---|
| You only know the symptom | Diagnose | `01-diagnose.md` | “Use evidence-first-dev-workflow to diagnose this issue. Context: …” |
| You know the bug cause and need fix options | Route | `02-route-known-problem.md` | “Use the route stage for this diagnosed problem. Context: …” |
| You have an idea but want it challenged | Route | `03-route-with-user-idea.md` | “Use the route-with-user-idea stage. My idea is …” |
| You have no idea yet | Route | `04-route-without-user-idea.md` | “Use the route-without-user-idea stage. Symptoms: …” |
| You need a small patch plan | Plan | `05-small-plan.md` | “Use the small-plan stage. Do not edit files.” |
| You need a multi-file plan | Plan | `06-large-plan.md` | “Use the large-plan stage. Do not edit files.” |
| You approved a plan | Execute | `07-small-execute.md` or `08-strict-execute.md` | “Use strict execution for `<PLAN_DOCUMENT_PATH>`.” |
| Another AI reviewed the plan | Review | `12-review-response-triage.md` | “Use review-response triage. Review text: …” |

## Rule of thumb

If the prompt needs pasted context, use one of these channels:

- Current chat message for short or medium context.
- A local file path for long context.
- A plan document path for execution.

Do not paste private context into Skill references.
