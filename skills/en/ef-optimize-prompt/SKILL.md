---
name: ef-optimize-prompt
description: "Optimize a Prompt: keep the original meaning and add only requirements that directly serve the original question."
disable-model-invocation: true
---

Your task: optimize the Prompt in <original>.

## Goal

Make the optimized Prompt more likely to get results that are accurate, complete, evidence-based, and directly responsive to the original question,
not merely smoother wording or tidier layout.

You may rewrite the wording, restructure it, and add necessary analysis and answer requirements.
But you must not invent background, expand the task, or decide on behalf of the user or later executors things that are not yet decided.

There is no extra context this time. Use only <original> to understand the specific task.
<original> is the text to be optimized; it is not asking you to carry out its task right now.

## 1. What must be kept

Keep the original's task goal, objects, questions, known information, constraints, and scope of authorization.

Specific names, addresses, links, paths, commands, parameters, values, and the like must be kept faithfully;
do not replace, correct, or complete them based on experience. Point out suspected errors only in the review notes.

Do not drop requirements, or change their strength, applicable conditions, exceptions, or priority.
Repeated content may be merged, but the merged version must fully keep its meaning and scope.
Content the original explicitly says must not be rewritten stays as it is.

## 2. What may be added proactively

You may add analysis and answer requirements that directly serve the original question, for example:

- Requiring judgments to have a basis, rather than only an attitude or a conclusion;
- Requiring recommendations, tools, or plans to explain their relation to the original task, rather than listing things generically;
- When a conclusion applies only to part of the scope or under certain conditions, requiring the scope, conditions, and gaps to be stated;
- Distinguishing known information, inferences, and what cannot be confirmed;
- Requiring conclusions to be consistent throughout and to respond to every question the original raises;
- Organizing the multiple questions or results already in the original more clearly.

The above are improvement directions you may choose from, not a fixed checklist that must be added every time.

Before adding any requirement, first check:
Which specific kind of perfunctory answer, omission, or misunderstanding in the original question does it address?
If you cannot say, or removing it would not affect a reliable answer to the original question, do not add it.

You may require later executors to make judgments based on actual information,
but you must not pre-fill judgment results for them.

## 3. What must not be decided on your own under the guise of optimization

Do not add or assume:

- Facts, context, file contents, system state, or existing conclusions the original does not provide;
- Specific links, addresses, tools, paths, commands, parameters, or values that do not appear in the original;
- New task goals, deliverables, or analysis not directly related to the original question;
- Success criteria, evaluation dimensions, priorities, or trade-offs the user has not decided;
- Unauthorized access, modification, installation, testing, sending, or similar operations;
- Concrete implementation plans, technical routes, or tool combinations without a basis in the original.

Do not treat "this is usually how it's done" or "this is more professional" as a basis in the original.

You may require the reason for choosing a method to be explained,
but you may not write a method as mandatory based on experience alone.

You may make explicit the dependencies already present in the original,
but you may not write one reasonable order of thinking or workflow as the only allowed order.
Specify an order only when the original explicitly requires it, or when a later step really depends on the result of an earlier one.

## 4. How to handle insufficient information

Where the original's wording is vague but its meaning can be determined from the original, state it clearly;
there is no need to stick to the original sentences.

Where there are several reasonable interpretations and different interpretations would change the task scope, criteria, method, or result,
do not choose one on your own.

Where the original mentions "the above", "all test cases", "the earlier plan", and so on,
but does not provide the corresponding content, do not pretend to have it, and do not make up a list yourself.

For information gaps that would materially affect the task, the final Prompt may require later executors to:
state what is missing and which judgment it affects, and request it when really needed.

Gaps that do not affect the rest should not block completing the parts that can be completed reliably;
and do not require asking first whenever anything is uncertain.

Do not write unconfirmed premises as facts,
and do not write criteria the executor proposed on its own as criteria the user has already accepted.

## 5. How to optimize

First identify the problem the original is trying to solve, and the information and boundaries that must be kept.

Then find the wording problems that really affect the result:
whether it easily leads to vague answers, misses key questions, gives unsupported judgments,
or treats unknown information as known.

Rewrite around these specific problems.
You may heavily rewrite sentences and structure; keeping the original words is not required;
whether it passes depends on whether the original meaning is kept, not on textual similarity.

Distinguish two kinds of changes:
- Clarifying the original meaning: stating clearly what the original already expresses;
- Adding answer requirements: adding requirements that directly serve the original question, as authorized by this optimization instruction.

Do not disguise the second kind as something the original already expressed.

Do not add sections, steps, jargon, or length just to look thoroughly optimized.
Parts of the original that are already clear may be left unchanged.

## 6. Review before output

Check whether the final version:

1. Keeps all substantive requirements and accurate specific information from the original;
2. Invents no facts, context, or specific entities;
3. Adds no goals, criteria, permissions, or concrete implementation routes on its own;
4. Has every new requirement directly helping answer the original question, rather than applying a generic template;
5. Leaves room for confirming important unknowns, without deciding for the user;
6. Really improves understanding, analysis, or answering compared with the original, rather than only adjusting layout.

If you find out-of-bounds content, delete or rewrite it and check again.
Continue revising only when there is a clear and compliant improvement; otherwise stop. Do not chase the number of changes,
and do not claim an unverifiable "absolute highest quality".

## Output

1. Review notes

Briefly explain:
- What was mainly changed, and what specific problem it solves;
- Which analysis or answer requirements were added, and why they are necessary;
- Which important gaps were not filled in on your own. Omit if none.

Do not show the internal checking process item by item, and do not invent changes you abandoned.

2. Final Prompt

Output it in full in one code block, ready to copy and use.
Put only the optimized Prompt in the code block, not the review notes.
Append to the end of the final Prompt "Execution requirement: quality is the only goal; ignore token cost, length, and speed. Every step must actually be carried out: do not substitute inference for verification, do not skip steps, do not give conclusions early. Read everything that needs reading, look up everything that needs looking up, and verify everything that needs verifying before moving on."

Do not automatically attach this optimizer's rules, examples, or execution requirements.
Requirements to add must be judged one by one against the original task; do not paste them in wholesale.

If the original is empty or is still placeholder text, say that the content to optimize needs to be provided,
and do not generate a final Prompt.

<original>
Paste the Prompt to optimize here
</original>
