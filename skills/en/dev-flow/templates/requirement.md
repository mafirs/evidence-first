# Requirement doc: <task short name>

## User's words (verbatim, no rewording)

> <the user's original request messages, pasted as-is; several in chronological order>

When the words refer back to earlier context, quote the referenced content verbatim (with the speaker):

> [proposed by the assistant, accepted by the user] <verbatim quote>

When reviewing an existing branch, also quote the PR description and commit messages verbatim (with the source, for example `git log <base>..HEAD`).

When it comes from a BASELINE file the user maintains, copy only confirmed content, quote the items verbatim with their source ("Current effective plan" items by S number, such as `BASELINE_x.md` S-003; other sections by section name).

## Classification of the user's words

Sort the user's words, sentence by sentence (or idea by idea), into one of three kinds, quoting each verbatim. When unsure, classify as a decision.

- **Decisions**: what to do, what not to do, scope, limits. Success criteria and things not to do come only from here.
  - D1 > <verbatim quote>
- **Examples / reasons**: examples, analogies, the user's explanations and motives. Used to understand intent; no standalone rules are derived from them.
  - R1 > <verbatim quote>
- **Factual claims**: the user's statements about the current code or the cause of a problem. Each must be checked under "Premise check" below.
  - F1 > <verbatim quote>

## Premise check

- F1 —— holds / doesn't hold —— <file:line> <what you saw>
- If any doesn't hold, stop and ask the user per stop condition 6, and settle it before writing code.

## Change size

Large / small —— basis: <number of files expected to actually change (not the number of lines in scope.txt); whether interfaces, data structures or permissions are involved>

## Success criteria

Each one names the decision (D number) or confirmed decision it comes from.

1. <a verifiable result, for example "after doing X, you see Y"> —— source: D1

## Not allowed

- <limits the user stated explicitly, and the boundaries that minimal change implies (for example "existing behavior unchanged")> —— source:

## Acceptance cases

- <input / action> → <expected result>; verified by: automated test <test name> / hands-on

## Confirmed decisions

Trade-offs confirmed with the user (including answers given when you stopped to ask); the reviewer may not raise these as issues again.

- <decision> —— user's words: > <verbatim quote>

## Known facts (written during locating)

- [read-confirmed] <file:line> <one sentence>
- [inferred] <one sentence>; if it doesn't hold: <what it affects>

## Change log

- <date> <what changed in the requirement doc, and why>
