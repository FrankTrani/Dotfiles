[[ $- != *i* ]] && return

#  Keybindings

bindkey -e //emacs bindings

# Ctrl+Right / Ctrl+Left = move by word
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word
bindkey '\e[5C'   forward-word
bindkey '\e[5D'   backward-word
bindkey '\e\e[C'  forward-word
bindkey '\e\e[D'  backward-word

bindkey '\e[3;5~' kill-word
bindkey '^H' backward-kill-word

# --- Colors
autoload -U colors && colors
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


# --- PATH & env
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

# --- History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
# Quality-of-life filters
setopt HIST_IGNORE_SPACE      # commands starting with space aren't saved
setopt HIST_REDUCE_BLANKS     # strip superfluous spaces
setopt HIST_IGNORE_ALL_DUPS   # drop older duplicates when adding a new one
setopt HIST_FIND_NO_DUPS      # no duplicates in history search results
setopt HIST_VERIFY            # show the expanded command before executing


# --- Startup banner
echo
fastfetch --logo apple
echo
quote | colorizer quote green bold
echo

# Pacman hours since full upgrade
last_pac=$(tac /var/log/pacman.log | grep -m1 -F "[PACMAN] starting full system upgrade" | cut -d "[" -f2 | cut -d "]" -f1)
time_since=$((( ( $(date +%s) - $(date --date="$last_pac" +%s) ) / 3600 ) / 24 ))
print -r -- "It has been $(tput bold)$time_since day$([ $time_since -ne 1 ] && echo s) since last Update" | colorizer green bold
echo
utime=$(uptime | cut -f1 -d",")
echo $utime | colorizer blue
echo

# --- Aliases
alias ls='eza --group-directories-first --icons --git'
alias ll='eza -lha --group-directories-first --icons --git'
alias grep='grep --color=auto'
alias src='clear && source ~/.zshenv && source ~/.zshrc'
alias vim='nvim'
alias cls='clear'
alias p='python'
alias dn='cd ~/Downloads/'
alias website='ssh astra@5.161.57.83'
alias gplog="git log --graph --decorate --oneline --all"
alias dcr='dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml'
alias school='cd /home/astra/Documents/School-Work'
alias VPN='curl https://am.i.mullvad.net/connected'
alias usb='cd /media/usb'

# --- Functions
ccat() {
    if [ -z "$1" ]; then
        echo "Usage: ccat <file>"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "Error: '$1' not found"
        return 1
    fi
    
    cat "$1" | wl-copy
    echo "Copied $1 to clipboard."
}

math() {
    if [ -z "$1" ]; then
        echo "Usage: math '<expression>'"
        return 1
    fi
    result=$(echo "scale=4; $1" | bc -l)
    echo "$result"
}


image() { timg "$1"; }
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

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

DISABLE_MAGIC_FUNCTIONS="true"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/astra/.opam/opam-init/init.zsh' ]] || source '/home/astra/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
