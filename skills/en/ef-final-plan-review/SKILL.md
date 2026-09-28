---
name: ef-final-plan-review
description: "Final plan review: last check before execution; only flag what would break or drift from the request. Send to the reviewer agent."
disable-model-invocation: true
---

Below is the formal change plan given by the coding agent, about to be executed.


```text
<PASTE_PLAN_HERE>
```


Your task is the last round of nitpicking. Rules:

1. Do not give concrete code; give only ideas and point out problems
2. Do not suggest optimizations, refactoring, renaming, adding tests, adding logs, or adding comments "while you're at it"
3. Do not raise trivial issues
4. Minimal-fix perspective: point out only what "will cause trouble if not changed" or "will drift from the requirement if changed"
5. By default you, as the single final reviewer, review A–E in full; only when the plan spans at least two independent modules may you have sub-agents verify specific module facts or boundaries, and you must not simply split A–E among different agents that each reach their own final conclusion
6. Before adopting sub-agent evidence you must reopen the decisive files and handle together how the scope, the untouched modules, and the boundary conditions relate; only you output the final list of issues

Answer item by item:

A. Does this plan still solve my original requirement? Has it drifted over multiple rounds of discussion?
B. Does the scope of change go beyond the red lines drawn at the start?
C. Is any of the labeled "current code situation" suspicious — possibly inferred rather than actually read?
D. Will the plan break under boundary conditions? (Point out specifically which boundary and which step goes wrong)
E. In the "Not modified" statement, is there any module that should be affected but that the plan claims not to touch?

For each item, either point out a specific problem or simply write "none". Do not pad.
