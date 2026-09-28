---
name: ef-review-response-triage
description: "Review triage: verify the reviewer's critique item by item and produce a decision list. Send to the main agent."
disable-model-invocation: true
---

Below is another coding agent's adversarial review of your plan idea:

```text
<PASTE_REVIEW_HERE>
```

## Your task

**Do not simply follow the other agent's lead**. Turn this review into a decision list for the next version of the formal plan.

## Output order — mandatory

1. Direction change summary (output first)
2. Item-by-item responses (evidence/basis)
3. Archive items (low-value items, one sentence each)

Note: the order of work is to finish the verification first and then write the summary; the output order must still show the "Direction change summary" first.

## 1. Direction change summary — must be output first

Fill in every item; do not summarize with phrases like "generally as expected" or "basically unchanged".

1. What did the original idea keep?
2. What did the idea add after the review?
3. What did the idea drop or downgrade after the review?
4. Did the other agent raise a problem you had not considered that really holds?
   Yes → list it; No → write "none" and explain why
5. Did the other agent go down a rabbit hole?
   Yes → point out which items, and why they do not affect the current idea
6. Is there any product semantics or trade-off that needs a user decision?
   Format: [decision point] — option A vs. option B — my leaning is X, needs user confirmation + the reason for the leaning (in plain words: no jargon, no analogies, no metaphors)
   None → write "none"
7. Is there anything that, if left unchanged, would affect the real launch or leave a trap for later plans?
   Yes → list file:line or module name; No → write "none" and explain

## 2. Item-by-item responses

Action 1 — verify the other agent's key criticisms

You must verify the following items:
- Issues the other agent labeled [critical]
- Engineering premises the other agent labeled [conversation+code conflict]
- Code facts the other agent labeled [agent didn't mention, I found in code] that affect the current idea
- The "smaller route" the other agent mentioned
- When the other agent's route comparison concludes "a better route exists", that route and its basis
- Product semantics / user-decision items the other agent mentioned

[edge] items must also be verified if they could change the formal plan; otherwise they go to the archive.
[filler] items are archived by default, unless you think the other agent underestimated them.

For each of the above, judge: confirmed / partly confirmed / not confirmed / cannot determine

Rules:
- Whatever the verdict — "confirmed / partly confirmed / not confirmed" — you must give a basis: code evidence (file:line), conversation evidence, or product-semantics evidence
- Without opening the relevant file you may not conclude "not confirmed"; in that case write "cannot determine"
- When choosing "cannot determine", you must state what evidence is missing; if it can be judged by reading the code or the conversation context, "cannot determine" is not allowed
- For every item, go back through this conversation's history to check whether it was already discussed and settled; if settled, state the conclusion reached then, and do not re-argue it as a new problem
- If the items that must be verified fall into at least two independent evidence domains, you may dispatch read-only sub-agents in parallel; every sub-agent must receive the same original request and product semantics, and returns only the claim checked, its true/false status under the agreed roles, decisive evidence, conflicts, and missing evidence, without deciding whether to adopt it
- You must merge duplicates, resolve evidence conflicts, and reopen the decisive files, then give the verdicts, handling decisions, and direction change summary yourself; do not simply concatenate sub-agent outputs

Action 2 — format for each item

For the other agent's item X: [brief description]
- Layer: code architecture / feature / user experience
- Verdict: confirmed / partly confirmed / not confirmed / cannot determine
- Discussed before: yes (earlier conclusion: ___) / no
- Handling: must change direction / expand in the plan stage / defer /
            reviewer is wrong / needs user decision
- Consequence if not fixed: [one sentence on what change I will see. No jargon, no metaphors.
              Write "none" when the verdict is "not confirmed" or the item is [filler]]
- Reason: [at most 3 sentences]

Compression rules:
- The checks and self-review above are performed item by item for all items, without sampling; compression applies only to the output
- Keep at most 6 item-by-item responses; at most 3 sentences of reason each. The rest go to the archive
- If the handling is "must change direction" and the reason is obvious → compress the reason to 1 sentence
- Merge duplicate criticisms, keeping the original item numbers
- [filler] / [edge] items that do not affect the plan → go straight to the archive

## 3. Archive items

One sentence each:
Item X — [filler / not confirmed / already covered / discussed before] — [one sentence on why it is not handled]

## Forbidden

- Do not write non-specific phrases such as "add tests / add logging / add comments / be more rigorous / watch the boundaries"
- Do not use metaphors, analogies, or personification to describe consequences; describe only what will actually happen
- Do not give concrete code implementations
- Do not rehearse implementation details that have not been decided
- Do not make definitive statements about the current code without opening the files
