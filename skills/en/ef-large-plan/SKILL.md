---
name: ef-large-plan
description: "Large plan: write the full change plan into a markdown document; plan only, no code edits. Send to the main agent."
disable-model-invocation: true
---

You may now only output a change plan (write it into a markdown document; the document name is up to you). Directly modifying, creating, or deleting any file is strictly forbidden (except the markdown document I asked for), and running commands that change project state is strictly forbidden. I will execute the plan manually; you are only responsible for the blueprint.
Based on the current code, give the change plan.

## Prerequisites

1. Read the code first, then write the plan
Before writing the plan, you must actually read the relevant code. Files you have not read may not appear in the plan.
- If the current tool supports sub-agents and this task actually spans at least two independent modules or code paths, dispatch read-only evidence-collecting sub-agents in parallel; when this condition is not met, do it yourself and do not force a split
- Each sub-agent returns only files, symbols, line numbers, facts about the current state, call relationships, impact surface, and uncertainties; it does not write the final diff
- Before any file goes into the plan or the diff, you must personally read its current content and check the cross-module contracts yourself; sub-agent summaries cannot replace the "read-confirmed" required in this section

2. Ask first when uncertain
If there are key uncertainties in the requirement, code logic, data structures, interface behavior, or boundary conditions, ask first; do not make assumptions yourself and go straight to a plan.
Ask at most 5 key questions, and only ones that materially affect the plan. Low-risk points may proceed on assumptions, but they must be marked in the plan.

3. Minimal-change principle
Change only the code required to implement this requirement, plus the safety, robustness, and boundary handling directly related to this change (null values, exceptions, concurrency, permissions, etc.).
If you find problems outside the requirement (bugs, hidden risks, code smells, possible optimizations), do not change them in the plan; put them in the "Extra findings" section for me, and I will decide whether to handle them this time.
Do not do any of the following along the way: rename variables/functions/files, adjust formatting/indentation/quotes, reorder imports, delete code/comments/logs that "look unused", refactor, extract functions, or change type/interface signatures unrelated to this requirement.

## Output structure

Output strictly in the following order and sections; do not mix them

### 1. Read scope
List what you actually read this time:
- File paths
- Key functions / classes / module names
- Line ranges involved

Files not in this list may not appear later in the plan.

### 2. Plan details
Organize as "one subsection per file"; each subsection contains:

**File path**: full path

**How to locate**: how to find the place to change (function name, class name, anchor code)

**Diff**: unified diff format, with enough context

**Change classification**: for every change in this file, mark which it is:
- (a) required to implement the requirement
- (b) required for the safety / robustness / boundary handling of this change
- (c) other

Changes marked (c) must be removed or moved to the "5. Extra findings" section.

**Source of current-state claims**: for each description of the current code in this subsection, mark item by item:
- [read-confirmed] based on code actually read
- [assumption-needs-validation] based on inference; attach "if the assumption does not hold, how the plan must change"

**Why this change**: explain why this plan is necessary

### 3. Business impact (in plain words, no code jargon)
- What this change does for the business
- Which pages / features / user behaviors will change
- Which existing behaviors stay the same
- The actual result I should see after the change: specific changes in page display, interaction, requests, data, error messages, and loading/empty/error states

### 4. Regression test checklist
Besides the new feature itself, list the existing features I need to click through manually to confirm nothing broke:
- Exactly which page / button / flow to click
- What data to enter
- What result to expect (normal scenario + error scenario)
- Why this feature might be affected by this change

### 5. Extra findings (optional)
Problems found while reading the code this time that are unrelated to the requirement:
- Location of the problem
- Description of the problem
- Potential risk
- Suggested handling
- Whether you suggest fixing it this time (and why)

Do not slip these into the diffs in "2. Plan details"; list them separately and wait for my decision.

### 6. Not modified
Clearly list the files / modules / features this plan does **not** touch but that look related, so I know where the boundary is.

## Language constraint

If the plan contains wording like "while we're at it / at the same time / I'd also suggest / a better approach would be / more standard / cleaner / let's optimize / I suggest refactoring", treat it as an out-of-scope signal; the corresponding change must move to the "Extra findings" section and must not appear in "Plan details".

## Final self-check

Before outputting, ask yourself and answer
1. Can I give the plan directly, or do I need to ask questions first?
2. Is every diff in "Plan details" classified (a), (b), or (c)? Have the (c) items been removed or moved to "Extra findings"?
3. Do the files listed in "Read scope" cover every file involved in the plan? Is any unread file appearing in a diff?
4. Is every item in "Source of current-state claims" marked [read-confirmed] or [assumption-needs-validation]?
5. Does the "Regression test checklist" include every existing feature that might be affected?
If you need to ask questions, output only the questions, not the plan.
