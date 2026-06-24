# Bugfix Flow Walkthrough

This example is for when you only have a bug symptom and don't yet know where the root cause is.

The product, interfaces, and file names in this example are fictional. Do not commit real business data, customer information, credentials, or private conversations to the repository.

## Fictional scenario

You found a bug in a task management app:

> After a user marks a task as complete and refreshes the page, the task reverts to incomplete.

You are not sure whether the problem is in the front-end state, the API request, the back-end save logic, or the cache refresh.

## Step 1: Use diagnose to locate the problem

Write a clear description of the symptom at the top of your message. Add a separator line. Then paste the full content of `prompts/en/diagnose.md`.

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
[paste the full content of prompts/en/diagnose.md]
```

Codex's output should include:

- Which files it read and why it considers them relevant.
- Which conclusions are `[read-confirmed]` and which are `[assumption-needs-validation]`.
- File path and line number for the root cause.
- If the root cause still branches, a list of branches and their trigger conditions.

**Stop signal**: Codex gives a fix without reading the code, or says "I suggest you check X" instead of giving conclusions based on actually reading the code — stop, ask it to read the code first and output only analysis, not a diff.

## Step 2: Use route-without-user-idea to ask Codex for route options

After diagnosis, if you still have no good route, add route-without-user-idea to the same conversation.

```text
The problem has been located above, but I don't have a fix route yet.

Based on the current conversation context, give me route options. Read only, no edits, no diff output.

————————
[paste prompts/en/route-without-user-idea.md full content]
```

Codex's output should include:

- Where the real leverage point of the problem is.
- 2–4 routes with meaningfully different mechanisms, each stating what it bets on.
- A default recommendation and the conditions that would flip it.

**Stop signal**: Codex gives only one route, or recommends an option without comparing alternatives — stop, ask it to compare routes horizontally and show different mechanisms side by side.

Choose a route before moving to the next step.

## Step 3: Send the route discussion to Claude for an early review

When the route looks viable, copy the key Codex discussion to Claude and use `prompts/en/early-idea-review-with-code.md`.

```text
Below is my conversation with Codex about the bug cause and fix route.

[paste the key conversation: symptom, diagnosis, route options, and the route you plan to take]

Please review whether this route should advance to the plan stage.

————————
[paste prompts/en/early-idea-review-with-code.md full content]
```

Claude should say whether the route is on target, grounded in code, smaller than needed, or ready for the plan stage.

## Step 4: Send the early review back to Codex for triage

Paste Claude's full review back to Codex and use `prompts/en/review-response-triage.md`.

```text
Below is Claude's early review of the fix route. Do not accept it as-is. Verify the critique first, then decide whether the route should continue.

[Claude's full output]

————————
[paste prompts/en/review-response-triage.md full content]
```

If Codex says the route is not stable, return to Step 2 or Step 3. If the route holds, write the plan document.

## Step 5: Use small-plan to get a plan document

After the route has been reviewed and triaged, use small-plan in the same conversation.

```text
I am going with this route: fix the task completion state not being correctly persisted.

Based on the discussion above, give me a small-scope plan. Do not edit any code.

————————
[paste prompts/en/small-plan.md full content]
```

Codex's output should include:

- Which files and key locations it read.
- Diffs organized by file.
- Why each change is needed.
- Business impact (in plain terms, not code jargon).
- What to regression-test.
- Extra findings (if any).

**Stop signal**: The plan includes "also cleaned up X formatting" or "refactored Y while I was at it" — ask Codex to move these out of the diff and into the extra findings section.

## Step 6: Send the plan document to Claude for final review

Copy Codex's full plan to Claude and use `prompts/en/final-plan-review.md`.

```text
Below is Codex's formal plan. Please do the final review before execution.

[Codex's full plan]

————————
[paste prompts/en/final-plan-review.md full content]
```

Claude should only flag issues that would make the plan fail, drift from the request, or expand scope.

## Step 7: Send the final review back to Codex for triage

Copy Claude's full output back to Codex and use `prompts/en/review-response-triage.md`.

If Codex verifies that the plan must change, return to Step 5. If the route must change, return to Step 2. If the critique is invalid or already covered, proceed to execution.

## Step 8: Use small-execute to run the plan

After the plan has passed final review and triage, continue in the same conversation. This template does not need additional context — just paste the full content and send it.

```text
[paste prompts/en/small-execute.md full content]
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
- Moving to the plan stage before route review and triage.
- Letting Codex include unconfirmed formatting or refactoring in the plan.
- Running execution before final plan review and triage.
- Treating a passing type check as proof the bug is fixed, without manually reproducing the original steps.

## What you should end up with

- A root cause diagnosis backed by file and line number evidence.
- A fix route chosen after comparison, early review, and triage.
- A small-scope plan that covers only what is necessary and has passed final review triage.
- A change that was applied strictly according to the plan.
- Verification results and a list of manual regression steps.
