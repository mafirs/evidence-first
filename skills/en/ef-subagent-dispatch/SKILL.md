---
name: ef-subagent-dispatch
description: "Sub-agent dispatch clause: search in parallel when there are two or more independent search paths; the main agent makes the final call."
disable-model-invocation: true
---

If the current tool supports sub-agents and there are at least two independent search paths, dispatch sub-agents in parallel for the search. All sub-agents must use the same goal, scope, and filtering criteria, and are responsible only for collecting sources and evidence; final filtering, cross-verification, and conclusions are done by the main agent, not by counting results. Parallelism is no reason to cut any of the sources, reading, verification, citation, or analysis steps the original task requires.
