# AI Tools

普通人学 AI 的 Agent 能力仓库。这里维护可复用的 MCP、Skill 和 Codex Plugin。

## 目录

- `mcp/`: MCP 服务和工具包。
- `skill/`: 可被支持 Skill 的 Agent 直接使用的技能。
- `plugin/`: 可在 Codex App 中安装的插件。
- `docs/`: 每个 MCP、Skill、Plugin 的说明文档。

## 当前能力

| 名称 | 类型 | 版本 | 说明 |
| --- | --- | --- | --- |
| BOSS 简历投递助手 | Skill + Codex Plugin | 1.0.5 | 基于简历画像、BOSS 岗位详情和公司信息生成匹配报告，并在用户确认后创建受控自动化任务。见 [docs/boss-resume-job-agent.md](docs/boss-resume-job-agent.md)。 |

## Codex Plugin 安装

把本仓库作为 Codex marketplace 添加：

```bash
codex plugin marketplace add https://github.com/zhizhuodemao/ai-tools.git
```

安装 BOSS 简历投递助手：

```bash
codex plugin add boss-resume-agent-plugin@ai-tools
```

安装后重启 Codex App 或新开线程。

## Standalone Skill 使用

不支持 Codex Plugin、但支持 Skill 的 Agent 可以直接使用 `skill/` 下的对应目录。

当前可用 Skill：

```text
skill/boss-resume-job-agent
```

## 仓库结构

```text
ai-tools/
├── .agents/plugins/marketplace.json
├── docs/
├── mcp/
├── skill/
│   └── boss-resume-job-agent/
└── plugin/
    └── boss-resume-agent-plugin/
```

## 维护原则

- 根 README 只放总体说明、索引和通用安装入口。
- 每个能力的详细说明放在 `docs/`。
- 如果一个能力同时提供 Skill 和 Plugin，优先维护 `skill/` 中的通用 Skill，再同步到 `plugin/` 中的内嵌 Skill。
- 不把临时发布包、安装器、个人状态、账号信息或敏感数据提交到仓库。
