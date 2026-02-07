# ~/.zshrc
# Interactive only
[[ $- != *i* ]] && return


# Keybindings

bindkey -e  # emacs bindings

# Ctrl+Right / Ctrl+Left = move by word
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word
bindkey '\e[5C'   forward-word
bindkey '\e[5D'   backward-word
bindkey '\e\e[C'  forward-word
bindkey '\e\e[D'  backward-word

bindkey '\e[3;5~' kill-word
bindkey '^H' backward-kill-word


# Colors + Completion

autoload -U colors && colors
autoload -Uz compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Fast startup; use cached compdump
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump" -C


# PATH & env

export GEM_HOME="$HOME/gems"

typeset -U path
path=(
    "$GEM_HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.pyenv/bin"
    $path
)
export PATH="${(j/:/)path}"

export EDITOR=nvim
export SUDO_EDITOR=nvim
export LANG=en_US.UTF-8
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=24
export LESS='-R'


# LS_COLORS + Prompt

command -v vivid >/dev/null && export LS_COLORS="$(vivid generate dracula)"
command -v starship >/dev/null && eval "$(starship init zsh)"


# History + shell options

HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000

setopt NO_BEEP
setopt COMPLETE_IN_WORD
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# History quality-of-life filters
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

# Navigation QoL
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS


# Startup banner helpers

pacman_days_since_update() {
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/pacman_last_upgrade"
    local now_day ts epoch days line
    
    now_day="$(date +%F)"
    
    # Return cached value for today if present
    if [[ -r "$cache" ]]; then
        local cached_day cached_val
        read -r cached_day cached_val < "$cache"
        if [[ "$cached_day" == "$now_day" ]]; then
            print -r -- "$cached_val"
            return 0
        fi
    fi
    
    line=$(grep -F "[PACMAN] starting full system upgrade" /var/log/pacman.log | tail -n1) || {
        print -r -- "unknown"
        return 1
    }
    
    ts="${line%%]*}"
    ts="${ts#\[}"
    
    epoch=$(date -d "$ts" +%s 2>/dev/null) || epoch=$(date -d "${ts/T/ }" +%s 2>/dev/null) || {
        print -r -- "unknown"
        return 1
    }
    
    days=$(( ( $(date +%s) - epoch ) / 86400 ))
    print -r -- "$days"
    print -r -- "$now_day $days" >| "$cache"
}


# Startup banner

if [[ -t 1 ]]; then
    echo
    command -v fastfetch >/dev/null && fastfetch --logo apple
    echo
    
    if command -v quote >/dev/null && command -v colorizer >/dev/null; then
        quote | colorizer --preset retro_amber
        echo
    fi
    
    time_since=$(pacman_days_since_update 2>/dev/null)
    [[ -z "$time_since" ]] && time_since="unknown"
    
    if [[ "$time_since" == "unknown" ]]; then
        msg="It has been unknown days since last update"
        elif [[ "$time_since" == 1 ]]; then
        msg="It has been 1 day since last update"
    else
        msg="It has been $time_since days since last update"
    fi
    
    if command -v colorizer >/dev/null; then
        print -r -- "$(tput bold)$msg" | colorizer --preset retro_green
        echo
        utime=$(uptime | cut -f1 -d",")
        print -r -- "$utime" | colorizer --preset retro_blue
        echo
    else
        print -r -- "$msg"
    fi
fi


# Aliases

alias ls='eza --group-directories-first --icons=always --git'
alias ll='eza --long --header --group-directories-first --icons=always --git'
alias la='eza --long --all --header --group-directories-first --icons=always --git'
alias lt='eza --tree --level=2 --icons=always'

alias grep='grep --color=auto'
alias src='clear && source ~/.zshrc'
alias vim='nvim'
alias cls='clear'
alias p='python'
alias dn='cd ~/Downloads/'
alias website='ssh astra@5.161.57.83'
alias gplog='git log --graph --decorate --oneline --all'
alias dcr='dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml'
alias school='cd /home/astra/Documents/School-Work'
alias VPN='curl https://am.i.mullvad.net/connected'
alias usb='cd /media/usb'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'


# Functions

ccat() {
    [[ -z "$1" ]] && { echo "Usage: ccat <file>"; return 1; }
    [[ ! -f "$1" ]] && { echo "Error: '$1' not found"; return 1; }
    
    if command -v wl-copy >/dev/null; then
        wl-copy < "$1"
        elif command -v xclip >/dev/null; then
        xclip -selection clipboard < "$1"
    else
        echo "No clipboard tool found (wl-copy or xclip)."
        return 1
    fi
    
    echo "Copied $1 to clipboard."
}

math() {
    [[ -z "$1" ]] && { echo "Usage: math '<expression>'"; return 1; }
    command -v bc >/dev/null || { echo "bc not installed"; return 127; }
    echo "scale=6; $1" | bc -l
}

image() { timg "$1"; }

extract() {
    local f="$1"
    [[ -z "$f" || ! -f "$f" ]] && { echo "Usage: extract <file>"; return 1; }
    
    case "$f" in
        *.tar.bz2) tar xjf -- "$f" ;;
        *.tar.gz)  tar xzf -- "$f" ;;
        *.tar.xz)  tar xJf -- "$f" ;;
        *.tar.zst) tar --zstd -xf -- "$f" ;;
        *.tar)     tar xf -- "$f" ;;
        *.tbz2)    tar xjf -- "$f" ;;
        *.tgz)     tar xzf -- "$f" ;;
        *.bz2)     bunzip2 -- "$f" ;;
        *.gz)      gunzip -- "$f" ;;
        *.zip)     unzip -- "$f" ;;
        *.rar)     unrar x -- "$f" ;;
        *.Z)       uncompress -- "$f" ;;
        *.7z)      7z x -- "$f" ;;
        *)         echo "Don't know how to extract '$f'"; return 2 ;;
    esac
}


# Tool init

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

DISABLE_MAGIC_FUNCTIONS="true"


# opam configuration

[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
