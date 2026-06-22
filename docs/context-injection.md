# Context Injection

Some workflow stages need task-specific context: prior conversation, a draft idea, a formal plan, or another AI's review. In the original manual workflow, you might paste that context into a local Markdown prompt, copy the whole thing, then undo the edit.

That still works for `prompts/`, but it is not how Skills should be used.

## Principle

- Prompt templates are editable working copies.
- Skill files are stable workflow rules.
- Task context belongs in the user message, a linked file, or a plan document path.

Do not edit `skills/evidence-first-dev-workflow/SKILL.md` or files under `skills/evidence-first-dev-workflow/references/` to insert private context.

## Pattern 1: context is already in the current chat

```text
Use evidence-first-dev-workflow and enter the route-without-user-idea stage for the issue discussed above.
This round is read-only: diagnose the real leverage point, then diverge, converge, compare routes, and recommend.
```

## Pattern 2: context is not in the current chat

```text
Use evidence-first-dev-workflow and enter the early-idea-review-with-code stage.

Context:
<PASTE_CONVERSATION_CONTEXT_HERE>

Read the relevant code before judging whether the idea should proceed.
```

## Pattern 3: execution from a plan document

```text
Use evidence-first-dev-workflow and enter strict execution stage.
Execute the plan at:
<PLAN_DOCUMENT_PATH>

Follow the plan exactly. Do not touch files outside the plan.
```

## Pattern 4: another AI's critique

```text
Use evidence-first-dev-workflow and enter review-response-triage stage.

Critique:
<PASTE_REVIEW_HERE>

Do not accept the critique blindly. Verify core claims and produce a decision list.
```

## When to ask for context

The agent should ask for missing context only when all of the following are true:

1. The current chat does not contain enough task context.
2. No file path or plan path was provided.
3. A reasonable assumption would materially change the result.

Otherwise, proceed with a clearly labeled assumption.

## Safety note

Before publishing or committing, search for private context, local absolute paths, credentials, internal project names, and pasted conversation excerpts.
