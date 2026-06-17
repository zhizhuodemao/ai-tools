# AI Tools

普通人学 AI 的 Agent 能力仓库。这个仓库只维护三类能力形态：

- `mcp/`: MCP 服务和工具包。
- `skill/`: 可被支持 Skill 的 Agent 直接使用的技能。
- `plugin/`: 可在 Codex App 中安装的插件。

## BOSS 简历投递助手

当前版本：`1.0.5`

BOSS 简历投递助手会先理解简历，再通过 Kimi WebBridge 查看真实 BOSS 岗位和公司信息，基于固定指标评分，生成校准报告，并在用户确认策略和限额后创建受控自动化任务。

### Codex App 安装

适合支持 Codex Plugin 的用户。

```bash
codex plugin marketplace add https://github.com/zhizhuodemao/ai-tools.git
codex plugin add boss-resume-agent-plugin@ai-tools
```

安装后重启 Codex App 或新开线程，然后可以这样使用：

```text
使用 BOSS 简历投递助手，用 Kimi 打开 BOSS，先建立我的简历画像和岗位画像，不要直接投递。
```

### Standalone Skill 使用

适合不支持 Codex Plugin、但支持 Skill 的 Agent。

使用这个目录：

```text
skill/boss-resume-job-agent
```

该目录包含完整技能本体：

```text
SKILL.md
agents/openai.yaml
references/
```

### Plugin 源码

Codex 插件源码在：

```text
plugin/boss-resume-agent-plugin
```

其中内嵌同一份 BOSS skill：

```text
plugin/boss-resume-agent-plugin/skills/boss-resume-job-agent
```

维护规则：先更新 `skill/boss-resume-job-agent`，再同步到插件内嵌目录，保持两边一致。

## 前置要求

BOSS 简历投递助手只使用 Kimi WebBridge 操作用户真实浏览器，不使用 Codex Chrome、in-app browser、Playwright、Selenium 或隐藏 DOM 抓取来替代可见点击。

使用前请确认：

- Kimi WebBridge 已安装并启用。
- Kimi WebBridge 已连接到用户真实浏览器。
- 该浏览器已登录 BOSS 直聘。

如果 Kimi WebBridge 不可用，技能会停止并提示安装或连接，不会切换到其他浏览器后端。

## Kimi WebBridge 安装

浏览器扩展：

```text
https://chromewebstore.google.com/detail/kimi-webbridge/fldmhceldgbpfpkbgopacenieobmligc
```

macOS / Linux:

```bash
curl -fsSL https://cdn.kimi.com/webbridge/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://cdn.kimi.com/webbridge/install.ps1 | iex
```

## 重要边界

- 自动化任务创建前，不直接投递、不打招呼、不收藏、不标记感兴趣。
- 投递数量、岗位方向、城市、薪资和沟通限额必须由用户确认。
- 岗位判断必须基于岗位详情和公司信息。
- 每个候选岗位都必须尝试打开公司页。
- 自动化任务是唯一允许后续投递或沟通的路径。
- 不绕过验证码、短信、人脸、账号风控、权限弹窗或登录限制。
- 不保存密码、验证码、cookie、token、浏览器指纹或其他敏感信息。

## 仓库结构

```text
ai-tools/
├── .agents/plugins/marketplace.json
├── mcp/
│   └── README.md
├── skill/
│   └── boss-resume-job-agent/
│       ├── SKILL.md
│       ├── agents/openai.yaml
│       └── references/
└── plugin/
    └── boss-resume-agent-plugin/
        ├── .codex-plugin/plugin.json
        └── skills/boss-resume-job-agent/
            ├── SKILL.md
            ├── agents/openai.yaml
            └── references/
```
