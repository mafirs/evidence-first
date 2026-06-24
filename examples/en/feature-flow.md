# Feature Flow Walkthrough

This example is for when you already have an implementation idea but are not sure it is the right route.

The product, interfaces, and file names in this example are fictional. Do not commit real business data, customer information, credentials, or private conversations to the repository.

## Fictional scenario

You want to improve the search experience in a document collaboration app:

> The current search only matches document titles. You want to add the ability to search document body content.

Your initial idea is:

> Pull all document content to the front end when the page loads, then do full-text search in the browser.

You are worried this might cause performance and permission issues, but you have not looked at the code yet. You do not know whether the project already has a search API or indexing mechanism.

## Step 1: Use route-with-user-idea to have Codex challenge your idea

Write out the current gap, your idea, and your concerns. Add a separator line. Then paste the full content of `prompts/en/route-with-user-idea.md`.

```text
Current gap: the search box only matches document titles, not keywords in the body.

My idea: pull all document body content to the front end when the page loads, then do full-text search in the browser.

My concerns: this might slow down the initial page load, and might expose documents the user should not see.

Read only this round. Please first verify whether the current gap is real, then evaluate whether my idea is viable. My idea is a candidate, not a constraint.

————————
[paste prompts/en/route-with-user-idea.md full content]
```

Codex's output should include:

- Whether the current gap is real (confirmed by reading the code).
- Whether your idea is technically viable, and whether there are any blocking problems.
- A comparison table of your idea against other routes.
- A recommended route and the conditions that would flip it.

**Stop signal**: Codex adopts your idea directly because you proposed it, without comparing alternatives — stop, ask it to treat your idea as one candidate and compare it against other routes on equal footing.

## Step 2: Send the Codex conversation context to Claude for an early review

When the route looks promising but you want Claude to find problems before a formal plan is written, copy the conversation context from Codex to Claude and use `prompts/en/early-idea-review-with-code.md`.

Replace the `<PASTE_CONVERSATION_CONTEXT_HERE>` placeholder in the template with the key content from your Codex conversation.

Claude's output should include:

- A restatement of the original goal and current direction.
- A list of files Claude actually opened.
- A line-by-line verification of Codex's code state claims, labeled with agreement status.
- Whether there is a smaller path (if yes, specific file:line).
- Conclusion: blocking finding found, or direction can advance to the plan stage.

**Stop signal**: Claude raises a concern with no code evidence, only "this might be a problem" — ask it to provide a specific file and line, or explicitly acknowledge that this is an inference, not a code-confirmed finding.

If Claude does not have code access, use `prompts/en/early-idea-review-from-chat.md` instead, but this path is generally less reliable than the code-access early review path.

## Step 3: Send the early review back to Codex for direction triage

Copy Claude's full output to Codex and use `prompts/en/review-response-triage.md`.

```text
Below is Claude's early review of the current route. Do not accept it as-is — turn it into a decision checklist for whether this direction should continue.

[Claude's full output]

————————
[paste prompts/en/review-response-triage.md full content]
```

If Codex says the current route is not stable, return to Step 1 or Step 2. If the route holds, write the plan document.

## Step 4: Ask Codex for a plan document

After the route has passed early review and triage, choose small-plan or large-plan based on scope, in the same Codex conversation.

```text
I am going with this route: reuse the back-end search API, extend query scope on the server side to include body content, and keep the existing permission filtering.

Based on the discussion above, give me an implementation plan. Do not edit any code.

————————
[paste prompts/en/large-plan.md full content]
```

Codex's output should include:

- Which files and key locations it read.
- Diffs organized by file, each change categorized (required / safety/robustness / other).
- Business impact in plain terms, not code jargon.
- Regression test checklist.
- Extra findings and a declaration of what was not touched.

**Stop signal**: The plan includes a change categorized as "other" that is still in the diff, or the "business impact" section uses code terminology — ask Codex to remove out-of-scope changes and rewrite the impact in user behavior terms.

## Step 5: Send the plan document to Claude for a final adversarial review

Copy Codex's full plan to Claude and use `prompts/en/final-plan-review.md`.

Replace the `<PASTE_PLAN_HERE>` placeholder in the template with Codex's full plan.

Claude should only flag things that will cause real problems if left in, or that will make the implementation deviate from the original goal. Each finding either has a specific target or is written as "none."

**Stop signal**: Claude suggests "add more tests/logs/comments" with no specific location, or raises a problem without citing where — archive those items; do not let them enter the plan.

## Step 6: Send Claude's review back to Codex for verification

Copy Claude's full output to Codex and use `prompts/en/review-response-triage.md`.

```text
Below is Claude's critique of the formal plan. Do not accept it as-is — turn it into a decision checklist for the next version of the plan.

[Claude's full output]

————————
[paste prompts/en/review-response-triage.md full content]
```

Codex's output should include:

- A direction change summary (item by item — "generally aligned" is not acceptable).
- A response to each key finding, backed by code evidence, conversation evidence, or product semantics.
- A disposition for each item: accept / partially accept / reject / needs your decision.
- An archive list for low-value items.

**Stop signal**: Codex marks an item "confirmed" or "not confirmed" without opening the relevant file — ask it to read the code first; without opening the file, the only valid verdict is "cannot determine."

## Step 7: Execute the confirmed plan

Choose the execution template based on plan size:

- **Small plan**: in the same Codex conversation, paste the full content of `prompts/en/small-execute.md` directly. No additional context needed.
- **Large plan**: save the final confirmed plan to a local file, paste the full content of `prompts/en/strict-execute.md` to Codex, and replace `<PLAN_DOCUMENT_PATH>` with the actual file path.

Codex's execution report should include:

- `git status` check result.
- Which files it changed and which plan diff each corresponds to.
- Diffs it skipped and why (diff didn't match, assumption didn't hold, etc.).
- Compilation and type check results; if any mechanical slips were self-corrected, listed separately.
- Self-review: did function behavior change? Do callers need to be updated?
- Manual regression points you need to confirm.
- Confirmation that files outside the plan were not touched.

**Stop signal**: The report includes changes outside the plan — stop, ask Codex to revert those additions and keep only the diffs listed in the plan.

## Common mistakes

- Asking Codex to implement your idea directly because you proposed it.
- Discussing performance and permissions without reading the code first.
- Moving to the plan stage before early route review and triage.
- Running execution without a final review.
- Blindly accepting or rejecting Claude's critique without having Codex verify each item.
- Letting unconfirmed changes sneak into execution.

## What you should end up with

- Code evidence for whether the current gap is real.
- An explicit verdict on your initial idea.
- One selected implementation route that has passed early review and triage.
- A plan that has passed final review and verification.
- A change applied strictly according to the confirmed plan.
