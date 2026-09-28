---
name: ef-small-plan
description: "Small plan: read the code and propose per-file diffs without editing code. Send to the main agent."
disable-model-invocation: true
---

Give me your change plan; do not edit the code directly.

Read the relevant code before writing the plan; files you have not read must not appear in the plan.
This task does not start sub-agents by default. Only if the actual reading scope unexpectedly spans at least two independent code paths may you use sub-agents in parallel to collect evidence read-only; the plan and diff are still written by you, and every file that goes into the diff must be read by you personally.
If there are key uncertainties, ask me first (at most 5); for everything else proceed on reasonable assumptions and mark them.

Change only what the requirement needs + the necessary safety/boundary handling. If you find other problems (bugs, hidden risks, possible optimizations), just tell me; do not slip them into the diff.

Output:

**What I read**: files + functions/key locations

**What to change** (organized by file):
- File path
- diff (with context)
- One sentence on why this change
- Mark anything in the description of the current state that is based on inference as [assumption]

**Business impact**: what changes I will see after the change, and what stays the same (plain words, no code)

**Where to regression-test**: besides the new feature, which existing features to click through to confirm nothing broke

**Extra findings** (if any): other problems noticed along the way; do not change them, only report them
