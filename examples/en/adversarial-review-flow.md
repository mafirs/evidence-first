# Adversarial Review Flow Walkthrough

This example is for when you have received a critique from Claude and are not sure which parts to accept.

The product, interfaces, and file names in this example are fictional. Do not commit real business data, customer information, credentials, or private conversations to the repository.

## Fictional scenario

You asked Claude to review a formal plan for a search feature. Claude gave these findings:

```text
1. [critical] The plan does not verify permission filtering — documents the user cannot access may appear in search results.
2. [edge] Search result highlighting is not designed — user experience may be poor.
3. [filler] Suggests adding more logs and comments.
4. [critical] The plan rebuilds the index directly, which may affect write performance in production.
```

You cannot blindly accept all of this, and you cannot dismiss it just because it came from Claude. You need Codex to turn this critique into a decision checklist for the next version of the plan.

## Step 1: Send Claude's review back to Codex for verification

Paste Claude's full output to Codex, then paste `prompts/en/12-review-response-triage.md`.

```text
Below is Claude's critique of the formal plan.

Original plan summary: add full-text search capability to document search by reusing the existing search API and extending query scope on the back end.

Claude's findings:
1. [critical] The plan does not verify permission filtering — documents the user cannot access may appear in search results.
2. [edge] Search result highlighting is not designed — user experience may be poor.
3. [filler] Suggests adding more logs and comments.
4. [critical] The plan rebuilds the index directly, which may affect write performance in production.

Your task: do not accept this critique as-is. Verify each item and turn it into a decision checklist for the next version of the plan.

————————
[paste prompts/en/12-review-response-triage.md full content]
```

Codex's output should include:

- A direction change summary (item by item — phrases like "generally aligned with expectations" are not acceptable).
- A response to each item, each backed by code evidence, conversation evidence, or product semantics.
- A disposition for each item: accept / partially accept / reject / needs your decision.
- An archive list for low-value items.

**Stop signal**: Codex marks item 1 ("permission filtering") as "confirmed" without opening the permission-related code — stop, ask it to read the relevant files first. Without opening the file, the only valid verdict is "cannot determine."

## Step 2: Decide which stage to return to

Based on Codex's verification output, choose your next step:

- **The critique overturns the original route** (e.g., item 1 is confirmed and the plan has no coverage for it): return to `prompts/en/03-route-with-user-idea.md` or `04-route-without-user-idea.md` to choose a new route.
- **The route still holds, the plan needs additional constraints** (e.g., add a permission check step, but the overall approach is unchanged): return to `prompts/en/05-small-plan.md` or `06-large-plan.md` to update the plan.
- **Only low-value items remain** (e.g., item 3 "add more logs"): archive them and move on — do not change the plan just to look thorough.

**Stop signal**: Accepting everything labeled `[critical]` without verification, or skipping everything labeled `[filler]` without a glance — both are mistakes. `[critical]` still requires Codex to verify; `[filler]` still needs one look to confirm it is actually filler.

## Step 3: Apply the verification conclusions to the next version of the plan

Send Codex the verification conclusions, explicitly specify what goes in and what stays out, then use 06-large-plan to produce the updated plan.

```text
Based on the review verification just completed, please update the plan.

Must include:
- Permission filtering verification (item 1, confirmed)
- Avoid affecting production write performance (item 4, confirmed)

Do not include:
- "Add more logs and comments" (item 3, archived)

Needs your decision:
- Whether search result highlighting is in scope for this release (item 2, product trade-off, needs your call)

————————
[paste prompts/en/06-large-plan.md full content]
```

The updated plan should include:

- New diffs for accepted findings (e.g., specific location for the permission check).
- No diffs for items you explicitly excluded.
- Pending decision items listed separately, waiting for your call.

**Stop signal**: The new plan includes changes you explicitly excluded, or contains new constraints you did not approve — ask Codex to remove those additions and keep only what you confirmed.

## Step 4: Run another final review if needed

If the updated plan has changed substantially (e.g., permission verification touches multiple modules), send the new plan to Claude with `prompts/en/11-final-plan-review.md` for another round.

If the changes are small (e.g., only added one permission check in an existing guard), confirm directly and proceed to execution — another full Claude review is not necessary.

## Common mistakes

- Accepting everything labeled `[critical]` without having Codex verify.
- Skipping everything labeled `[filler]` without looking.
- Accepting a "confirmed" or "not confirmed" verdict from Codex when Codex did not open the relevant file.
- Letting "add logs, add comments, be more rigorous" enter the plan.
- Telling Codex to "take it all into account" instead of explicitly specifying what to include and what to exclude.

## What you should end up with

- A direction change summary.
- A decision list for each critique item, each with clear evidence.
- An explicit disposition for every item: accept, partially accept, reject, or cannot determine.
- Product or engineering trade-offs that need your decision.
- Specific constraints the next plan version must follow.
