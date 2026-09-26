# My dotfiles

## 新 Mac 装机

适用于 Apple Silicon 和 macOS 26 或更新版本（OmniWM 的安装要求）。先将此仓库的最新改动推送到 GitHub，然后在新 Mac 的终端运行：

```sh
curl -fsSL https://raw.githubusercontent.com/SuperOnee/dotfiles/main/setup.sh -o ~/Downloads/setup.sh
chmod +x ~/Downloads/setup.sh
~/Downloads/setup.sh
```

脚本会检查并安装 Homebrew，使用 Homebrew 安装应用、开发环境、Fish、Shottr 截图工具和命令行工具；克隆本仓库到 `~/.config`；用 Fisher 恢复 Fish 插件；启动 PostgreSQL 18 与 Redis；安装雾凇拼音并把当前的 `pink_light` / `pink_dark` 主题和 Squirrel 输入源设为可用。输入源只保留 ABC 英文和鼠须管简体中文，默认选中 ABC。Git Credential Manager 也会启用。Dock 会放在左侧并自动隐藏，触发延迟为 0，显示和隐藏动画为 0.9 秒；菜单栏不显示 Spotlight 搜索图标，系统的 `Command + 空格` Spotlight 快捷键也会关闭。键盘重复速度和重复前延迟设为系统设置中的最快档；Fn 用于切换输入法，F1–F12 默认是标准功能键，Caps Lock 映射为 Esc。Finder 默认显示文件扩展名和隐藏文件。点击桌面仅在台前调度开启时显示桌面。OmniWM 使用仓库中的总览快捷键 `Control + ↑` 和四指上滑；脚本会关闭冲突的 macOS 调度中心快捷键、原生桌面切换快捷键及系统纵向三／四指手势，并开启 OmniWM 所需的“显示器使用独立空间”。

如果 `~/.config` 或 `~/Library/Rime` 已有其他内容，脚本会先把整个目录改名为带时间戳的备份，再克隆配置。再次运行脚本时，会对已克隆的仓库执行 `git pull --ff-only`。脚本会自动确认 Homebrew 软件包的下载与安装；首次安装 Homebrew、管理员密码及 macOS 权限提示仍可能需要手动操作。OmniWM 会在安装后启动，辅助功能与输入监控权限需按系统提示授予，并在 OmniWM 的“设置 → 通用 → 启动”中启用“登录时启动”。如果“显示器使用独立空间”被脚本改动，需注销并重新登录后生效。
