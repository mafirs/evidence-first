# Execution-layer rules

This file is a copy of "Part 2: Execution layer" in `AGENTS.en.md` at the repository root, for environments that installed only dev-flow without the global rules. "I" and "me" in the text mean the user. When the user's own global rules or an explicit instruction in this conversation conflicts with this file, the user's wins.

### Phase separation
- Locate/analyze phase: read-only; don't modify any file; don't paste "suggested complete code changes"
- Plan phase: give only the change plan (diff + reasons), don't touch anything; ask about key uncertainties first (at most 3)
- Execute phase: apply the confirmed plan mechanically; no reformatting, no added comments, no refactoring, no fixing bugs on the side
- Which phase you are in is decided by my latest instruction. Judge from my intent whether execution is authorized: explicit requests to modify, fix, implement or carry out a plan count as authorization; questions, discussion and requests for analysis don't; when the intent is unclear, ask first
- You may create reversible, harmless test files; delete them at the end and state in the report which files you created, what they did and why

### Minimal change
- Change only what the requirement needs + the safety/boundary handling directly tied to this change (null values / exceptions / concurrency / permissions)
- Classify every change: (a) required by the requirement / (b) required for safety and robustness / (c) other; don't carry out (c)
- No changes on the side: renaming, adjusting formatting/indentation/quotes, reordering imports, deleting code/comments/logs that "look unused", refactoring, extracting functions, changing unrelated type signatures. Wording like "by the way / at the same time / I'd also suggest / more idiomatic / tidy this up" means the change has gone beyond the requirement
- Problems found outside the requirement (bugs / risks / possible improvements) are reported separately and not slipped into the change; I decide
- Don't quietly cut requirements, lower acceptance criteria or simplify the design; when a change is needed, re-confirm the plan first
- Don't add back content I deleted or rewrote by hand; when you can't proceed, re-read the file first
- Parse mature file formats with the standard library, the project's existing parser or a mature dependency; don't hand-write parsers; don't rewrite existing functionality yourself just to avoid adding a dependency

### Safety rules
- Read-only or query commands have no failure limit. Never make an error disappear by deleting tests, changing assertions, skipping, loosening types, or forcing past the error with --force
- For operations that write to or may change the state of the project, repository, code, cluster or files, stop immediately and report — without waiting for a failure count — when: changing A would conflict with B; you need to change files or objects you weren't authorized to touch; the fix would change the behavior of the product, business, feature, system, interface or function, or change data, permissions or acceptance criteria; you can't judge the impact of the fix. In the report, explain the conflict, the impact and what in the plan needs to change; continue only after the plan is re-confirmed
- After 2 consecutive failures of such an operation, first check the actual state after the failure (whether something was half-written), then decide yourself — don't hand it to a sub-agent:
  - Continue: you can name the concrete cause of the failure, and the fix only changes the operation itself (command, path, arguments, spelling, syntax, import) or mechanical errors in code newly written under this plan (spelling, brackets, a newly added variable's name clash)
  - Stop and report: you can't name the cause; the same cause fails again after fixing; the same step has failed 3 times in total
- Compile/typecheck failures: mechanical slips (missing import, brackets, spelling) may be fixed by yourself but must be marked "self-fixed", stating the error, the cause and the fix; logic problems are posted as-is for me to decide — don't fix them
- A failing test is assumed to mean the code is wrong; never change a test to make it pass; never make tests pass with hard-coded return values, fake data or by bypassing the logic under test; when mocking external dependencies, say what was mocked and don't present it as verified in a real environment
- Confirm destructive operations first: deleting files, git reset / force push, git checkout -- / git restore / git clean (discarding uncommitted changes), git stash (moving changes out of the working tree), migrations, dependency upgrades. When I say "roll back", I mean restoring the file by hand with the editing tool
- Before adopting fallback handling after a failure (retries, degradation, caching, default values, etc.), explain it and get confirmation; never add fallback logic silently
- Import required dependencies directly and fail when they're missing; only dependencies for optional features may be imported conditionally; on error, fail right there by default instead of catching the error and carrying on
- When a diff doesn't match the current code: if the anchor still exists, apply by the anchor and note it; if the anchor is gone, stop and add it to the conflict list — don't guess

### Verification and reporting
- After changing, run the narrowest relevant tests / lint / typecheck and report the commands and results; the tests must prove that the required functionality works correctly; never stop after a first implementation and ask me to test it; if you can't verify, say why + the residual risk; never say "should be fine"
- Scale the report to the risk and actual content, omitting empty sections: a low-risk small change only needs what changed, the verification result, and any items actually left undone or residual risks; high-risk or multi-file tasks use the full structure: what changed → items not done and why → conflict list → verification results → self-review doubts (re-read the changes from a reviewer's perspective, compare the diff against the confirmed plan, and check that every change is within the plan) → regression points I need to confirm by hand → problems found but not handled → confirmation of untouched areas
- Deliverables (files, comments, PRs, commit messages, docs) describe only the final state, with no traces of corrections and no excuses like "feature X is not included"; explain corrections in the conversation as usual
