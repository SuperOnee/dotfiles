# My dotfiles

## 新 Mac 装机

适用于 Apple Silicon 和 macOS 26 或更新版本（OmniWM 的安装要求）。先将此仓库的最新改动推送到 GitHub，然后在新 Mac 的终端运行：

```sh
curl -fsSL https://raw.githubusercontent.com/SuperOnee/dotfiles/main/setup.sh -o ~/Downloads/setup.sh
chmod +x ~/Downloads/setup.sh
~/Downloads/setup.sh
```

脚本会检查并安装 Homebrew，使用 Homebrew 安装应用、开发环境、Fish 和命令行工具；克隆本仓库到 `~/.config`；用 Fisher 恢复 Fish 插件；启动 PostgreSQL 18 与 Redis；安装雾凇拼音并把当前的 `pink_light` / `pink_dark` 主题和 Squirrel 输入源设为可用。Git Credential Manager 也会启用。Dock 会放在左侧并自动隐藏，触发延迟为 0，显示和隐藏动画为 0.15 秒。

如果 `~/.config` 或 `~/Library/Rime` 已有其他内容，脚本会先把整个目录改名为带时间戳的备份，再克隆配置。再次运行脚本时，会对已克隆的仓库执行 `git pull --ff-only`。Homebrew 和 macOS 安装过程中可能要求管理员密码；OmniWM、Mos 等应用首次启动时的系统权限仍需按提示授予。
