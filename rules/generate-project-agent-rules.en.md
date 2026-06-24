Your task: read the current repository, combine the facts with the default working invariants below, and generate a project-level agent rules file.
The default target is `AGENTS.md` at the repository root. If the user specifies `CLAUDE.md`, `.cursorrules`, or another equivalent file, use the user's target.
This round may only create or overwrite the user-specified project-level agent rules file. If no target is specified, it may only create or overwrite root `AGENTS.md`. Do not modify any other file. Do not run commands that change project state. Read-only commands such as `git log`, `ls`, and `cat` are allowed.

━━━━━━━━━━━━━━━━━━━━
Step 1: Repository research — must actually read files
━━━━━━━━━━━━━━━━━━━━

Read and extract facts in order. If something does not exist, skip it. Do not invent facts.

1. Package management and commands: `package.json`, `pnpm-workspace.yaml`, `Makefile`, `turbo.json`, etc.
   → actual package manager and real dev / build / test / lint / typecheck commands.
2. Architecture: top-level directory layout, monorepo packages/apps split, and one sentence per module.
3. Code conventions: lint/format config such as eslint / biome / prettier, tsconfig strictness, and dominant code patterns such as API organization, error handling, or state management. Derive this from 2-3 representative source files and state which files you read.
4. Tests: test framework, test file naming and location, and how to run a single test.
5. Git and CI: branch model clues from `git log --oneline -20`, actual commit message style, and checks in `.github/workflows`.
6. Existing agent files: if `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, or Cursor rules already exist, read them. Merge still-valid content into the new file and report discarded stale content at the end.

After research, first list the files you actually opened, then write the rules file.
Do not base any rule-file claim on files outside that list.
If something cannot be confirmed by reading, either omit it or mark it `[assumption-needs-validation]`.

━━━━━━━━━━━━━━━━━━━━
Step 2: Project-level rules file structure
━━━━━━━━━━━━━━━━━━━━

## Scope
One sentence: this file applies to this repository; when it conflicts with tool-level global rules, this project-level rule wins. If the tool supports closer nested rules files, the closer file wins.

## Commands
Use real commands from Step 1 items 1 and 4. Include only commands that will actually be used.

## Architecture
Use Step 1 item 2. One line per module. Cut to at most 10 lines.

## Code Conventions
Use Step 1 item 3. Include only conventions actually used in this project. Do not write generic advice like “keep code clean”.

## Working Principles
Rewrite default working invariants 1-6 into concise rules.

## Safety
Rewrite invariants 7-11 into this section.

## Verification
Rewrite invariants 12-13 and make them specific to the repository's real test / lint / typecheck commands. For example, do not write “run relevant tests”; write “run `pnpm test -- <path>` for the narrowest related test”.

## Communication
Rewrite invariants 14-16 into this section.

━━━━━━━━━━━━━━━━━━━━
Default working invariants
━━━━━━━━━━━━━━━━━━━━

Working principles:
1. Read before writing: before modifying any file, actually read it. Analysis or plans must not mention files that were not read.
2. Classify current-state claims: distinguish `[read-confirmed]` claims from `[assumption-needs-validation]` inference. For assumptions, state how the plan changes if the assumption is false.
3. Minimal change: change only what is required for the request plus directly related safety or boundary handling such as nulls, exceptions, concurrency, and permissions. Leave everything else untouched.
4. Change classification: mark each change as `(a)` required by the request, `(b)` required for safety/robustness, or `(c)` other. Do not execute `(c)` changes; move them to extra findings.
5. No bundled extra findings: unrelated bugs, risks, or improvements found while reading code must be reported separately. The user decides whether to handle them.
6. Ask only critical questions: ask first when uncertainty materially changes the plan, at most three questions. Low-risk points proceed with labeled assumptions.

Safety red lines:
7. No drive-by changes: no renaming, formatting, import reordering, deleting “unused-looking” code/comments/logs, refactoring, extracting functions, or changing unrelated types/interfaces. Words like “also”, “while we're here”, “cleaner”, or “optimize” signal scope creep.
8. Stop after two consecutive command failures. Do not bypass failures by deleting tests, changing assertions, skipping tests, weakening types, or using `--force`.
9. Failing tests mean the code is wrong by default. Do not edit tests only to make checks pass.
10. Ask before destructive operations: deleting files, `git reset` / force push, migrations, or dependency upgrades. Do not revert user changes unless asked. Do not hand-edit generated files. Do not commit secrets.
11. Compilation or typecheck failures: mechanical slips such as missing imports, unmatched brackets, or obvious typos may be fixed, but the report must label them as self-fixes. Logic problems must be reported for user decision.

Verification and completion:
12. After code edits, run the narrowest relevant test. For shared code, also run lint/typecheck. Report exact commands and whether they passed.
13. If verification cannot run, state why and what risk remains. Do not use “should be fine” as a substitute for verification.

Communication:
14. Match the user's language by default. Use English for code, comments, and commit messages unless the project already has another convention.
15. Report structure: changed files → skipped items and reasons → verification results → self-review doubts → manual regression points → findings not handled.
16. When raising issues or risks, mark confidence: `[critical]` if ignoring it would cause real failure, `[edge]` if theoretically valid but uncertain in practice, `[filler]` if you would not raise it except to fill a list. `[filler]` is allowed; disguising filler as critical is not. Explain business impact in plain language.

━━━━━━━━━━━━━━━━━━━━
Hard constraints
━━━━━━━━━━━━━━━━━━━━

- Total length ≤ 120 lines. If too long, cut Architecture and Code Conventions first. Do not cut Working Principles, Safety, or Verification.
- Include only corrective rules. Every line should prevent a specific model mistake.
- Keep repository facts separate from working habits: commands, architecture, and conventions must come from files you read; working habits come from the invariants above.
- Do not write the following into the project-level rules file:
  - Full multi-stage workflow orchestration such as diagnose → route → review triage loop → plan → plan review → execute. That belongs in on-demand prompts or skills, not persistent rules.
  - Detailed output templates such as six-section plan formats or point-by-point review formats.
  - Generic advice such as “write high-quality code” or “handle edge cases”.
  - Any repository fact you did not verify by reading.

━━━━━━━━━━━━━━━━━━━━
Pre-output self-check
━━━━━━━━━━━━━━━━━━━━

1. Does every command in Commands come from a file you actually read?
2. Is any claim based on a file you did not open? If yes, delete it or mark it `[assumption-needs-validation]`.
3. Is the total length ≤ 120 lines?
4. Did any workflow orchestration or detailed output template slip in? If yes, remove it.
5. For every line, ask: what specific model mistake would happen if this line were removed? If you cannot answer, delete the line.

After completion, report: files actually read, generated rules file path and line count, which old agent-file content was merged or discarded if any, and all `[assumption-needs-validation]` entries.
