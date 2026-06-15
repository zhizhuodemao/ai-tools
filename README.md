# BOSS 简历投递助手

更聪明的 AI 投简历助手：先理解简历，再理解岗位，最后创建受控自动化投递任务。

当前版本：`1.0.3`

这个仓库支持三种分发形态：

- Codex plugin：下载 `dist/boss-resume-agent-codex-1.0.3.zip`，解压后双击安装器。
- Codex marketplace：添加本仓库地址，在 Codex App 的 `Plugins` 里安装。
- Standalone skill：给不支持 Codex plugin、但支持 skill 或 zip 导入的 agent 使用。

## 适合谁

适合已经有简历、有求职方向，但不想每天重复搜索、筛选、判断和投递的人。

## 前置要求

这个插件/skill 只使用 Kimi WebBridge 进行浏览器操作，不使用 Codex Chrome。

使用前请确认：

- Codex App 已安装或启用 Kimi WebBridge。
- Kimi WebBridge 能控制用户已经登录 BOSS 直聘的真实浏览器。
- 如果 Kimi WebBridge 不可用，本插件会停止并提示修复，不会切换到 Codex Chrome。

## 推荐安装：双击安装器

### macOS

下载并解压 `dist/boss-resume-agent-codex-1.0.3.zip` 后，双击：

```text
BOSS Resume Agent Installer.app
```

如果系统提示无法打开未签名应用，可以右键点击这个 app，然后选择 `打开`。

安装完成后：

1. 重启 Codex App。
2. 打开 Codex App 的 `Plugins`。
3. 在个人插件源里找到「BOSS 简历投递助手」。
4. 点击 `Add to Codex`。
5. 新开一个 Codex 线程使用。

安装器会在安装前显示：

- 当前包版本
- 本机已安装版本
- 如果没有旧版本，会显示未安装

### Windows

下载并解压 `dist/boss-resume-agent-codex-1.0.3.zip` 后，双击：

```text
install-windows.bat
```

安装器会打开一个小窗口。点击 `Install` 即可。

安装完成后：

1. 重启 Codex App。
2. 打开 Codex App 的 `Plugins`。
3. 在个人插件源里找到「BOSS 简历投递助手」。
4. 点击 `Add to Codex`。
5. 新开一个 Codex 线程使用。

安装窗口会在点击 `Install` 前显示当前包版本和本机已安装版本。

## 备用安装：命令行脚本

1. 解压 `boss-resume-agent-codex-1.0.3.zip`。
2. 进入解压后的目录。
3. macOS 用户可以运行安装脚本：

```bash
bash install-macos.sh
```

也可以双击备用入口：

```text
install-macos.command
```

## Standalone skill

如果目标 agent 不支持 Codex plugin，只支持 skill 文件或 zip，可以使用：

- `dist/boss-resume-job-agent-1.0.3.skill`
- `dist/boss-resume-job-agent-skill-1.0.3.zip`

这两个文件只包含 skill 本体：

```text
SKILL.md
agents/openai.yaml
references/
```

Standalone skill 不包含 Codex plugin manifest、marketplace、图形安装器或安装脚本，但保留同一套岗位画像、岗位详情、公司页、评分和自动化边界规则。

## 使用方式

新开线程后，可以这样说：

```text
使用 BOSS 简历投递助手，用 Kimi 打开 BOSS，先建立我的简历画像和岗位画像，不要直接投递。
```

## 可选：作为 marketplace 仓库发布

这个仓库已经包含 Codex marketplace 结构，用户可以添加 marketplace：

```bash
codex plugin marketplace add https://github.com/zhizhuodemao/ai-tools.git
```

然后重启 Codex App，在 `Plugins` 里安装「BOSS 简历投递助手」。

## 重要边界

- 自动化任务创建前，不直接投递。
- 投递数量、岗位方向、城市薪资等必须由用户确认。
- 岗位判断必须基于岗位详情和公司信息。
- 公司页必须尝试打开查看。
- 自动化任务是唯一允许后续投递或沟通的路径。

## 仓库结构

```text
ai-tools/
├── .agents/plugins/marketplace.json
├── BOSS Resume Agent Installer.app
├── dist/boss-resume-agent-codex-1.0.3.zip
├── dist/boss-resume-job-agent-1.0.3.skill
├── dist/boss-resume-job-agent-skill-1.0.3.zip
├── install-windows.bat
├── install-macos.command
├── install-macos.sh
├── plugins/boss-resume-agent-plugin
│   ├── .codex-plugin/plugin.json
│   └── skills/boss-resume-job-agent
│       ├── SKILL.md
│       ├── agents/openai.yaml
│       └── references/
```

## 卸载

1. 在 Codex App 的 `Plugins` 里卸载「BOSS 简历投递助手」。
2. 可选：删除本地插件目录：

```bash
rm -rf ~/plugins/boss-resume-agent-plugin
```

3. 可选：从 `~/.agents/plugins/marketplace.json` 删除 `boss-resume-agent-plugin` 条目。
