# Evidence-first Dev Workflow

[English](README.md) | 简体中文

Evidence-first Dev Workflow 是一套面向 AI coding 的分阶段 Prompt 工作流：先读代码，再比较路线；先确认方案，再严格执行；最后用验证和对抗评审收口。

它不是一个“万能 Prompt”，也不是让 AI 一次性从需求写到上线的自动驾驶流程。它的目标更具体：当你已经在用 AI 写代码，但经常被它的猜测、越界修改和过早实现拖累时，用一组阶段化模板把 agent 拉回证据、边界和验证。

## 它解决什么问题

AI coding 真正危险的地方，通常不是它不会写代码，而是它太快进入实现：

- 没读相关代码就开始猜。
- 把定位、路线、方案和执行混在一起。
- 顺手重构、格式化、改无关文件。
- 把 typecheck 通过当成功能正确。
- 对另一个 AI 的评审照单全收，或未经验证直接否定。

这套工作流不要求 agent 从一句需求直接跳到最终 patch，而是把一次开发拆成可以检查、可以中止、可以复核的阶段。

## 快速开始：复制一个 Prompt

推荐主路径是直接复制 Prompt 模板。

1. 判断你现在处在哪个阶段。
2. 打开 `prompts/zh-CN/` 下对应的模板。
3. 如果模板需要上下文，把问题现象、已有讨论、方案或评审粘到模板里的上下文位置。
4. 把完整 Prompt 复制给你的 AI coding 工具。
5. 按模板约束推进：只读阶段不改文件，方案阶段只出施工图，执行阶段只应用确认过的改动。

如果你只知道“出问题了”，从 `prompts/zh-CN/01-diagnose.md` 开始。

## 按场景选模板

| 阶段 | 你现在要做什么 | 使用模板 |
|---|---|---|
| 定位 | 查 bug 或定位相关代码 | `prompts/zh-CN/01-diagnose.md` |
| 路线 | 已经定位问题，想比较修法 | `prompts/zh-CN/02-route-known-problem.md` |
| 路线 | 你有自己的优化想法，想让 AI 挑战它 | `prompts/zh-CN/03-route-with-user-idea.md` |
| 路线 | 只有现象，没有预设方案 | `prompts/zh-CN/04-route-without-user-idea.md` |
| 方案 | 要一个小范围修改方案，不直接改代码 | `prompts/zh-CN/05-small-plan.md` |
| 方案 | 要一个多文件或复杂修改方案 | `prompts/zh-CN/06-large-plan.md` |
| 执行 | 已批准小方案，要严格执行 | `prompts/zh-CN/07-small-execute.md` |
| 执行 | 已批准完整方案，要严格执行 | `prompts/zh-CN/08-strict-execute.md` |
| 评审 | 让另一个 AI 评审早期思路，并且允许读代码 | `prompts/zh-CN/09-early-idea-review-with-code.md` |
| 评审 | 让另一个 AI 只基于对话评审早期思路 | `prompts/zh-CN/10-early-idea-review-from-chat.md` |
| 评审 | 正式方案执行前最后挑刺 | `prompts/zh-CN/11-final-plan-review.md` |
| 评审 | 复核另一个 AI 的批评，不盲从 | `prompts/zh-CN/12-review-response-triage.md` |
| 评审 | 审视和升级一个 Prompt | `prompts/zh-CN/13-prompt-quality-review.md` |

## 五阶段工作流

```mermaid
flowchart LR
  A["定位\n只读代码"] --> B["路线\n比较修法"]
  B --> C["方案\n输出施工图"]
  C --> D["执行\n机械应用 diff"]
  D --> E["评审\n复核与收尾"]
```

1. **定位**：只读代码，用文件行号给证据，区分事实和推断。
2. **路线**：比较不同机制，不急着写 diff。
3. **方案**：只出施工图，不改代码。
4. **执行**：只应用确认过的 diff，不顺手重构。
5. **评审**：对抗挑刺、复核批评、归档低价值意见。

核心原则是：证据优先、阶段分离、最小改动、验证闭环。

## 如何填充任务上下文

很多模板都需要本次任务的上下文，例如问题现象、之前的对话、已有方案或另一个 AI 的评审。

Prompt 模板是可复制、可编辑的工作稿。你可以在本地临时把上下文粘到模板里，复制给 AI 后再撤回本地改动，或者确保这些私人上下文不会提交进仓库。

如果上下文很长，也可以把上下文放在本地文件里，然后在 Prompt 中要求 agent 读取这个文件路径。

更多示例见 `docs/context-injection.md`。

## Codex Skill 辅助入口

如果你在 Codex 中使用本仓库，可以把 `skills/evidence-first-dev-workflow/` 作为 Skill 安装或复制到 Codex skills 目录。

Skill 的作用是按阶段加载稳定规则，适合减少重复粘贴协议文本。但它不是推荐主路径：需要填充上下文的任务，仍然要在聊天消息里提供上下文，或提供一个文件路径让 agent 读取。

不要修改 `skills/evidence-first-dev-workflow/` 里的 Skill 文件来粘贴一次性任务上下文。Skill 文件是稳定规则，不是草稿纸。

## 项目级集成

如果你希望把这套规则放进项目级约束，可以参考：

- `integrations/AGENTS.md`：Codex 风格的项目指令。
- `integrations/CLAUDE.md`：Claude Code 项目指令。
- `integrations/cursor-rules.mdc`：Cursor rules。

这些集成适合长期约束 agent 行为；日常处理具体问题时，仍然推荐先按场景复制 Prompt 模板。

## 安全边界

这套工作流可以提高 AI coding 的可控性，但不能替代高风险操作所需的审批、回滚、审计和权限边界。

以下场景需要额外控制：

- 生产发布。
- 数据库迁移。
- 支付、账单、权限等不可逆或高风险变更。
- 自动远程推送和发布。

## 仓库结构

```text
README.md                 英文入口
README.zh-CN.md           中文入口
docs/                     工作流说明与上下文注入说明
prompts/zh-CN/            中文 Prompt 模板
prompts/en/               英文 Prompt 模板
skills/evidence-first-dev-workflow/  Codex Skill 辅助入口
integrations/             AGENTS.md / CLAUDE.md / Cursor rules
examples/                 示例流程
```

## 更多文档

- `docs/stage-guide.md`：按场景选择阶段和使用方式。
- `docs/context-injection.md`：任务上下文应该放在哪里。
- `docs/workflow.md`：五阶段工作流概览。
- `examples/bugfix-flow.md`：bugfix 流程示例。
- `examples/feature-flow.md`：功能开发流程示例。
- `examples/adversarial-review-flow.md`：对抗评审流程示例。

## License

MIT
