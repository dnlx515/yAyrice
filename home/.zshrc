# Created by newuser for 5.9.2

[ -r "$HOME/.cache/matugen/zsh-colors.zsh" ] && source "$HOME/.cache/matugen/zsh-colors.zsh"
: ${ZSH_USER:=#7D89A6} ${ZSH_HOST:=#B9A49D} ${ZSH_PATH:=#F2EDE4} ${ZSH_ACCENT:=#F2A98C}
PROMPT="%F{${ZSH_USER}}%n%f@%F{${ZSH_HOST}}%m%f %F{${ZSH_PATH}}%~%f %F{${ZSH_ACCENT}}❯%f "

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# ─── Useful Zsh additions ───

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion
autoload -Uz compinit
compinit

# Useful options
setopt INTERACTIVE_COMMENTS
unsetopt BEEP

# Handy aliases
alias c='clear'
alias ll='ls -lah'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Create directory and enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz|*.tgz) tar -xzf "$1" ;;
            *.tar.bz2) tar -xjf "$1" ;;
            *.tar.xz) tar -xJf "$1" ;;
            *.zip) unzip "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "Formato non supportato" ;;
        esac
    else
        echo "File non trovato: $1"
    fi
}
export PATH="$HOME/.npm-global/bin:$PATH"
