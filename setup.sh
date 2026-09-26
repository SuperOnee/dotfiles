#!/usr/bin/env bash
# Restore this macOS workstation from Homebrew and SuperOnee/dotfiles.
set -Eeuo pipefail

DOTFILES_URL="https://github.com/SuperOnee/dotfiles.git"
RIME_ICE_URL="https://github.com/iDvel/rime-ice.git"
DOTFILES_DIR="$HOME/.config"
RIME_DIR="$HOME/Library/Rime"
BREW=""

log() { printf '\n==> %s\n' "$*"; }
die() { printf '错误: %s\n' "$*" >&2; exit 1; }
trap 'printf "错误: 第 %s 行执行失败：%s\n" "$LINENO" "$BASH_COMMAND" >&2' ERR

backup_path() {
    local path="$1" backup
    backup="${path}.backup.$(date +%Y%m%d-%H%M%S).$$"
    mv "$path" "$backup"
    log "已有配置已备份到 $backup"
}

check_platform() {
    [[ "$(uname -s)" == Darwin ]] || die "此脚本只支持 macOS"
    [[ "$(id -u)" != 0 ]] || die "请使用普通用户运行，脚本会在需要时调用 sudo"
    # OmniWM's Homebrew cask requires macOS 26+ on Apple Silicon.
    [[ "$(uname -m)" == arm64 ]] || die "OmniWM 需要 Apple Silicon Mac"
    local major
    major="$(sw_vers -productVersion | cut -d. -f1)"
    (( major >= 26 )) || die "OmniWM 需要 macOS 26 或更新版本（当前 $major）"
}

setup_homebrew() {
    log "检查 Homebrew"
    if command -v brew >/dev/null 2>&1; then
        BREW="$(command -v brew)"
    elif [[ -x /opt/homebrew/bin/brew ]]; then
        BREW=/opt/homebrew/bin/brew
    else
        log "安装 Homebrew；安装程序可能要求输入管理员密码"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        BREW=/opt/homebrew/bin/brew
    fi
    [[ -x "$BREW" ]] || die "Homebrew 安装后仍找不到 brew"
    eval "$("$BREW" shellenv bash)"
    "$BREW" --version | head -1
}

install_formula() {
    local name="$1"
    if "$BREW" list --formula "$name" >/dev/null 2>&1; then
        log "已安装 formula: $name"
    else
        log "安装 formula: $name"
        "$BREW" install --yes "$name"
    fi
}

install_cask() {
    local name="$1"
    if "$BREW" list --cask "$name" >/dev/null 2>&1; then
        log "已安装 cask: $name"
    else
        log "安装 cask: $name"
        "$BREW" install --yes --cask "$name"
    fi
}

setup_dotfiles() {
    log "克隆 dotfiles 到 $DOTFILES_DIR"
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        local origin
        origin="$(git -C "$DOTFILES_DIR" remote get-url origin 2>/dev/null || true)"
        case "$origin" in
            "$DOTFILES_URL"|git@github.com:SuperOnee/dotfiles.git)
                git -C "$DOTFILES_DIR" pull --ff-only
                return
                ;;
        esac
    fi
    if [[ -e "$DOTFILES_DIR" || -L "$DOTFILES_DIR" ]]; then
        if [[ -d "$DOTFILES_DIR" ]] && [[ -z "$(ls -A "$DOTFILES_DIR")" ]]; then
            rmdir "$DOTFILES_DIR"
        else
            backup_path "$DOTFILES_DIR"
        fi
    fi
    git clone "$DOTFILES_URL" "$DOTFILES_DIR"
}

setup_git_credentials() {
    log "配置 Git Credential Manager"
    git-credential-manager configure
}

setup_fish() {
    log "安装 Fisher 和 Fish 插件"
    local fish_bin fisher_file
    fish_bin="$(command -v fish)"
    fisher_file="$(mktemp -t fisher.XXXXXX)"
    if ! curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o "$fisher_file"; then
        rm -f "$fisher_file"
        die "无法下载 Fisher"
    fi
    # fisher update reads the tracked fish_plugins file and preserves its list.
    "$fish_bin" -c 'source $argv[1]; fisher update' -- "$fisher_file" </dev/null
    rm -f "$fisher_file"

    log "将 Fish 设置为默认登录 Shell"
    if ! grep -Fqx "$fish_bin" /etc/shells; then
        printf '%s\n' "$fish_bin" | sudo tee -a /etc/shells >/dev/null
    fi
    local current_shell
    current_shell="$(dscl . -read "/Users/$(id -un)" UserShell | awk '{print $2}')"
    if [[ "$current_shell" != "$fish_bin" ]]; then
        sudo chsh -s "$fish_bin" "$(id -un)"
    fi
}

setup_rime() {
    log "安装雾凇拼音并应用粉色明暗主题"
    mkdir -p "$HOME/Library"
    if [[ -d "$RIME_DIR/.git" ]] && [[ "$(git -C "$RIME_DIR" remote get-url origin 2>/dev/null || true)" == "$RIME_ICE_URL" ]]; then
        git -C "$RIME_DIR" pull --ff-only
    else
        if [[ -e "$RIME_DIR" || -L "$RIME_DIR" ]]; then
            backup_path "$RIME_DIR"
        fi
        git clone --depth 1 "$RIME_ICE_URL" "$RIME_DIR"
    fi
    cp "$DOTFILES_DIR/rime/squirrel.custom.yaml" "$RIME_DIR/squirrel.custom.yaml"

    local squirrel_bin="/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel"
    [[ -x "$squirrel_bin" ]] || die "找不到 Squirrel.app；请检查 squirrel-app cask 是否安装成功"
    "$squirrel_bin" --install
    "$squirrel_bin" --enable-input-source im.rime.inputmethod.Squirrel.Hans
    "$squirrel_bin" --select-input-source im.rime.inputmethod.Squirrel.Hans
    "$squirrel_bin" --reload
}

setup_dock() {
    log "配置 Dock：左侧、自动隐藏、平滑显示和隐藏"
    defaults write com.apple.dock orientation -string left
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0.9
    killall Dock >/dev/null 2>&1 || true
}

setup_menu_bar() {
    log "隐藏菜单栏 Spotlight 搜索图标"
    defaults -currentHost write com.apple.controlcenter Spotlight -int 8
    killall ControlCenter >/dev/null 2>&1 || true
}

setup_screenshot_shortcut() {
    log "关闭系统内置的 Command + Shift + 3 全屏截图快捷键"
    # 28: save a full-screen screenshot to a file; leave other shortcuts intact.
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 28 '{ enabled = 0; value = { parameters = (51, 20, 1179648); type = standard; }; }'
    killall SystemUIServer >/dev/null 2>&1 || true
}

setup_finder() {
    log "Finder 显示所有文件扩展名和隐藏文件"
    defaults write -g AppleShowAllExtensions -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true
    killall Finder >/dev/null 2>&1 || true
}

setup_keyboard() {
    log "配置键盘重复、Fn、功能键和 Caps Lock"
    defaults write -g KeyRepeat -int 2
    defaults write -g InitialKeyRepeat -int 15
    defaults write com.apple.HIToolbox AppleFnUsageType -int 1
    defaults write -g com.apple.keyboard.fnState -bool true

    # hidutil mappings disappear after logout, so restore this one at login.
    local mapping='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":30064771129,"HIDKeyboardModifierMappingDst":30064771113}]}'
    local agent="$HOME/Library/LaunchAgents/com.superonee.caps-to-escape.plist"
    mkdir -p "$HOME/Library/LaunchAgents"
    cat > "$agent" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.superonee.caps-to-escape</string>
  <key>ProgramArguments</key><array>
    <string>/usr/bin/hidutil</string><string>property</string><string>--set</string>
    <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":30064771129,"HIDKeyboardModifierMappingDst":30064771113}]}</string>
  </array>
  <key>RunAtLoad</key><true/>
</dict></plist>
PLIST
    plutil -lint "$agent" >/dev/null
    hidutil property --set "$mapping" >/dev/null
    launchctl bootout "gui/$(id -u)" "$agent" >/dev/null 2>&1 || true
    launchctl bootstrap "gui/$(id -u)" "$agent"
}

setup_input_sources() {
    log "只保留 ABC 英文和鼠须管简体中文输入源，默认使用 ABC"
    local helper_dir
    helper_dir="$(mktemp -d -t setup-input-sources.XXXXXX)"
    cat > "$helper_dir/main.c" <<'C'
#include <Carbon/Carbon.h>
#include <stdio.h>

static const CFStringRef abc_id = CFSTR("com.apple.keylayout.ABC");
static const CFStringRef squirrel_id = CFSTR("im.rime.inputmethod.Squirrel.Hans");

static int matches(CFStringRef value, CFStringRef expected) {
    return value && CFStringCompare(value, expected, 0) == kCFCompareEqualTo;
}

int main(void) {
    TISInputSourceRef abc = NULL;
    TISInputSourceRef squirrel = NULL;
    CFArrayRef sources = TISCreateInputSourceList(NULL, true);
    if (!sources) {
        fputs("无法读取 macOS 输入源列表\n", stderr);
        return 1;
    }
    for (CFIndex i = 0; i < CFArrayGetCount(sources); ++i) {
        TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(sources, i);
        CFStringRef id = (CFStringRef)TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
        if (matches(id, abc_id)) abc = source;
        if (matches(id, squirrel_id)) squirrel = source;
    }
    if (!abc || !squirrel || TISEnableInputSource(abc) != noErr ||
        TISEnableInputSource(squirrel) != noErr || TISSelectInputSource(abc) != noErr) {
        fputs("无法启用 ABC 和鼠须管，或无法选中 ABC\n", stderr);
        CFRelease(sources);
        return 1;
    }
    CFRelease(sources);
    return 0;
}
C
    clang -framework Carbon "$helper_dir/main.c" -o "$helper_dir/main"
    "$helper_dir/main"
    rm -f "$helper_dir/main.c" "$helper_dir/main"
    rmdir "$helper_dir"
    # Write this last: TIS can silently drop Squirrel from macOS 27's
    # persisted input menu even while reporting its source as enabled.
    defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
        '{ InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 252; "KeyboardLayout Name" = ABC; }' \
        '{ "Bundle ID" = "im.rime.inputmethod.Squirrel"; "Input Mode" = "im.rime.inputmethod.Squirrel.Hans"; InputSourceKind = "Input Mode"; }' \
        '{ "Bundle ID" = "com.apple.CharacterPaletteIM"; InputSourceKind = "Non Keyboard Input Method"; }' \
        '{ "Bundle ID" = "com.apple.PressAndHold"; InputSourceKind = "Non Keyboard Input Method"; }'
}

setup_omniwm_macos() {
    log "配置桌面点击行为，关闭与 OmniWM 冲突的快捷键和触控板手势"
    # Clicking the wallpaper reveals the desktop only while Stage Manager is on.
    defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
    # Keep one native Space per display. OmniWM requires separate Spaces.
    local old_spans
    old_spans="$(defaults read com.apple.spaces spans-displays 2>/dev/null || true)"
    defaults write com.apple.spaces spans-displays -bool false
    if [[ "$old_spans" != 0 ]]; then
        log "已开启‘显示器使用独立空间’，注销并重新登录后生效"
    fi

    # 32: Mission Control (Control+Up); 79/81: previous/next native Space.
    # Leave Control+Down (App Exposé) and unrelated shortcuts intact.
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 '{ enabled = 0; value = { parameters = (65535, 126, 8650752); type = standard; }; }'
    # 64: Spotlight search (Command+Space).
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '{ enabled = 0; value = { parameters = (32, 49, 1048576); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '{ enabled = 0; value = { parameters = (65535, 123, 8650752); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 '{ enabled = 0; value = { parameters = (65535, 124, 8650752); type = standard; }; }'

    # Disable native vertical Mission Control gestures on built-in and
    # Bluetooth trackpads; OmniWM uses four fingers for Overview.
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 0
    defaults write com.apple.dock mru-spaces -bool false
    killall SystemUIServer >/dev/null 2>&1 || true
}

main() {
    check_platform
    setup_homebrew

    # Git is needed to retrieve the rest of the configuration.
    install_formula git
    setup_dotfiles

    local formula cask
    for formula in node bun go postgresql@18 redis fish cmatrix bat lolcat lazygit starship eza zoxide fzf yazi fd; do
        install_formula "$formula"
    done
    for cask in omniwm google-chrome firefox ghostty mos another-redis-desktop-manager raycast shottr termius telegram chatgpt zed tableplus wpsoffice git-credential-manager squirrel-app font-jetbrains-mono-nerd-font; do
        install_cask "$cask"
    done

    setup_git_credentials
    setup_fish
    "$BREW" services start postgresql@18
    "$BREW" services start redis
    setup_rime
    setup_input_sources
    setup_omniwm_macos
    setup_dock
    setup_menu_bar
    setup_screenshot_shortcut
    setup_finder
    setup_keyboard
    open -a OmniWM

    log "安装完成。重新打开终端即可进入 Fish。OmniWM 已启动，请按 macOS 提示授予辅助功能和输入监控权限。"
}

main "$@"
