Below is the conversation between a user and a coding agent, including the user's goal and the agent's initial direction. This is not a final implementation plan.

```text
<PASTE_CONVERSATION_CONTEXT_HERE>
```

## Your task

Review whether this direction is worth advancing to a formal implementation plan. You have the same codebase access. Read the code yourself — do not rely on the conversation alone.

## Action 0: Restate

From the conversation above, extract and restate:

- What the user's original goal or bug is, in one sentence.
- What the current direction is, in one sentence.

If the conversation does not make the original goal clear, say so directly. Do not guess.

## Action 1: Read the code

Open the files mentioned in the conversation and read them yourself. Verify whether the agent's description of the codebase matches what the code actually shows.

Also search for:

- Code directly related to the original bug or goal.
- Code the current direction would need to touch but was not mentioned in the conversation.

Reading scope constraint: only read three categories of code.

1. Code needed to verify the agent's self-reported codebase state.
2. Code directly around the root cause of the original bug or goal.
3. Code the direction clearly needs to touch but the agent did not mention.

Do not expand into entire modules for "comprehensive evaluation." After reading, list the files you actually opened.

## This stage is direction alignment, not plan review

There is no formal plan yet — no concrete implementation, no SQL, no API shape. The following are out of scope this round:

- Edge cases.
- What will break after launch.
- Concurrent write failure scenarios.
- Any "if it's implemented this way, then X problem occurs" speculation.

These belong in the formal plan review. Raising them now is overreach.

## Four things to review this round

1. On-target: does the direction solve the original goal restated in Action 0? Is it off-target, missing the original problem, or expanding beyond it?
2. Code vs. conversation: list each key engineering assumption. Label each `[conversation+code agree]`, `[conversation+code conflict]`, or `[agent didn't mention, I found in code]`.
3. Is there a smaller path: can the original bug or goal be addressed without the current direction, by only touching the direct root cause? If yes, give a specific file:line.
4. Route comparison: is the current direction the most appropriate route in this codebase? Any alternative must solve the same original goal, not expand the problem scope, and be grounded in code you actually read.

## Product semantics gate

If the discussion involves multiple product interpretations, state which interpretation the current direction is based on. Every issue you raise must note which interpretation it depends on. Issues that only hold under a different interpretation should not be listed.

## Confidence labels

Every issue must end with: `[critical]` / `[edge]` / `[filler]`.

If the argument requires multiple "if… and also if…" chains, it is almost certainly `[filler]`.

## Prohibited

- Do not list issues that only arise under adversarial or abnormal usage paths.
- Do not list issues that are existing system trade-offs this direction does not make worse.
- Do not suggest adding tests, logs, comments, defensive code, refactoring, or optimization without a specific location and scenario.
- Do not write implementation code.

## Output format

Action 0: Original goal: [one sentence] | Current direction: [one sentence]

Action 1: Files I actually opened: [list]

Then choose one:

### A. Blocking finding

On-target: [judgment + one or two reasons]

Code vs. conversation:

- [assumption] | status: [conversation+code agree / conflict / agent didn't mention] | file:line | brief description

Smaller path: [give specific file:line if yes; write "none" if no]

Product semantics gate (if applicable): [which interpretation]

Key issues (by priority):

1. [description] | semantics: X | consequence if ignored: Y | [critical/edge/filler]

Route comparison:

- Assessment: [current route is appropriate / better route exists / only a smaller fix exists / cannot determine]
- Better route: [one sentence; "none" if not applicable]
- Basis: [file:line + existing code pattern / call relationship / responsibility boundary]
- Why it beats the current direction: [one sentence; "none" if not applicable]
- Missing information: [only fill if "cannot determine"; otherwise write N/A]

### B. Reviewed, no blocking finding

On-target: [judgment]

Code vs. conversation: [list each status; must include at least one `[conversation+code agree]` assumption]

Smaller path: [give specific file:line if yes; write "none" if no]

Product semantics gate (if applicable): [which interpretation]

Reviewed dimensions declaration: I reviewed the following dimensions and found no blocking issues — [list at least 3 specific dimensions]

Conclusion: This direction can advance to the formal plan stage.

Route comparison: same format as A.
