# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""



# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias ls='ls --color=auto'
alias grep='grep --color=auto'
autoload -U colors && colors
PS1="%{reset_color%}@%{fg[black]%}%~ %{$reset_color%}%% "
eval "$(starship init zsh)"
export LS_COLORS="$(vivid generate snazzy)"
export SUDO_EDITOR="nvim"
export EDITOR=nvim
echo ""
echo ""
# Anarchy, carbs, apple, femboyos, clearOS, darkOS,
fastfetch --logo apple


echo ""
echo ""
quote | colorizer green bold
echo ""
echo ""
last_pac=$(tac /var/log/pacman.log | grep -m1 -F "[PACMAN] starting full system upgrade" | cut -d "[" -f2 | cut -d "]" -f1)
time_since=$((($(date +%s) - $(date --date="$last_pac" +%s)) / 3600))
echo "It has been $(tput bold)$time_since hour$([ $time_since -ne 1 ] && echo s) since last Update" | colorizer green bold
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Alias Definitions
alias src="clear && source ~/.zshrc"
alias vim='nvim'
alias cls='clear'
alias bruteforce='genact -m bruteforce'
alias dcr='dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml'
alias p="python"
alias dn='cd ~/Downloads/'
alias spotify='spt'
alias weather='curl wttr.in'
alias image="timg $1"
alias website="ssh astra@5.161.57.83"
alias bat="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E 'percentage|state|time to full'"


# Export paths
export PATH="$HOME/.pyenv/bin:$PATH"
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=24
export PATH=$PATH:/home/astra/.local/share/gem/ruby/3.2.0/bin
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
export PATH=$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
export CUDA_DIR=/opt/cuda
export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CUDA_DIR/nvvm/libdevice

