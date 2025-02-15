if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Homebrew path
set -Ux PATH /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/local/sbin $PATH

# Path variables
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export PATH="/opt/homebrew/anaconda3/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

# Gretting message
set -U fish_greeting

function fish_greeting
    echo "
       ><(((°>
      Welcome to Fish Shell!
    " | lolcat
end

# Alias
alias vim nvim
alias py python
alias cd z
alias ww "cd ~/Work"
alias oo "cd ~/Code"
alias note "cd ~/Notes"
alias dotn "cd ~/.config/nvim"
alias of "open -a finder ."
alias crypto "go run ~/.config/script/crypto/main.go"
alias ran "go run ~/.config/script/random/main.go"
alias rani "go run ~/.config/script/random_item/main.go"
alias ls "eza --color=always --long --git --icons=always --no-user --no-permissions"

# Fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

set fzf_fd_opts --hidden --max-depth 5

# Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Editor
set -gx EDITOR nvim

# Keybindings
fzf_configure_bindings --directory=\ct

starship init fish | source
zoxide init fish | source
