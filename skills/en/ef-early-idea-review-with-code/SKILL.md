---
name: ef-early-idea-review-with-code
description: "Early idea review (with code): judge whether another agent's early idea should move on to planning. Send to the reviewer agent."
disable-model-invocation: true
---

Below is the conversation context between me and another coding agent, including my requirement and the initial idea that agent proposed (not the final plan):

```text
<PASTE_CONVERSATION_CONTEXT_HERE>
```

## What you need to do

Review whether this idea is worth advancing to the formal plan stage.
You have the same codebase access as that agent. Actually read the code for this review; do not rely on reasoning from the conversation alone.

## Action 0: Restate first

Extract and restate from the conversation above:
- What my (the user's) original request / original bug is (one sentence)
- What direction that agent's current idea takes (one sentence)

If the conversation does not make the original request clear, point that out directly; do not guess.

## Action 1: Actually read the code

Open the files that agent mentioned in the conversation, read them yourself, and verify whether that agent's description of the current code is accurate.
At the same time, use your search tools to find:
- Code directly related to the original bug
- Code that agent's idea would need to touch but that the conversation did not mention

Reverse constraint on reading scope: read only three kinds of code —
1. Code that verifies that agent's description of the current state
2. Code near the direct cause of the original bug
3. Code the idea clearly needs to touch but that agent did not mention
Do not expand into reading whole modules for a "comprehensive evaluation".
After reading, list the file paths you actually opened.

## The current stage is idea alignment, not plan review

There is no formal plan yet, no concrete implementation, no SQL, no API shape.
The following are out of scope for this review; even if you see them, do not write them:
- Boundary conditions (null values / concurrency / timeouts / old data / abnormal input)
- Where it will break after going live
- Concurrency scenarios where data writes fail
- Anything of the form "if it is implemented this way, then problem X will occur" — the implementation is not decided yet, do not rehearse it
These questions are reviewed after the formal plan exists. Reviewing them now is out of turn.

## Four things to review this round

1. Relevance
Does that agent's idea solve the original request restated in Action 0? Has it drifted off topic, missed the original problem, or expanded beyond it?
Pay special attention to whether the idea sidesteps the original problem to do something bigger.

2. Actual code vs. that agent's own account
List, item by item, the key engineering premises that agent mentioned in the conversation (data shape, existing logic, call relationships, file structure, etc.), and mark each with one of three:
- [conversation+code agree]: what that agent said matches the code I read
- [conversation+code conflict]: what that agent said does not match the actual code — write down the specific conflict and give file:line
- [agent didn't mention, I found in code]: code that agent never mentioned but that is actually relevant to the idea — give file:line and why it is relevant

[conversation+code conflict] and [agent didn't mention, I found in code] are the highest-value output of this stage; focus on finding them.

3. Is there a smaller route
Without redesigning, can fixing only the direct cause of the original bug solve it?
If you say "yes", you must give a fix point down to file:line. If you cannot, write "none".

4. Route comparison: is there an idea better suited to the current project
After reading the code, judge whether that agent's current idea is the most suitable route in the current project.
This is not an invitation to freely suggest improvements; compare only different routes that "solve the same original request".

You may only propose an alternative route that satisfies all of the following:
- It still solves the original request restated in Action 0, without expanding the problem domain
- It is not a concrete implementation plan: no code, no SQL/API/boundary-condition details
- It must be based on code you actually read, not generic best practice
- It must be able to show why that agent's current route suits this project less well
- It must cite existing code patterns, call relationships, or architectural conventions in the project, with file:line
- It cannot just be "more elegant / more rigorous / more complete"; it must be "more consistent in this project / fewer changes / closer to existing entry points / better aligned with existing responsibility boundaries"

If that agent's current idea is already a reasonable route, write "current route is fine" as the route verdict and "none" for the other fields.
If there is only a smaller fix, write "only a smaller fix" as the route verdict and "see smaller route" for the other fields, without repeating the details.
If you choose "cannot determine", you must state in the "Missing information" field what kind of information is missing to make the judgment; it may not be left empty.

Format:
Route verdict: [current route is fine / a better route exists / only a smaller fix / cannot determine]
Better route: [one sentence; if none, write "none"]
Basis: [file:line + existing code pattern / call relationship / responsibility boundary]
Why it beats the current idea: [one sentence on why it suits the current project better; if none, write "none"]
Missing information: [only when "cannot determine"; otherwise write "N/A"]

## Product semantics gate — mandatory

If the discussion involves several product semantics (for example meaning A vs. meaning B vs. meaning C), first do one thing:
List which semantics that agent's current idea adopts.
After that, every issue you raise must state which semantics it holds under.
If an issue only holds under another semantics and does not hold under the semantics this idea has chosen — do not list it. That is not a problem; it is a product trade-off.

## Filler label — mandatory

Every issue you list must end with one of three labels:
- [critical] I am confident this is a real problem; it will really cause trouble if not fixed
- [edge] It holds in theory, but I am not sure whether it would really be triggered in practice
- [filler] Honestly — if I were not required to list issues, I would not bring it up

Typical signs of [filler]:
- It holds in theory but only happens when several "just so + just so + just so" conditions stack up
- It is triggered only on abnormal usage paths
- It is an existing trade-off of the current system that this idea does not make worse
- After reading the code, the actual code is already implemented the way you were worried about (the problem does not exist)

If your argument for an item ends up with chained assumptions like "if the user... if the system... if at the same time...", it is most likely [filler].

The [filler] label may be used; there is no penalty. It is more credible than dressing something up as [critical].
I will not mark you down for labeling [filler], but I will mark you down for disguising [filler] as [critical].

## Forbidden

- Do not list issues that only hold on malicious/abnormal usage paths
- Do not list existing trade-offs of the current system that this idea does not make worse
- Do not give non-specific advice like "consider adding unit tests / logging / comments / defensive code / refactoring / optimizing / being more rigorous"
- Do not give concrete code changes

## Output format

Action 0: Original request restated: [one sentence] | Current idea direction: [one sentence]
Action 1: Files I actually opened: [list of file paths]

Then choose one:

(A) Blocking findings
Relevance: [judgment + one or two sentences of reason]
Actual code vs. that agent's account:
  - [premise 1] | status: [conversation+code agree / conversation+code conflict / agent didn't mention, I found in code] | file:line | brief description
  - [premise 2] | ...
Is there a smaller route: [if yes, give the specific file:line; if not, write "none"]
Product semantics gate (if applicable): [semantics currently chosen]
Key issues (sorted by importance, most important first):
  1. [issue description] | semantics it is based on: X | what happens if not fixed: Y | [critical/edge/filler]
  2. ...
  3. ...
  ...
  Route comparison:
  Route verdict: [current route is fine / a better route exists / only a smaller fix / cannot determine]
  Better route: [one sentence; if none, write "none"]
  Basis: [file:line + existing code pattern / call relationship / responsibility boundary]
  Why it beats the current idea: [one sentence; if none, write "none"]
  Missing information: [only when "cannot determine"; otherwise write "N/A"]

(B) Reviewed, no blocking issues
Relevance: [judgment]
Actual code vs. that agent's account: [list the status item by item; include at least 1 engineering premise marked [conversation+code agree] to prove you really read the code]
Is there a smaller route: [if yes, give the specific file:line; if not, write "none"]
Product semantics gate (if applicable): [semantics currently chosen]
Reviewed-dimensions statement: I reviewed the following dimensions and found no blocking issues — [list at least 3, at least 1 of which must cite a specific concept from that agent's idea, quoting the words from the original conversation]
Conclusion: the idea can advance to the plan stage.

Route comparison:
  Route verdict: [current route is fine / a better route exists / only a smaller fix / cannot determine]
  Better route: [one sentence; if none, write "none"]
  Basis: [file:line + existing code pattern / call relationship / responsibility boundary]
  Why it beats the current idea: [one sentence; if none, write "none"]
  Missing information: [only when "cannot determine"; otherwise write "N/A"]
(B) is not a lazy way out. The "Reviewed-dimensions statement" must be specific; empty phrases like "fully reviewed" are not acceptable.
