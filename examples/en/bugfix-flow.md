# Bugfix Flow Walkthrough

This example is for when you only have a bug symptom and don't yet know where the root cause is.

The product, interfaces, and file names in this example are fictional. Do not commit real business data, customer information, credentials, or private conversations to the repository.

## Fictional scenario

You found a bug in a task management app:

> After a user marks a task as complete and refreshes the page, the task reverts to incomplete.

You are not sure whether the problem is in the front-end state, the API request, the back-end save logic, or the cache refresh.

## Step 1: Use 01-diagnose to locate the problem

Write a clear description of the symptom at the top of your message. Add a separator line. Then paste the full content of `prompts/en/01-diagnose.md`.

```text
Current bug: on the task detail page, clicking "Complete" briefly shows the task as complete; after refreshing the page, the task shows as incomplete again.

Reproduction steps:
1. Open any incomplete task.
2. Click "Complete."
3. Wait for the page to show the task as complete.
4. Refresh the page.
5. The task shows as incomplete again.

Please confirm whether this bug exists and locate where it actually comes from.

————————
[paste the full content of prompts/en/01-diagnose.md]
```

Codex's output should include:

- Which files it read and why it considers them relevant.
- Which conclusions are `[read-confirmed]` and which are `[assumption-needs-validation]`.
- File path and line number for the root cause.
- If the root cause still branches, a list of branches and their trigger conditions.

**Stop signal**: Codex gives a fix without reading the code, or says "I suggest you check X" instead of giving conclusions based on actually reading the code — stop, ask it to read the code first and output only analysis, not a diff.

## Step 2: Use 04-route to ask Codex for route options

After diagnosis, if you still have no good route, add 04-route-without-user-idea to the same conversation.

```text
The problem has been located above, but I don't have a fix route yet.

Based on the current conversation context, give me route options. Read only, no edits, no diff output.

————————
[paste prompts/en/04-route-without-user-idea.md full content]
```

Codex's output should include:

- Where the real leverage point of the problem is.
- 2–4 routes with meaningfully different mechanisms, each stating what it bets on.
- A default recommendation and the conditions that would flip it.

**Stop signal**: Codex gives only one route, or recommends an option without comparing alternatives — stop, ask it to compare routes horizontally and show different mechanisms side by side.

Choose a route before moving to the next step.

## Step 3: Use 05-small-plan to get an implementation plan

After confirming the route, use 05-small-plan in the same conversation.

```text
I am going with this route: fix the task completion state not being correctly persisted.

Based on the discussion above, give me a small-scope plan. Do not edit any code.

————————
[paste prompts/en/05-small-plan.md full content]
```

Codex's output should include:

- Which files and key locations it read.
- Diffs organized by file.
- Why each change is needed.
- Business impact (in plain terms, not code jargon).
- What to regression-test.
- Extra findings (if any).

**Stop signal**: The plan includes "also cleaned up X formatting" or "refactored Y while I was at it" — ask Codex to move these out of the diff and into the extra findings section.

## Step 4: Use 07-small-execute to run the plan

After confirming the plan, continue in the same conversation. This template does not need additional context — just paste the full content and send it.

```text
[paste prompts/en/07-small-execute.md full content]
```

Codex should check `git status` first, then apply the plan diffs mechanically.

Codex's report should include:

- Which files it changed and which plan diff each corresponds to.
- Which diffs it skipped, and why (diff didn't match, assumption didn't hold, etc.).
- Compilation and type check results.
- Self-review: does the change match the plan? Any doubts?
- Issues found but not handled (if any).
- Confirmation that files outside the plan were not touched.

**Stop signal**: Codex's report includes changes outside the plan — reformatting, renaming a variable, touching an unrelated file — stop, ask it to revert those changes and keep only what is in the plan.

**Final step**: Follow the regression test checklist from the plan and manually reproduce the original bug to confirm it is fixed. A passing type check does not mean the bug is fixed.

## Common mistakes

- Asking Codex to write a fix before the diagnose stage has read the code.
- Moving to the plan stage before a route is confirmed.
- Letting Codex reformat or refactor during the plan stage.
- Running execution without confirming the plan content first.
- Treating a passing type check as proof the bug is fixed, without manually reproducing the original steps.

## What you should end up with

- A root cause diagnosis backed by file and line number evidence.
- A fix route chosen after comparison.
- A small-scope plan that covers only what is necessary.
- A change that was applied strictly according to the plan.
- Verification results and a list of manual regression steps.
