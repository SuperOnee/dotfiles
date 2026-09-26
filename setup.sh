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
        "$BREW" install "$name"
    fi
}

install_cask() {
    local name="$1"
    if "$BREW" list --cask "$name" >/dev/null 2>&1; then
        log "已安装 cask: $name"
    else
        log "安装 cask: $name"
        "$BREW" install --cask "$name"
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
    for cask in omniwm google-chrome firefox ghostty mos another-redis-desktop-manager raycast termius spotify chatgpt zed tableplus wechat wpsoffice-cn git-credential-manager squirrel-app font-jetbrains-mono-nerd-font; do
        install_cask "$cask"
    done

    setup_git_credentials
    setup_fish
    "$BREW" services start postgresql@18
    "$BREW" services start redis
    setup_rime

    log "安装完成。重新打开终端即可进入 Fish。首次运行 OmniWM、Mos 等应用时，请按 macOS 提示授予所需权限。"
}

main "$@"
