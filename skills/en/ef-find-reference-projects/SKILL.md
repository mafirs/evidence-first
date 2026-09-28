---
name: ef-find-reference-projects
description: "Find reference projects: search, filter and compare mature GitHub projects worth referencing for what you expect to build."
disable-model-invocation: true
---

I want to hand you the task of finding GitHub projects worth referencing.

My judgment is: there must be GitHub projects that overlap heavily with what I expect and are already fairly mature. I want to reference such projects directly rather than reinventing the wheel from scratch.

The current problems are:

1. I don't know which GitHub projects are worth referencing.
2. I don't know how to search for such projects.
3. I need you to do the searching, filtering, and judging for me.

Please do the following in order:

1. First, based on what I currently expect, make clear what kind of GitHub projects to look for.
2. Then design the search approach and explain how you plan to find these projects.
3. Then actually search for GitHub projects.
4. Filter out the projects that overlap heavily with what I expect, are relatively mature, and are worth referencing.
5. For each project, explain:
   - Where it overlaps with what I expect
   - Why it is worth referencing
   - Which parts of it can be borrowed
   - Which parts of it are not suitable to copy directly
6. Finally give a clear conclusion: which projects I should reference first, and why.
- After steps 1 and 2 are complete, if the current tool supports sub-agents and there are at least two independent search paths, dispatch read-only sub-agents in parallel for the search; all sub-agents must use the same project type and filtering criteria.
- Each sub-agent must state its search approach, the repositories and related docs/code it actually opened, the overlaps, the parts that can be borrowed, the parts not suitable to copy, and the evidence for which filtering criteria are not met; returning only project names or a search summary does not count as completed verification.
- Steps 4–6 are done by you: cross-compare, verify maturity, and decide priority yourself; do not vote by how many times a project was recommended.

Answer requirements:

1. Do not just list project names; you must explain the filtering basis.
2. Do not recommend a project just because it looks related; you must judge whether it truly overlaps with what I expect.
3. Do not assume I want to build from scratch; the focus is finding mature projects that can be referenced, adapted, or have useful parts extracted.
4. If what I expect is not yet enough to support accurate filtering, first point out what information is missing; do not force a recommendation.

Execution requirement: quality is the only goal; ignore token cost, length, and speed. Every step must actually be carried out: do not substitute inference for verification, do not skip steps, do not give conclusions early. Read everything that needs reading, look up everything that needs looking up, and verify everything that needs verifying before moving on.
