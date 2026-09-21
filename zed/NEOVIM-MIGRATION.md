# Neovim → Zed 迁移说明

来源：本机 `~/.config/nvim`（LazyVim + 自定义 Catppuccin Mocha）。针对 Zed 1.20.2 配置。

## 配色与透明度

当前使用 `Catppuccin Mocha` 加 `settings.json` 中的 `theme_overrides`，立即生效，无需重启当前对话。独立主题 `themes/neovim-mocha-transparent.json` 也已保存，下次启动 Zed 后可在主题选择器中选择 `Neovim Mocha Transparent`。

- `background.appearance = transparent`；窗口底色 `#1e1e2eeb`，alpha 约 92%，沿用 Ghostty / Kitty 的透明度偏好。编辑区、行号区、面板、工具栏和标签栏使用 `#00000000`，避免重复叠加。标题栏和状态栏位于独立区域，单独使用相同的半透明底色。
- 关键字红色、函数 sapphire 蓝色、类型黄色、数字紫色、变量粉色、字符串 teal；保留函数和类型粗体、关键字粗斜体、注释斜体。
- 当前行号绿色、活动缩进线红色、分隔边框粉色、Git 修改提示桃色。
- 选区采用半透明红色。Zed 无法直接复刻 Neovim Visual 的独立前景色，保留语法颜色以保证可读性。
- 保留原有字体、字号、面板位置、Catppuccin 图标和 Codex ACP 配置。

需要更透明，可在 `settings.json` 的主题覆盖内，将 `background`、`title_bar.background`、`title_bar.inactive_background`、`status_bar.background` 的末尾 `eb` 改成 `cc`（80%）或 `b3`（70%）。内部区域的 `#00000000` 保持不变，避免重新堆叠背景。如果改用独立主题，则修改主题文件中的相同颜色。

## 常用按键

以下空格序列用于 Vim 普通模式；原有 Zed Cmd 快捷键保留。

| 按键 | Zed 行为 |
| --- | --- |
| Space Space / Space f f | 文件搜索 |
| Space f r / Space f R | 文件搜索（空查询包含最近文件） |
| Space f p / Space f z | 最近项目 |
| Space f l | 当前文件搜索 |
| Space / / Space s g | 项目搜索 |
| Space e / Space c w / Ctrl-Up | 项目文件面板 |
| Space c s | 大纲面板 |
| Space s s / Space s S | 文件符号 / 项目符号 |
| Space - / Space \| | 向下 / 向右分屏 |
| Ctrl-h/j/k/l | 在 Zed 编辑器窗格间导航 |
| H / L / [b / ]b | 上一个 / 下一个标签 |
| Space b b / Space , | 标签切换器 |
| Space b d / b o / b a | 关闭当前 / 其他 / 当前窗格所有标签（保留固定标签，未保存内容由 Zed 提示） |
| Space c a / c r / c f | 代码操作 / 重命名 / 格式化 |
| Space x x / x q / x l | 诊断面板 |
| [d / ]d / [e / ]e | 上下诊断 / 上下错误 |
| Space g g / Space g b | Git 面板 / 行 blame |
| Space f t / Ctrl-/ | 终端 |
| Space o o / o t | 任务选择器 |
| Space o w / o r | 任务终端 / 重跑上次任务 |
| Space a a / a o | 现有 Zed Agent 面板 |
| Space u w / u h | 切换折行 / inlay hints |
| Space w m / Space u z | 缩放当前窗格 |
| Ctrl-s | 保存 |
| Alt-j/k | 移动代码行 |
| Ctrl-a（普通模式） | 全选 |
| Ctrl-a（插入模式） | 代码操作 |
| Ctrl-y（补全菜单） | 接受补全 |
| Ctrl-l/h（snippet 内） | 下一个 / 上一个占位符 |
| Ctrl-i / Ctrl-j（插入模式、存在预测时） | 接受预测 / 接受下一个词 |
| + / - | 数字加减 |
| G | 文件末尾并居中 |

`d/D/c/C` 和普通模式 `x` 使用黑洞寄存器，不覆盖复制内容；`y/p` 保持 Vim 的复制粘贴行为。`j/k` 无计数时按显示行移动，有计数时按实际行移动。输入 Leader 后等待 500ms 会显示 Which-key 提示。

## 编辑、语言与任务

启用两空格缩进、软折行、上下 10 行滚动边距、相对行号、自动签名提示、保存格式化和 LSP 语义配色；默认隐藏 inlay hints。语言默认值及项目设置仍可覆盖全局值（例如 Go 使用 tab）。

已迁移 Go、TypeScript、Vue、Markdown 的 23 个 snippets，TypeScript snippets 同时用于 TSX。snippets 文件位于 `snippets/`。

Go 复用本机 gopls，迁移 gofumpt、staticcheck、诊断规则、自动补全及 code lens 设置。

`tasks.json` 提供 Go 当前测试函数，以及 Go / Bun（JS、TS）/ Python / Lua / Shell 当前文件运行。任务只在手动选择后执行；需要对应解释器已安装。Go 测试函数通过光标所在符号 `$ZED_SYMBOL` 定位。其他语言仍使用 Zed 当前的语言支持和现有扩展，未强制更换语言服务器。

## 与 Neovim 的差异

Zed 不直接执行 Neovim Lua 插件，以下没有声称实现完全等价迁移：

- Yazi → 项目面板；Zoxide → 最近项目；LazyGit → Git 面板；Snacks picker → Zed 搜索和符号面板。
- Ctrl-h/j/k/l 只控制 Zed 窗格，不能像 vim-tmux-navigator 那样跨入外部 tmux 窗格。
- `Space f r / f R` 都使用 Zed 文件搜索，不区分 Neovim 的 cwd / 全局历史；`Space b b` 打开切换器，不是直接切到 alternate buffer。
- TreeSJ 的 `J/gS/gJ` 语法树拆分合并、Harpoon 列表、Snacks picker resume、Markdown 自定义 checkbox / todo 循环、Go 自定义结构体标签命令、词典补全及 Neovim 特有 UI/动画没有原样移植。相应默认 Vim 键位保持 Zed 行为。
- 原 Supermaven / CodeCompanion 不在 Zed 内运行；保留你已有的 Codex ACP，并映射 Agent 面板和 Zed 预测接受按键。预测需要 Zed 中存在可用的预测提供方。
- Zed 与 Neovim 使用不同的语法捕获与 LSP 语义规则，因此颜色按语义对应，不能保证每个语言 token 完全一致。

## 备份与验证

修改前的设置位于 `backups/before-nvim-20260920-234423/settings.json`。原来没有自定义 keymap、themes、snippets、tasks，新增文件均位于当前 `zed/` 目录。

配置 JSON 已解析检查；94 项按键定义中的 action 名称已与 Zed 1.20.2 官方默认 keymap 核对。Zed 已加载实时主题覆盖，更新后日志未发现新增 settings/keymap/theme/snippet 解析错误；预览文件的 gopls 已正常启动。未逐项手动测试全部按键及所有语言运行任务。

如需回退，先保留当前 `zed/` 配置副本，再用备份覆盖 `settings.json`，将此次新增的 `keymap.json`、`tasks.json`、`snippets/`、`themes/` 移出 Zed 配置目录。

参考：[主题覆盖](https://zed.dev/docs/themes)、[Vim 模式](https://zed.dev/docs/vim)、[Snippets](https://zed.dev/docs/snippets)、[Tasks](https://zed.dev/docs/tasks)、[Go](https://zed.dev/docs/languages/go)。

## 2026-09-21 透明度修正

上次配置在父窗口与子面板重复绘制 92% 不透明背景，使整体接近不透明。已移除 12 项子区域背景填充；保留单层窗口底色，以及独立的标题栏和状态栏底色。修正前副本在 `backups/before-transparency-fix-20260921-001704/`。

已核对当前版本的 workspace 绘制层级及主题覆盖实现，JSON 校验通过。窗口截图显示底色已更新；截图未包含窗口后方桌面，因此真实透出效果仍需以屏幕观感为准。

## 2026-09-21 面板切换修正

启用 `close_panel_on_toggle: true`：面板已聚焦时，再次执行它的 ToggleFocus 动作会关闭面板。

- `Space g g`：打开 / 聚焦 Git；在 Git 列表再按一次会收起。
- Git 文件列表 / 历史列表中的 `q`：收起当前面板。写提交信息、选择分支或仓库时不接管 q。
- `Space a a` / `Space a o`：打开 / 聚焦 Agent，再按一次收起；Agent 的文本编辑区也支持这两个序列。
- Agent 非编辑区或 Vim 普通模式下的 `q`：收起面板。输入状态保留字母 q；先 Esc 进入普通模式后可按 q。
- 文件树和大纲面板也支持各自的 Leader 快捷键重复收起，非编辑状态按 q 关闭。
- Agent 输入框中的 `Space a a`、`Space a o`、`Space g g` 被保留为面板快捷键；输入这些完整字符序列会触发对应动作。

已校验 JSON、动作名称、上下文范围，以及 Zed 1.20.2 的 close_panel_on_toggle 原生实现。自动 UI 实测因用户同时操作窗口及焦点变化而未完成，未将配置校验视为端到端实测通过。
修正前备份：`backups/before-panel-toggle-20260921-002208/`。

## 2026-09-21 连续调整窗格尺寸

在代码编辑区的 Vim 普通模式下，按 `Ctrl-w`，再按：

| 按键 | 效果 |
| --- | --- |
| `<` | 缩窄当前窗格 4 列，当前字号下约 38.4 个逻辑像素 |
| `>` | 增宽当前窗格 4 列，当前字号下约 38.4 个逻辑像素 |
| `=` | 降低当前窗格 2 行，当前行距下约 51.8 个逻辑像素 |
| `+` | 增高当前窗格 2 行，当前行距下约 51.8 个逻辑像素 |
| `U` / `u` | 恢复编辑器分屏均分 |

执行一次后进入连续调整状态，可继续按上述符号，无需再按 Ctrl-w；系统发出的长按重复按键也使用相同映射。`Esc`、`Ctrl-[` 或 `q` 退出。原有 H/J/K/L 映射保留。

Zed 的中央编辑器分屏尺寸动作只支持整数列宽/行高，未提供像素步长。本配置以约 40 像素为目标，按当前 16px JetBrainsMono 字体和默认 1.618 行距选择最接近的整数步长：水平 4 列、垂直 2 行；没有为改变步长而调整字体或行距。缩放字号后实际像素量也会变化，最小窗格尺寸会限制缩放。

实现使用 F13–F16 调用原生尺寸动作，F19 清除旧计数，F20 作为内部续接前缀，仅作用于代码编辑区的 Vim 普通模式。状态栏可能显示 `f20` 表示正在等待下一次缩放。退出后原有符号键含义恢复。

此前已在独立临时窗口实测四种尺寸动作、连续触发、U 均分及 Esc 退出；本次仅交换符号对应关系并缩小计数，已校验方向和计数。实体键盘长按未单独模拟。
本次修改前备份：`backups/before-resize-step-adjustment-20260921-003741/`。


## 2026-09-21 扩展连续缩放至面板

原先的绑定仅匹配代码编辑区的 Vim 普通模式；现在为 Dock 及其内部编辑器、终端和常见面板补充绑定，覆盖 Agent、Git、项目文件树、大纲等。Agent 输入框需先按 Esc 进入普通模式，才能用 `Ctrl-w` 后的尺寸键。

面板使用原生 `IncreaseActiveDockSize` / `DecreaseActiveDockSize` 的 `px: 40` 参数，每次调整 40 个逻辑像素。侧边面板用 `<` / `>` 缩窄、增宽；底部面板用 `=` / `+` 降高、加高。Dock 只有一个可调整的方向，因此 `<` 与 `=` 都缩小当前可调整尺寸，`>` 与 `+` 都增大。最小尺寸限制仍然适用。

连续按键无需重复 Ctrl-w；`U` / `u` 恢复当前面板默认大小。`Esc`、`Ctrl-[`、`q` 消耗续接前缀并退出连续缩放，之后恢复普通按键行为。退出使用空的 `SendKeystrokes` 动作：`null` 只是解除绑定，不能可靠消耗等待中的组合键。

面板内 F13/F14/F17 分别用于缩小、增大和恢复尺寸，F20 用于续接。面板绑定不发送 Vim 数字计数，避免数字进入 Agent 或终端输入。

已在独立临时窗口实测 Agent 输入模式连续增宽、此前连续缩窄，以及普通模式下 Esc 退出和 U 恢复默认大小。JSON 校验通过，原有编辑器分屏绑定保持不变；其余面板共用 Dock 动作，未逐个 UI 实测。修改前备份：`backups/before-dock-resize-20260921-004000/`。

减高键已由 `-` 改为 `=`：编辑器和面板均使用 `Ctrl-w =` 进入、连续 `=` 继续减高。编辑器的 U 均分通过 F17 直接调用 `vim::ResetPaneSizes`，避免与新的 `Ctrl-w =` 含义冲突。

## s 分屏快捷键

已移除试用的 Sneak 跳转，恢复普通模式下 `ss` 向下分屏、`sv` 向右分屏。`Space -` / `Space |` 分屏也继续保留。

## Agent 对话滚动

焦点在 Agent 会话输入框、处于 Vim 普通模式且没有菜单时，`Ctrl-u` / `Ctrl-d` 分别向上 / 向下滚动一页对话内容。使用原生 `agent::ScrollOutputPageUp` / `agent::ScrollOutputPageDown`，不移动输入框中的光标；插入模式及代码编辑区按键行为保持原样。

## Insert 模式 Ctrl-w

Agent 输入框和代码编辑器在 Vim Insert 模式下，`Ctrl-w` 使用原生 `editor::DeleteToPreviousWordStart` 删除前一个单词。两组 Dock 缩放绑定均排除 `vim_mode == insert`，避免 Ctrl-w 被当作组合键前缀而等待后续输入。普通模式及其他面板的缩放绑定保留。
