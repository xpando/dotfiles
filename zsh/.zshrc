# Bail out if not running interactively
[[ $- != *i* ]] && return

##############################################################################
## History
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
# Nix and Home Manager Environment
####################################################################
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" 2>/dev/null; fi

####################################################################
# Path 
####################################################################
export PATH=$PATH:~/.local/bin
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
####################################################################
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
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

# Automatically configure environment when changing into a directory with a .envrc file
if type direnv &>/dev/null; then
  eval "$(asdf exec direnv hook zsh)"
fi

####################################################################
# SDK Man - manage multiple versions of Java, Scala etc.
####################################################################
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$HOME/.sdkman/bin/sdkman-init.sh" 2>/dev/null
fi

###################################################################
# Python
####################################################################
if type pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

if type pipx &>/dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi

if type pipenv &>/dev/null; then
  # Tell pipenv to create virtual environments inside the project directory
  export PIPENV_VENV_IN_PROJECT=1
fi

####################################################################
# Common command replacements
####################################################################

# EXA is a better ls written in rust: https://the.exa.website/
if type exa &>/dev/null; then
  alias ls='exa --git --group-directories-first --group --time-style=long-iso --icons'
  export EXA_ICON_SPACING=2
fi
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# Colorized cat
if type bat &>/dev/null; then
  alias cat='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Git
alias g='git'
alias gfa='g fetch --all'
alias gfp='g fetch --prune --all'
alias grp='g remote prune'

if type onefetch &>/dev/null; then
  alias onefetch='onefetch --no-palette --no-merges --no-bots -A 10'
fi

# httpie - https://httpie.org/
if type http &>/dev/null; then
  alias https='http --default-scheme=https'
fi

# gradle zsh plugin provides this function
# if it is present, alias it to gw
if type gradle-or-gradlew &>/dev/null; then
  alias gw='gradle-or-gradlew'
fi

# AWS CLI
if type aws &>/dev/null; then
  # Localstack
  alias awsl='aws --endpoint-url=http://localhost:4566'
fi

####################################################################
# Common aliases
####################################################################
alias e="$EDITOR"
alias path="tr ':' '\n' <<< \$PATH" # list path elements vertiacally for easier reading
alias lastmod="find . -type f -exec stat --format '%Y :%y %n' \"{}\" \; | sort -nr | cut -d: -f2-"
alias serve="python -m http.server"
alias gwp="gradle properties | grep plugins: | sed 's/^.*\[\(.*\)\]$/\1/' | tr \",\" \"\n\" | xargs -n 1 | sort"
alias qr='qrencode -t ANSI -s 1 -m 1'

function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }

####################################################################
# Platform specific aliases
####################################################################
SYSTEM=$(uname -s)
case "$SYSTEM" in
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
    alias clean-logs='sudo journalctl --rotate && sudo journalctl --vacuum-time=1s'

    # disable Fn mode for F keys for Mac keyboards
    # this is needed when I'm using my Keychron K3 on linux
    alias fkeys='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode >/dev/null'

    # show what ports are open and listening
    function eports() { sudo ss -ntapl | awk '$1=="LISTEN" && $4!~/^(127\.|\[::1\])/' }

    case "$DIST" in
      Arch)
        alias mirrors='reflector --verbose -f 5 -c US -p https'
        alias umirrors='mirrors | sudo tee /etc/pacman.d/mirrorlist'
        alias up='paru -Syyu --noconfirm && paru -Sc --noconfirm && paru -Ps'
        alias pkgs='paru -Qett'
        alias ipkg='paru -Slq | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -S'
        alias upkg='paru -Qett | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -Rc' 
        alias clean-pkgs='paru -c'
        ;;

      Ubuntu)
        ;;

      Fedora)
        ;;
    esac
    ;;

  Darwin)
    # add sbin to path for Homebrew
    export PATH=/usr/local/sbin:$PATH

    alias wezup='brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest'
    alias qrp='pbpaste | qrencode -s 30 -o - | wezterm -n imgcat'

    if type limactl &>/dev/null; then
      alias docker-up='limactl start'
      alias docker-down='limactl stop'
      #alias docker='lima nerdctl'
    fi
    ;;
esac

# load local system configuration if it exists
if [ -f "$HOME/.zsh_local" ]; then
  source "$HOME/.zsh_local"
fi
