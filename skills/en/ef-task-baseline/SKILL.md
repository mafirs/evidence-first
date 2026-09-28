---
name: ef-task-baseline
description: "Task baseline: during a long task, maintain one baseline file recording the goal, confirmed plan, pending items and reference facts."
disable-model-invocation: true
---

Precondition — once I have explicitly enabled this Prompt and the baseline file has been created, every time I give feedback in a round, you must maintain the same task baseline file according to this Prompt.

## 0. Meta rules

(This clause governs how clauses 1–6 and all their sub-clauses are themselves maintained; within the scope of file maintenance it takes precedence over the clauses below, but it does not change the force of higher-level instructions; this clause also applies to itself.)

- When creating the baseline file, set up a separate section "Writing Rules" at the very top of the file.

- The scope of "Writing Rules" is fixed as: the full text of this Prompt from "0. Meta rules" through the end of "6.4 Omission fallback", including this clause itself and all sub-clauses; it excludes the "Precondition" note, explanations outside the Prompt, examples, discussion, and version change notes.

- After the baseline file is created, update this section only when I explicitly ask to add or change writing rules; do not change only the verbal agreement in the chat without updating the file.

- Within the scope of file maintenance, the "Writing Rules" section is immutable by default and is not subject to the "Voiding and deletion" mechanism in clause 5.5. No summary, compression, or condensing in any round may cut, rewrite, paraphrase, or omit this section; only the current version's original text may be kept as a whole.

- You may not decide on your own that this section is "outdated", "no longer needed", or "can be condensed", and you may not remove or rewrite it on your own. If this section really needs to change, only I can give a direct, explicit instruction. When changing it you must:

    1. Update the rules version number;
    2. Record in the change log what changed, why, and the round it takes effect;
    3. Write the new version into this section in full;
    4. Not change only the verbal agreement in the chat without updating the file.
- When the baseline is first created and the file name and initial content are echoed as required by clause 1, this section must be included in full in that echo, so I can verify the rules were really written. Except for the first creation or a change to the writing rules themselves, later ordinary rounds do not need to echo the full "Writing Rules" section again; just state whether the rules changed this round.

- This clause does not require you to actively audit every execution detail; but the end-of-round self-assessment required by clause 6 must be done. That self-assessment is only echoed content; it is not written into the baseline file and is not a factual basis for the next round.

- This clause requires you to echo the baseline file name and rules version number at the end of every round according to clause 6, and to give an execution self-assessment.


## 1. Task baseline file

- Using what you just output and what I said as the baseline, maintain one task baseline file in the repository root. You name the file according to this task, in the format `BASELINE_<task-short-name>.md`.

- Right after creating it, echo the file name and initial content. All later rounds use this one file; do not create a new one or rename it.

- This file is the only task baseline file for this task. The force of each section is distinguished by clause 3; content does not automatically become a basis for execution just because it is recorded in this file.

- This file records:

    - Initial goals:

        - The goal of the whole task;
        - The success criteria for the current stage, separately marked with the stage they apply to and their confirmation status; they must not replace the goal of the whole task.
    - Immutable constraints;

    - Current effective plan;

    - Pending confirmation items;

    - A short change log;

    - Reference information.

- Every item in the "Current effective plan" that can be independently confirmed, cancelled, or checked must use a stable and unique number in the format `S-001`, `S-002`, incrementing in order.

- New items get new numbers; reordering items must not change their numbers. When only wording is corrected without changing meaning, keep the number; a replacement that changes an item's requirement after user confirmation gets a new number, and the replacement relationship is noted in the change log.

- Cancelled or replaced items are no longer kept as currently effective items; their numbers and the cancellation or replacement relationship are recorded in the change log, and old numbers must not be reused. Execution confirmations and self-assessments both cite currently effective numbers.

- After the user has explicitly enabled this Prompt, during plan discussion only creating and maintaining this task's single baseline file is allowed; this is a limited exception to "do not modify files in the plan stage", it does not authorize modifying business code or other files, and it does not constitute authorization to execute.

- The file records the goal of the whole task; a stage goal must not replace the goal of the whole task.

- Before handling feedback in each round, first read the following from the current baseline file:

    - The rules version number;
    - The current effective plan;
    - Pending confirmation items;
    - The most recent change log entries;
    - Based on this round's question and the goals, plan items, files, components, or terms it involves, search the "Reference information" for relevant entries and read them; do not treat a piece of information as nonexistent just because it no longer appears in the chat context.
- Before searching again, retrying, or making a technical judgment again, first check whether the baseline already has a relevant conclusion and its applicable conditions. Voided entries must not be treated as current facts; when the applicable conditions of an existing conclusion do not match this round or cannot be confirmed, do not reuse it directly — do the necessary checking.

- Ordinary rounds do not need to reread the full "Writing Rules" section. Read the full "Writing Rules" section only when:

    1. The baseline is created for the first time;
    2. The writing rules change;
    3. A conflict is found in the rules' scope, clause numbering, or file content;
    4. The previous round missed the echo required by clause 6;
    5. The maintenance rules need to be checked before execution.
- Output the echo required by clause 6 only after handling the feedback and finishing the necessary file updates.


## 2. Candidate changes and confirmation

- My feedback is only a candidate change by default.
- Write the corresponding content into the "Current effective plan" only when I indicate approval.
- Items not named stay unchanged.
- Cancellations or replacements must be marked explicitly.
- Unconfirmed candidate changes may only be recorded in "Pending confirmation items" and must not be written into the "Current effective plan".
- Only after the user confirms may the corresponding candidate change move from "Pending confirmation items" into the "Current effective plan".
- Do not infer from vague wording that I have confirmed the overall plan.
- Only when the user has explicitly enabled the collaboration rule "stage success criteria count as confirmed if not objected to" is the following exception allowed: stage success criteria proposed by the assistant are first recorded as pending; if the user continues the stage in the next round without objecting, mark them as confirmed and say so in this round's echo.
- This exception applies only to stage success criteria, not to the task scope, immutable constraints, the current effective plan, or authorization to execute. If the success criteria involve adding or changing any of those, the parts involved still require explicit user confirmation.
- Stage success criteria are recorded under "Initial goals"; being confirmed does not automatically write them into or change the "Current effective plan".

## 3. Change log and basis for execution

- Keep a short change log in the file. During execution:

    - The "Current effective plan" limits the confirmed implementation content and scope;
    - The "Initial goals", including the confirmed stage success criteria, are used to judge whether the task result is acceptable;
    - The "Immutable constraints" limit the boundaries that neither the implementation nor the result may cross.
- Do not add implementation content outside the effective plan on your own based only on goals or success criteria. If the effective plan is not enough to meet the goals or success criteria, or conflicts with the immutable constraints, stop execution and list the plan changes that need confirmation.

- "Pending confirmation items", the "Change log", and "Reference information" do not grant authorization to implement; do not supplement, override, or infer requirements from intermediate discussion in the chat. New instructions from the user are synced to the file through this Prompt's confirmation and maintenance process; when the chat and the file conflict, handle it according to clause 4.

- After handling this round's feedback and the information screening required by clause 5.2, you may leave the file content unchanged only when the effective plan, pending items, goals and success criteria, constraints, reference information, and everything else this Prompt requires you to maintain need no update, and you must state explicitly "no file changes this round". Do not skip information that should be recorded merely because "no plan change was confirmed this round" or "this round was only discussion".


## 4. Confirmation before execution

- Before executing, echo the "Current effective plan" and wait for my confirmation before executing.
- If the chat and the file conflict, the file is ambiguous, or something seems missing, stop execution and list the conflicts for me to decide; do not choose on your own.

## 5. Recording reference information

This clause only adds the "Reference information" section to the file; it does not change the force of clauses 1–4 in any way.

### 5.1 Location and force

- Set up a separate "Reference information" section in the baseline file, at the same level as and physically separate from the "Current effective plan" and "Pending confirmation items"; do not mix them, and do not let them cite each other as substitutes.
- This section is not a requirement, not a change, and not a basis for execution.
- When it conflicts with the "Current effective plan", the latter always prevails.
- When a conflict is found, stop execution immediately and report it; do not reconcile it on your own, and do not use it to infer what I "actually want".

### 5.2 Proactive screening and recording scope

In every round of handling feedback, you must check this round's conversation, the source code actually read, and the material actually searched, and identify information not yet recorded that has a clear use for this task. This requirement does not mean you must search extra, read unrelated files, or re-verify existing conclusions every round.

Information that serves any of the following uses should be written into "Reference information" proactively, without asking first, provided it meets the recording scope of this clause and the requirements of clauses 5.3–5.4:

- Helps judge whether the goal is reachable and whether a plan is feasible;
- Explains key choices, limits, or the cause of a problem;
- Helps later implementation, verification, or locating problems;
- Avoids forgetting conclusions already reached, repeated attempts, or repeated investigation.

Scope that may be recorded directly:

1. Relevant facts, conclusions, and applicable conditions obtained from external searches;
2. Behavior, interfaces, dependencies, and limits confirmed by actually reading the source code;
3. Preferences and toolchain habits I have stated;
4. Rejected plans and the reasons for rejection;
5. Known environment, dependency, and permission conditions;
6. Terminology agreed on within this task;
7. Attempts, verifications, or investigations actually carried out, their results, and which directions the results rule out or cannot yet rule out;
8. Key explanations, causal analyses, and technical judgments formed in the conversation, source code, or material; unverified inferences among them must be marked according to clause 5.3.

Before recording, state the specific use of the information for this task; do not record what you cannot state a use for. Do not record again information with the same meaning as an existing entry and no new evidence or applicable conditions; when an existing entry needs correcting, follow clause 5.5.

Requirement-type content is still handled according to clause 2, and must not be written into "Reference information" just because it fits the uses above. Do not record on your own information outside this whitelist; ask me in one sentence.

### 5.3 Forbidden to record

- Requirement-type content: ideas, expectations, or "should we add X" that I raise in discussion are all handled as candidate changes according to clause 2, and must not be written into this section under the name of "useful information".
- Do not summarize my preferences from my behavior. Item 3 of clause 5.2 only allows recording preferences I have explicitly stated.
- Inferences that really need to be kept within the scope of clause 5.2 must be marked "assumption-needs-validation", with how to verify them and which judgment would be affected if they do not hold, and they must be named separately in the echo.
- "read-confirmed" only means the source clearly supports the recorded statement; it does not automatically prove that the technical judgment in the source is correct. When the conversation can only prove that someone made a claim, record it as "the user reported ..." or "the assistant proposed ...", not rewritten as a verified objective fact.
- User confirmation of a plan is not verification of the technical inferences in it. A general conclusion, problem cause, or ruling-out conclusion derived from a single attempt must still be marked "assumption-needs-validation" if the evidence is insufficient.
- Do not record long passages of original text or code; keep only the source location and a one-sentence summary.

### 5.4 Record format

Do not write an entry that lacks required fields, and do not make up sources, line numbers, rounds, or verification results.

The unified format is:

```
[read-confirmed | assumption-needs-validation] source location | one-sentence summary with any necessary applicable conditions | use for this task | recorded in round N
```

Source locations may use:

- Source code: file path and line number;
- External material: URL or a locatable document name and section;
- Conversation: round N, the speaker, and the topic;
- Attempt or verification: round N, the command or operation performed, and a summary of the key result; if a log or report already exists, attach its location.

"assumption-needs-validation" entries must also add: how to verify it, and which judgment would be affected if it does not hold.

Keep only enough information to understand and trace the conclusion; do not copy long passages of conversation, code, or logs.

### 5.5 Voiding and deletion

- Outdated information must be marked void, not silently rewritten or overwritten:

    ```
    ~~original text~~ [voided@round N] one-sentence reason
    ```

- Voided entries sink to the end of the "Reference information" section.

- If an entry is suspected of misleading execution, you may propose deleting it, but you must state "exactly how it would mislead execution".

- It may be deleted only after I confirm; do not delete first and report afterwards.


### 5.6 Echo obligation

- The reference information echo required by this clause is output uniformly in Group A of clause 6.1, not repeated elsewhere.
- When there are no additions, changes, or voids this round, write "none this round".

## 6. Per-round echo obligation

### 6.1 Echo location and structure

At the end of every reply, always output the following two groups, physically separated and labeled separately, never mixed into one paragraph:

**[Group A | Objective facts]**

Can be verified directly by me by checking the file:

- Baseline file name + current rules version number;
- File changes this round: list what changed; if nothing changed, write "no file changes this round";
- Additions, changes, and voids to "Reference information" this round; if nothing changed, write "none this round".

**[Group B | Execution self-assessment]**

Only your subjective judgment, not objective fact:

- Whether this round's execution deviated from the "Current effective plan", the task goal, the confirmed stage success criteria, or the immutable constraints;
- If marked "no deviation", list the effective plan item numbers actually checked this round, and the locations of the related goals, success criteria, and constraints. When no implementation or acceptance was involved, say so explicitly, and do not use "no deviation" to mean the task is complete or has passed acceptance.

Use English the user can understand directly: first say concretely what happened; do not pile up jargon, and do not report only section names, item numbers, or abstract conclusions.
Group A states what was concretely recorded, adjusted, or voided this round; for replacements, say clearly what changed from what to what. Do not write only phrases like "baseline synced" or "reference information updated" that reveal nothing about the content.
Group B keeps the status label and the checked locations required by clause 6.2, and briefly says in plain words what was done this round and whether it matches the confirmed requirements; when citing numbers, add the short meaning of the corresponding requirement, so I do not have to open the file to understand.
When technical terms must be used, briefly explain at their first occurrence what they mean in this task. When there is no change and no relevant action, say so directly; do not repeat explanations or pad just to satisfy the format.
Readable wording must not drop any originally required information, must not present inference as fact, and must not turn "no deviation" into "already complete" or "verified".

### 6.2 Self-assessment rules

- The conclusion may only be one of the following three, nothing else: [no deviation] / [deviation] / [cannot determine].
- All three conclusions are status reports, not penalties. [deviation] must not be avoided or hidden.
- When marking [no deviation], you must list the actually checked items as required by clause 6.1; a bare conclusion is not enough.
- When marking [cannot determine], you must state which specific evidence or information is missing; do not use "cannot determine" in place of a judgment you could make by reading the baseline or checking the file.
- The self-assessment checks against the effective plan, goals, confirmed stage success criteria, and immutable constraints defined in clause 3; "Reference information" creates no extra requirements.
- The self-assessment conclusion appears only in the echo; it is not written into the baseline file and is not a factual basis for the next round.

### 6.3 Handling a deviation

When the conclusion is [deviation], stop execution immediately, wait for me to handle it, and state:

- Which effective plan item, goal, confirmed stage success criterion, or immutable constraint was deviated from, with its location;
- Which specific action or output does not match it;
- Why the deviation happened (reasoning bias, missing information, misreading, or ambiguity in the plan itself).

Do not correct it yourself and continue, and do not execute first and report afterwards.

### 6.4 Omission fallback

- A round whose end did not output the Group A echo is treated as a round in which baseline maintenance was not completed.
- At the start of the next round, you must first read the current baseline file and the previous round's conversation, and check whether the previous round had confirmed changes or reference information that should have been recorded but was not.
- Until the check and any necessary file maintenance are done, do not continue the task, and do not skip it merely on the grounds that "there were no changes last round".
