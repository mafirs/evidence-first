# Changelog

## v0.2.0 — 2026-09-28

### 中文

- 每个模板改成一个独立 skill：`skills/<语言>/ef-<名字>/SKILL.md`。同一个文件可以复制粘贴，也可以在 Claude Code 里用 `/ef-<名字>`、在 Codex 里用 `$ef-<名字>` 调用；新增 `install.sh`。
- 删除原来的阶段路由 skill `evidence-first-dev-workflow`：它的内容是模板的英文摘要，已经和模板不一致。
- 中文模板按维护中的原稿同步：
  - 更新 11 个。例如定位改为两段式输出（先给不看代码的人读的结论，再给证据）；评审复核换了字段（新增"是否已讨论过""不修的后果"，去掉"表态""紧急度""用户感知严重度"）；大修方案要求写进 md 文档，提问上限改为 5 个；严格执行增加"单写者"，删掉仓库独有的"先补最小测试"。定位、两个需求路线、两个方案、终审、复核和两个执行模板加入了子 Agent 分派或限制规则。
  - 新增 7 个：问题路线、寻找参考项目、任务基线、合著者模式、回答标准、优化 Prompt、子 Agent 分派条款。
  - 子 Agent 的写法改为通用写法，不再依赖 Codex 专用的 `spawn_agent` 和 `evidence_searcher`。
- 英文模板和英文规则按中文全文重译，不再压缩。
- 全局规则模板同步到最新版本；阶段模板和全局规则冲突时，以阶段模板为准。
- README 重写：三种用法、安装方式，以及每个模板发给主力 Agent 还是评审 Agent；原 `docs/` 下三个文件的要点并入 README 后删除；示例同步到新路径和新字段。

### English

- Each template is now its own skill: `skills/<lang>/ef-<name>/SKILL.md`. The same file can be copied and pasted, invoked as `/ef-<name>` in Claude Code, or as `$ef-<name>` in Codex; added `install.sh`.
- Removed the stage-router skill `evidence-first-dev-workflow`: its English summaries had drifted from the templates.
- Synced the Chinese templates with the maintained originals:
  - Updated 11 templates. For example, diagnose now has a two-part output (a conclusion for readers who don't read code, then the evidence); review triage has new fields ("discussed before", "consequence if not fixed") and dropped the stance, urgency and user-perceived severity fields; large plan is written into a markdown document and allows up to 5 questions; strict execute adds a single-writer rule and drops the repo-only "add a minimal test first" rule. Diagnose, both requirement-route templates, both plan templates, final review, triage and both execute templates gained sub-agent dispatch or restriction rules.
  - Added 7 templates: known-problem route, find reference projects, task baseline, co-author mode, answer style, optimize prompt, and the sub-agent dispatch clause.
  - Sub-agent instructions are now tool-neutral and no longer depend on the Codex-only `spawn_agent` and `evidence_searcher`.
- Retranslated the English templates and rules in full, without condensing.
- Resynced the global rules template; where a stage template and the global rules conflict, the template wins.
- Rewrote the READMEs: the three ways to use the templates, installation, and whether each template goes to the main agent or the reviewer agent. The essentials of the three `docs/` files moved into the READMEs and the files were removed; examples now use the new paths and fields.

## v0.1.0 — 2026-06-24

首个公开版本（未打 tag）。/ First public version (untagged).
