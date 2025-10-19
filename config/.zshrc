[[ $- != *i* ]] && return


# --- Colors
autoload -U colors && colors

# --- PATH & env (dedup via zsh path array)
typeset -U path
path=(
    $HOME/.local/bin
    $HOME/.pyenv/bin
    $HOME/gems/bin
    $HOME/.local/share/gem/ruby/3.2.0/bin
    $HOME/.local/share/gem/ruby/3.3.0/bin
    $path
)
export PATH="${(j/:/)path}"
export GEM_HOME="$HOME/gems"
export EDITOR=nvim
export SUDO_EDITOR=nvim
export LANG=en_US.UTF-8
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=24
export LESS='-R'

# --- LS_COLORS
export LS_COLORS="$(vivid generate dracula)"

eval "$(starship init zsh)"

# --- Startup banner
echo
fastfetch --logo apple
echo
quote | colorizer quote green bold
echo

# Pacman hours since full upgrade
last_pac=$(tac /var/log/pacman.log | grep -m1 -F "[PACMAN] starting full system upgrade" | cut -d "[" -f2 | cut -d "]" -f1)
time_since=$(( ( $(date +%s) - $(date --date="$last_pac" +%s) ) / 3600 ))
print -r -- "It has been $(tput bold)$time_since hour$([ $time_since -ne 1 ] && echo s) since last Update" | colorizer green bold
echo

# --- Aliases
alias ls='eza --group-directories-first --icons --git'
alias ll='eza -lha --group-directories-first --icons --git'
alias grep='grep --color=auto'
alias src='clear && source ~/.zshrc'
alias vim='nvim'
alias cls='clear'
alias p='python'
alias dn='cd ~/Downloads/'
alias spotify='spt'
alias weather='curl wttr.in'
alias website='ssh astra@5.161.57.83'
alias batinfo="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E 'percentage|state|time to full'"
alias gplog="git log --graph --decorate --oneline --all"
alias dcr='dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml'

# --- Functions
image() { timg "$1"; }
serve() { python -m http.server "${1:-8000}"; }
update_all() { sudo pacman -Syu; paru -Syu; }
extract() {
    local f="$1"; [[ -z "$f" || ! -f "$f" ]] && { echo "Usage: extract <file>"; return 1; }
    case "$f" in
        *.tar.bz2) tar xjf "$f";;
        *.tar.gz)  tar xzf "$f";;
        *.tar.xz)  tar xJf "$f";;
        *.tar.zst) tar --zstd -xf "$f";;
        *.bz2)     bunzip2 "$f";;
        *.rar)     unrar x "$f";;
        *.gz)      gunzip "$f";;
        *.tar)     tar xf "$f";;
        *.tbz2)    tar xjf "$f";;
        *.tgz)     tar xzf "$f";;
        *.zip)     unzip "$f";;
        *.Z)       uncompress "$f";;
        *.7z)      7z x "$f";;
        *)         echo "Don't know how to extract '$f'"; return 2;;
    esac
}
ports() { sudo lsof -i -P -n | grep LISTEN; }

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

DISABLE_MAGIC_FUNCTIONS="true"
