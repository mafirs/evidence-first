---
name: ef-strict-execute
description: "Strict execute: apply a reviewed plan document with pre-checks and a full completion report. Send to the main agent."
disable-model-invocation: true
---

Execute the code changes according to the plan document `<PLAN_DOCUMENT_PATH>`.

## Execution scope

- Execute the diffs in [Plan details] / [What to change]: all (a) required and (b) safety/robustness-required changes; skip (c) optional optimizations
- Do not change files, functions, or lines not listed in the plan
- [Extra findings] [Business impact] [Regression testing] [Not modified] are reference information, not execution items
- Single writer this round: do not start several sub-agents to generate, apply, or modify diffs in parallel, and do not let sub-agents change the current working tree at the same time; you make all code changes yourself, in plan order

## Before starting

1. Run `git status` and paste the result. If the working tree has uncommitted changes (untracked files excepted), stop and ask me whether to stash first or continue
2. Read the current content of every file listed in [Read scope]
3. Check how each diff aligns with the current code, and handle it in one of three ways:
   - Context fully aligned → execute normally
   - Line numbers drifted but the function/anchor code is still there → locate by anchor and execute, and mark it "anchor-aligned execution" in the report
   - The function no longer exists / the key code has been rewritten / it contradicts the plan's description at the logic level → stop executing that item, record it in the "plan vs. reality conflicts" list, and wait for my decision
4. If an [assumption] item in the plan does not match the actual code, also record it in the conflict list; do not guess how to apply it

## During execution

- Apply the diffs mechanically, without extra rewriting: no reformatting, no added comments, no refactoring, no fixing bugs along the way
- If you find bugs or hidden risks outside the plan, record them in the "found but not handled" list; do not touch them
- If compilation / type checking fails:
  - If it is a mechanical slip made while applying the diff (missing import, unbalanced brackets, obvious typo) → you may fix it yourself, but you must mark it "self-fixed" in the report and list what was fixed
  - If it is a logic problem in the plan itself → do not fix it; paste it as is and wait for my decision
- After all code changes are complete, verification commands that are independent of each other and do not change tracked files may run in parallel; this does not authorize any agent to fix plan logic on its own or to widen the diff

## Completion report

1. Check whether tracked files have uncommitted changes (ignore untracked new files). If so, note it in one sentence at the start of the report (for example "tracked files had uncommitted changes before execution, involving X files; this git diff may include content outside the task"), then continue. Untracked files need no handling and no report
2. Git changes:
   - `git diff --stat` output
   - If any file not listed in the plan was touched, explain why separately
   - No need to paste the full diff; I will ask for it separately if needed
3. Diffs not executed: number + reason
4. Plan vs. reality conflicts: list where the plan's description contradicts the actual code, and state the conflict clearly
5. Compilation / type-check results: command + output. If anything was self-fixed, list it separately
6. Self-review (switch to a code reviewer's perspective, reread every change, and answer item by item):
   - Did it change the function's original behavior boundaries (input range, return values, error cases)?
   - Do callers need to be adjusted accordingly? Are any call sites missed?
   - Did it introduce new dependencies (packages, global state, side effects)?
   - Is this change still correct in boundary cases (null values, concurrency, extreme input)?
   - If you find doubts, say so directly; do not force it through just to finish
7. Points for me to confirm manually: from the plan's [Regression test checklist], list the items this change actually triggers (items listed in the plan but not touched by this change need not be listed). State the action and the expected result
8. Problems found but not handled: bugs or hidden risks noticed outside the plan
9. Untouched areas: confirm that files outside the change scope were not changed by a single line
