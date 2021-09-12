# Bail out if not running interactively
[[ $- != *i* ]] && return

##############################################################################
## History Configuration
##############################################################################
HISTSIZE=5000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=15000              # Number of history entries to save to disk
HISTDUP=erase               # Erase duplicates in the history file
setopt    appendhistory     # Append history to the history file (no overwriting)
setopt    sharehistory      # Share history across terminals
setopt    incappendhistory  # Immediately append to the history file, not just when a term is killed

####################################################################
# Key bindings
####################################################################

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[1;5D" beginning-of-line
bindkey "^[[1;5C" end-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

####################################################################
# Path
####################################################################

#export PATH=~/go/bin:$PATH
#export PATH=~/.cargo/bin:$PATH
#export PATH=~/.emacs.d/bin:$PATH
export PATH="$PATH:~/.local/bin"

####################################################################
# Nix package manager
####################################################################
export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH"
source "$HOME/.nix-profile/etc/profile.d/nix.sh"

export LESS=FRX
export EDITOR=vim

# prefer neovim
if type nvim &>/dev/null; then
  export EDITOR=nvim
  alias vim='nvim'
fi

####################################################################
# Privacy
####################################################################
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SAM_CLI_TELEMETRY=0

####################################################################
# ZSH Plugins
# Install: 
# curl -sfL --proto-redir \
#    https https://git.io/antibody \
#    | sh -s - -b /usr/local/bin
####################################################################
if type antibody &>/dev/null; then
  source <(antibody init)
  export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh"
  antibody bundle < ~/.zsh_plugins
fi

####################################################################
# Prompt https://starship.rs
# config in: ~/.config/starship.toml
# Install: 
#   curl -fsSL --proto-redir https https://starship.rs/install.sh | bash
####################################################################
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

####################################################################
# Auto environment config with direnv https://direnv.net/
####################################################################
if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

####################################################################
# Fuzzy find
####################################################################
if [ -n "${commands[fzf-share]}" ]; then
  export FZF_BASE="$(fzf-share)"
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

####################################################################
# Frecent files and directories
# With zsh plugin andrewferrier/fzf-z Ctrl-G will search
# directories and files weighted by frequency and recency of use.
####################################################################
if type fasd &>/dev/null; then
  eval "$(fasd --init auto)"
  export FZFZ_RECENT_DIRS_TOOL=fasd
fi

####################################################################
# Common command replacements
####################################################################

# EXA is a better ls written in rust: https://the.exa.website/
if type exa &>/dev/null; then
  alias ls='exa --git --group-directories-first --group --time-style=long-iso --icons'
fi
alias l='ls -h'
alias la='ls -ah'
alias ll='ls -lh'
alias lla='ls -lah'

# Colorized cat
if type bat &>/dev/null; then
  alias cat='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Git
alias gfa='git fetch --all'
alias gfp='git fetch --prune --all'
alias grp='git remote prune'

# httpie - https://httpie.org/
if type http &>/dev/null; then
  alias https='http --default-scheme=https'
fi

# gradle zsh plugin provides this function
# if it is present, alias it to gw
if type gradle-or-gradlew &>/dev/null; then
  alias gw='gradle-or-gradlew'
fi

####################################################################
# Common aliases
####################################################################
alias e="$EDITOR"
alias path="tr ':' '\n' <<< \$PATH" # list path elements vertiacally for easier reading
alias lastmod="find . -type f -exec stat --format '%Y :%y %n' \"{}\" \; | sort -nr | cut -d: -f2-"
alias gwp="gradle properties | grep plugins: | sed 's/^.*\[\(.*\)\]$/\1/' | tr \",\" \"\n\" | xargs -n 1 | sort"
alias qr='qrencode -t ANSI -s 1 -m 1'
alias wttr='curl wttr.in'
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }

####################################################################
# Platform specific aliases
####################################################################
SYSTEM=$(uname -s)
case "$(uname -s)" in
  Linux)
    DIST=$(lsb_release -a | egrep 'Distributor ID:' | cut -f2)
    ;;
  Darwin)
    DIST=MacOS
    ;;
  *)
    echo "Unknown system: '$SYSTEM'."
esac

case "$SYSTEM" in
  Linux)
    # aliases common to all Linux systems
    alias sdn='sudo shutdown now'
    alias reboot='sudo reboot'
    alias ip='ip -c' # use colored output
    alias docker-up='sudo systemctl start docker'
    alias docker-down='sudo systemctl stop docker && sudo systemctl stop containerd && sudo ip link delete docker0'
    alias vm-up='sudo systemctl start libvirtd && virsh net-start default'
    alias vm-down='sudo systemctl stop libvirtd && virsh net-destroy default'
    alias clean-logs='sudo journalctl --vacuum-time=5d'

    # disable Fn mode for F keys for Mac keyboards
    # this is needed when I'm using my Keychron K3 on linux
    alias fkeys='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode >/dev/null'

    # show what ports are open and listening
    function eports() { sudo ss -ntapl | awk '$1=="LISTEN" && $4!~/^(127\.|\[::1\])/' }

    case "$DIST" in
      Arch)
        alias mirrors='reflector --verbose -f 5 -c US -p https'
        alias umirrors='mirrors | sudo tee /etc/pacman.d/mirrorlist'
        #alias up='paru -Syyu --noconfirm && paru -Sc --noconfirm && paru -Ps'
        alias up='sudo pacman -Syu && paru -Sua'
        alias pkgs='paru -Qett'
        alias ipkg='paru -Slq | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -S'
        alias upkg='paru -Qett | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -Rc' 
        alias clean-pkgs='paru -c'
        . /opt/asdf-vm/asdf.sh # asdf version manager installed with paru -S asdf-vm
        ;;
        # TODO: add aliases specific to other distributions I use such as Fedora, PopOS, Ubuntu
    esac
    ;;

  Darwin)
    # TODO: add Mac specific aliases here
    ;;
esac

