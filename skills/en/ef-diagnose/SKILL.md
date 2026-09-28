---
name: ef-diagnose
description: "Diagnose: read the code, locate the relevant code paths and give an evidence-backed conclusion. Send to the main agent."
disable-model-invocation: true
---

——————————
Locate the code paths related to this problem and read them thoroughly (state which files you read, why you consider them relevant, and whether anything may have been missed).
This round forbids: modifying/creating/deleting any file, running commands that change project state, and pasting "suggested full replacement code" in the reply. The only allowed output is: analysis, conclusions, reasoning, and quoting existing code as evidence.
Answer based on the actual code, with these requirements:
- Be decisive. If the evidence clearly points to a single answer, give it directly; if there are several possibilities or it depends on runtime conditions, list each branch and its trigger conditions truthfully, and do not force convergence
- For each key reasoning step, give the evidence location: file path + line number + one sentence summarizing what that code does; do not paste full code snippets
- Distinguish "the code really says this" from "I infer this from it", and mark the latter separately
- If a conclusion depends on code you have not read, an unverified assumption, or external configuration/environment, say so explicitly; do not make things up
- If the current tool supports sub-agents and there are at least two independent code paths or root-cause branches, dispatch read-only sub-agents in parallel to collect evidence; otherwise do it yourself, and do not widen the reading scope just to create parallel work
- Each sub-agent returns only the files it actually read, file:line, facts/inferences, and what it did not cover; you re-check the final relevant scope, root-cause branches, and conclusions yourself, and you must open the decisive evidence personally
The output has two parts, in fixed order:

## Part 1: Conclusion (for people who don't read code)

- Answer in 3–6 sentences: under what circumstances the problem occurs → what users/operators will see → the root cause in one sentence → whether it needs handling and how wide the impact is
- Describe it from the angle of "who did what and saw what change", not "which function, which field"
- This part contains no file paths, line numbers, function names, or variable names; any term that must appear is immediately followed by one sentence explaining what it means here
- No metaphors or analogies
- If there are several branches, one sentence per branch: under what condition → what will be seen
- Preferably do not output one big block of text; where needed, group into points and use bold and similar formatting to improve readability.

## Part 2: Evidence (for people who verify)

- Which files were read, why they are relevant, what may have been missed
- Each reasoning step: file:line + one-sentence summary, labeled [code-confirmed] or [inference]
- Unverified assumptions and how the conclusion changes if they do not hold

After writing, self-check: reading only Part 1, can someone who doesn't read code answer "what happened, who is affected, does it need handling"? If not, rewrite Part 1.
