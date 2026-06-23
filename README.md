# Evidence-first Dev Workflow

English | [简体中文](README.zh-CN.md)

Evidence-first Dev Workflow is a staged Prompt workflow for AI coding: read code first, compare routes, confirm the plan, execute strictly, then close with verification and adversarial review.

It is not a universal Prompt, and it is not an autopilot flow that asks AI to go from request to production in one jump. Its goal is narrower: when you already use AI for coding but often get burned by guessing, scope creep, or premature implementation, these staged templates pull the agent back to evidence, boundaries, and verification.

## What problem it solves

The dangerous part of AI coding is usually not that the agent cannot write code. It is that the agent moves into implementation too quickly:

- It guesses before reading the relevant code.
- It mixes diagnosis, route selection, planning, and execution.
- It refactors, reformats, or touches unrelated files.
- It treats typecheck success as proof that behavior is correct.
- It accepts or rejects another AI's review without verifying the evidence.

This workflow does not ask the agent to jump from one request to the final patch. It splits development into stages that can be checked, stopped, and reviewed.

## Quick start: copy one Prompt

The recommended path is to copy a Prompt template directly.

1. First write the current issue, prior discussion, or your own idea in the message.
2. Add a separator line: `————————`.
3. Open the matching template under `prompts/en/` and copy its full content after the separator.
4. Send the complete message to your AI coding tool.
5. Follow the template boundary: read-only stages stay read-only, planning stages only produce a plan, and execution stages only apply confirmed changes.

If all you know is that something is broken, start with `prompts/en/01-diagnose.md`.

## Choose a template by situation

| Stage | Current situation | Template |
|---|---|---|
| Diagnose | Find the cause of a bug or locate relevant code | `prompts/en/01-diagnose.md` |
| Route | You have an idea and want the AI to challenge it | `prompts/en/03-route-with-user-idea.md` |
| Route | You have context but no good route yet, or you need the agent to propose one | `prompts/en/04-route-without-user-idea.md` |
| Plan | You need a small change plan without editing code | `prompts/en/05-small-plan.md` |
| Plan | You need a multi-file or complex change plan | `prompts/en/06-large-plan.md` |
| Execute | You approved a small plan and need to execute it | `prompts/en/07-small-execute.md` |
| Execute | You approved a large plan and need strict execution | `prompts/en/08-strict-execute.md` |
| Review | You want another agent to review an early idea with code access | `prompts/en/09-early-idea-review-with-code.md` |
| Review | You want another agent to review an early idea from conversation only | `prompts/en/10-early-idea-review-from-chat.md` |
| Review | You want a final adversarial review before execution | `prompts/en/11-final-plan-review.md` |
| Review | You need to triage another agent's critique without blindly accepting it | `prompts/en/12-review-response-triage.md` |

## Five-stage workflow

```mermaid
flowchart LR
  A["Diagnose\nread-only code"] --> B["Route\ncompare fixes"]
  B --> C["Plan\nwrite the implementation plan"]
  C --> D["Execute\napply the confirmed diff"]
  D --> E["Review\nverify and close out"]
```

1. **Diagnose**: read code only, cite file-line evidence, and separate fact from inference.
2. **Route**: compare mechanisms before writing diffs.
3. **Plan**: produce the implementation plan without editing code.
4. **Execute**: apply only the confirmed diff, with no opportunistic refactor.
5. **Review**: challenge findings, verify critiques, and archive low-value comments.

The core principles are evidence discipline, phase separation, minimal change, and verification closure.

## How to fill task context

Many templates need task-specific context, such as issue symptoms, prior conversation, an existing plan, or another AI's review.

Prompt templates are copyable and editable working drafts. You can temporarily paste context into a local template, copy the complete Prompt into the AI tool, then undo the local edit or make sure private context is not committed.

If the context is long, you can put it in a local file and ask the agent to read that file path in the Prompt.

See `docs/context-injection.md` for more examples.

## Codex Skill auxiliary entry

If you use this repository with Codex, you can install or copy `skills/evidence-first-dev-workflow/` as a Codex Skill.

The Skill loads stable stage rules and can reduce repeated protocol text. But it is not the recommended main path: when a task needs context, you still need to provide that context in the chat message, or provide a file path or plan document path for the agent to read.

Do not edit files under `skills/evidence-first-dev-workflow/` to paste one-off task context. Skill files are stable rules, not scratchpads.

## Project-level integrations

If you want to put these rules into project-level constraints, see:

- `integrations/AGENTS.md`: Codex-style project instructions.
- `integrations/CLAUDE.md`: Claude Code project instructions.
- `integrations/cursor-rules.mdc`: Cursor rules.

These integrations are useful for long-term agent behavior constraints. For day-to-day work on a specific issue, the recommended path is still to copy the matching Prompt template.

## Safety boundaries

This workflow improves control over AI coding, but it does not replace approval, rollback, audit, and permission boundaries for high-risk operations.

The following situations need extra controls:

- Production releases.
- Database migrations.
- Payment, billing, permission, or other irreversible high-risk changes.
- Automatic remote push and deployment.

## Repository structure

```text
README.md                 English entry point
README.zh-CN.md           Chinese entry point
docs/                     Workflow notes and context injection guidance
prompts/zh-CN/            Chinese Prompt templates
prompts/en/               English Prompt templates
skills/evidence-first-dev-workflow/  Codex Skill auxiliary entry
integrations/             AGENTS.md / CLAUDE.md / Cursor rules
examples/                 Chinese example flows
examples/en/              English example flows
```

## More documentation

- `docs/stage-guide.md`: choose the right stage and usage mode.
- `docs/context-injection.md`: where task context should go.
- `docs/workflow.md`: overview of the five-stage workflow.
- `examples/en/bugfix-flow.md`: bugfix flow example.
- `examples/en/feature-flow.md`: feature development flow example.
- `examples/en/adversarial-review-flow.md`: adversarial review flow example.

## License

MIT
