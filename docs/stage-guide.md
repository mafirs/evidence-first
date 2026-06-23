# Stage Guide

Use this guide to choose the right workflow stage and the right usage mode.

## Two usage modes

### Prompt template mode

Use this when you want to manually copy a prompt.

1. Write the task context first: issue symptoms, prior discussion, your idea, a plan, or another agent's review.
2. Add a separator line: `————————`.
3. Open the matching file under `prompts/en/` or `prompts/zh-CN/`.
4. Copy the full template after the separator into your AI coding tool.
5. Do not commit private task context.

### Skill mode

Use this when Codex can invoke `evidence-first-dev-workflow`.

Do not edit Skill files or references to paste task context. Provide context in the chat message, a linked file, or a plan document path. The Skill provides stable workflow rules; the user message provides task-specific context.

See `docs/context-injection.md` for examples.

## Choose the stage

| Situation | Stage | Prompt template | Skill-mode request |
|---|---|---|---|
| You only know the symptom | Diagnose | `diagnose.md` | “Use evidence-first-dev-workflow to diagnose this issue. Context: …” |
| You have an idea but want it challenged | Route | `route-with-user-idea.md` | “Use the route-with-user-idea stage. My idea is …” |
| You have context but no good route yet | Route | `route-without-user-idea.md` | “Use the route-without-user-idea stage. Context: …” |
| You need a small bugfix or small feature plan | Plan | `small-plan.md` | “Use the small-plan stage. Do not edit files.” |
| You need a large feature or wide logic-change plan | Plan | `large-plan.md` | “Use the large-plan stage. Do not edit files.” |
| You approved a small plan | Execute | `small-execute.md` | “Use strict execution for the approved small plan.” |
| You approved a large plan | Execute | `strict-execute.md` | “Use strict execution for `<PLAN_DOCUMENT_PATH>`.” |
| You want another agent to review an early idea with code access | Review | `early-idea-review-with-code.md` | “Review this early idea with code access. Context: …” |
| You want another agent to review an early idea from chat only | Review | `early-idea-review-from-chat.md` | “Review this early idea from conversation only. Context: …” |
| Another agent should review a formal plan before execution | Review | `final-plan-review.md` | “Review this final plan before execution. Plan: …” |
| The original conversation agent needs to triage another agent's review | Review | `review-response-triage.md` | “Use review-response triage. Review text: …” |

## Rule of thumb

If the prompt needs pasted context, use one of these channels:

- Current chat message for short or medium context.
- A local file path for long context.
- A plan document path for execution.

Do not paste private context into Skill references.
