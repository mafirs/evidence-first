# Evidence-first Dev Workflow

一套证据优先的 AI-native 开发工作流：先读代码，再定路线；先出施工图，再机械执行；最后用对抗评审挡住误改和脑补。

它不是一个“Prompt 合集”，也不是让 AI 一次性从需求写到上线的万能咒语。它是一套分阶段开发协议：每个阶段只做一件事，每个关键结论都要有代码证据，每次执行都只碰确认过的范围。

## 它解决什么问题

AI 写代码时常见的问题不是“不会写”，而是：

- 没读代码就替你猜。
- 把定位、方案、执行混在一起。
- 顺手重构、格式化、改无关代码。
- 把类型检查通过误当成功能正确。
- 对另一个 AI 的评审照单全收或直接否定。
- 问题还没定位清楚，就开始输出实现细节。

这套工作流的目标是让 coding agent 像一个靠谱同事：先查证，再判断；先选路线，再写施工图；先确认方案，再机械执行；最后用验证和对抗评审收口。

## 五阶段工作流

```mermaid
flowchart LR
  A["定位
只读代码"] --> B["路线
比较修法"]
  B --> C["方案
输出施工图"]
  C --> D["执行
机械应用 diff"]
  D --> E["评审
复核与收尾"]
```

1. **定位**：只读代码，用文件行号给证据，区分事实和推断。
2. **路线**：比较不同修法，不急着写 diff。
3. **方案**：只出施工图，不改代码。
4. **执行**：只机械应用确认过的 diff，不顺手重构。
5. **评审**：对抗挑刺、复核批评、归档低价值意见。

## 两种使用方式

### 方式一：Prompt 模板模式

适合你手动复制使用。

1. 打开 `prompts/zh-CN/` 下对应阶段的模板。
2. 如果模板需要上下文，把对话、方案或评审内容粘到占位符位置。
3. 整体复制给 AI。
4. 不要把私人上下文提交进仓库。

这种模式最接近原始用法：你可以在本地临时粘贴内容，复制后撤回或不保存。

### 方式二：Codex Skill 模式

适合在 Codex 中长期使用。

不要修改 `skills/evidence-first-dev-workflow/` 里的 Skill 文件来粘贴任务上下文。Skill 文件是稳定规则，不是草稿纸。

正确做法是在聊天消息里提供上下文，例如：

```text
使用 evidence-first-dev-workflow，进入“没有预设方案的路线比较”阶段。

上下文如下：
<粘贴问题现象、对话和已有讨论>

本轮只读不改。
```

Skill 负责加载阶段规则；你的消息负责提供本次任务上下文。详细说明见 `docs/context-injection.md`。

## 按场景选模板

| 你现在要做什么 | 推荐模板 |
|---|---|
| 查 bug 或定位相关代码 | `prompts/zh-CN/01-diagnose.md` |
| 已经定位问题，想比较修法 | `prompts/zh-CN/02-route-known-problem.md` |
| 你有自己的优化想法，想让 AI 挑战它 | `prompts/zh-CN/03-route-with-user-idea.md` |
| 只有现象，没有预设方案 | `prompts/zh-CN/04-route-without-user-idea.md` |
| 要一个小范围修改方案，不直接改代码 | `prompts/zh-CN/05-small-plan.md` |
| 要一个多文件或复杂修改方案 | `prompts/zh-CN/06-large-plan.md` |
| 已批准小方案，要严格执行 | `prompts/zh-CN/07-small-execute.md` |
| 已批准完整方案，要严格执行 | `prompts/zh-CN/08-strict-execute.md` |
| 让另一个 AI 评审早期思路，并且允许读代码 | `prompts/zh-CN/09-early-idea-review-with-code.md` |
| 让另一个 AI 只基于对话评审早期思路 | `prompts/zh-CN/10-early-idea-review-from-chat.md` |
| 正式方案执行前最后挑刺 | `prompts/zh-CN/11-final-plan-review.md` |
| 复核另一个 AI 的批评，不盲从 | `prompts/zh-CN/12-review-response-triage.md` |
| 审视和升级一个 Prompt | `prompts/zh-CN/13-prompt-quality-review.md` |

## 仓库结构

```text
README.md                 英文入口
README.zh-CN.md           中文入口
docs/                     工作流说明
prompts/zh-CN/            中文 Prompt 模板
prompts/en/               英文核心 Prompt 模板
skills/evidence-first-dev-workflow/  Codex Skill
integrations/             AGENTS.md / CLAUDE.md / Cursor rules
examples/                 示例流程
```

## Skill 和 Prompt 模板的区别

- **Prompt 模板**：给人复制、编辑、粘贴上下文。适合一次性使用和手动工作流。
- **Skill**：给 Codex 自动调用。它只保存稳定规则和阶段路由，不保存你的任务上下文。

如果你要把一段对话、评审或方案交给 AI，用 Prompt 模板时可以粘进模板；用 Skill 时要粘在聊天消息里，或提供一个文件路径让 agent 读取。

## 不适用场景

第一版不覆盖这些高风险流程：

- 生产发布。
- 数据库迁移。
- 支付、账单、权限等不可逆或高风险变更。
- 自动远程推送和发布。

这些场景需要额外的确认、回滚、审计和权限控制。

## 发布前注意

- 替换 `LICENSE` 里的 `<YOUR_NAME>`。
- 检查示例是否包含真实项目路径或私人上下文。
- 如果要面向英文社区，优先补全 `prompts/en/` 中缺失的高级模板。
