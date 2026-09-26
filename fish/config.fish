set -g fish_features no-query-term

# Homebrew, PostgreSQL 18, local tools and Go binaries.
if test -x /opt/homebrew/bin/brew
    fish_add_path -g /opt/homebrew/bin /opt/homebrew/sbin /opt/homebrew/opt/postgresql@18/bin
else if test -x /usr/local/bin/brew
    fish_add_path -g /usr/local/bin /usr/local/sbin /usr/local/opt/postgresql@18/bin
end
fish_add_path -g $HOME/.local/bin $HOME/go/bin
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR zed

if test -f $HOME/.config/fish/.env
    source $HOME/.config/fish/.env
end

function fish_greeting
    if command -q lolcat
        printf '\n       ><(((°>\n      Welcome to Fish Shell!\n\n' | lolcat
    end
end

alias ww 'cd ~/Work'
alias oo 'cd ~/Code'
alias note 'cd ~/Notes'
alias of 'open -a Finder .'
alias crypto 'go run ~/.config/script/crypto/main.go'
alias ran 'go run ~/.config/script/random/main.go'
alias rani 'go run ~/.config/script/random_item/main.go'
alias ls 'eza --color=always --long --git --icons=always --no-user --no-permissions'

function y
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file=$tmp
    if set -l cwd (command cat -- $tmp); and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- $cwd
    end
    rm -f -- $tmp
end

if status is-interactive
    set -gx FZF_DEFAULT_OPTS '--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a --multi'
    set -g fzf_fd_opts --hidden --max-depth 5

    if functions -q fzf_configure_bindings
        fzf_configure_bindings --directory=\ct
    end
    if command -q starship
        starship init fish | source
    end
    if command -q zoxide
        zoxide init fish | source
        alias cd z
    end
end
