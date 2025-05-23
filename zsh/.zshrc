# Bail out if not running interactively
[[ $- != *i* ]] && return

# Ghostty terminal emulator integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

##############################################################################
# Path 
##############################################################################
export PATH=~/.local/bin:$PATH
export LESS=-FRXij5
export EDITOR=vim

##############################################################################
## History
##############################################################################
HISTFILE=~/.zsh_history          # Where to save history to disk
HISTSIZE=15000                   # How many lines of history to keep in memory
SAVEHIST=1000000000              # Number of history entries to save to disk
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

##############################################################################
## Ergonomics
##############################################################################
setopt NO_BEEP # beeping is annoying
setopt autocd nomatch
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

##############################################################################
# Plugins
##############################################################################
# Download Znap, if it's not there yet.
export ZNAP_ROOT="$HOME/.local/share/zsh/plugins/zsh-snap"
[[ -f "$ZNAP_ROOT/znap.zsh" ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git "$ZNAP_ROOT"

# Start Znap
source "$ZNAP_ROOT/znap.zsh"

znap source softmoth/zsh-vim-mode
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-syntax-highlighting
znap source joshskidmore/zsh-fzf-history-search

##############################################################################
# Completions
# See: https://superuser.com/questions/1092033/how-can-i-make-zsh-tab-completion-fix-capitalization-errors-for-directories-and
##############################################################################
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit && compinit

##############################################################################
# Nix and Home Manager Environment
##############################################################################
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" 2>/dev/null; fi

##############################################################################
# Homebrew package manager
##############################################################################
if [ -e "/opt/homebrew/bin/brew" ]; then 
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then 
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

##############################################################################
# Homebrew package manager local user installation. Typically manual install
# on Linux distros where homebrew is not in the package manager
##############################################################################
if [ -e "$HOME/.brew/bin/brew" ]; then 
  eval "$($HOME/.brew/bin/brew shellenv)"
fi

##############################################################################
# Atuin shell history
##############################################################################
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

##############################################################################
# Privacy
##############################################################################
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SAM_CLI_TELEMETRY=0

##############################################################################
# JetBrains CLI scripts
##############################################################################
if [ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ]; then
  export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
fi
function ijhttp() {
  docker run --rm -it -v $PWD:/workdir jetbrains/intellij-http-client $@
}

##############################################################################
# add cargo bin to the path if it exists so that tools installed via cargo
# can be found
##############################################################################
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# mise is a replacement for asdf written in Rust
# see: https://mise.jdx.dev/
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh --shims)"
  # eval "$(mise activate zsh)"
fi

##############################################################################
# Python
##############################################################################
export VIRTUAL_ENV_DISABLE_PROMPT=1 # venv prompt is handled by starship prompt

if command -v uv &>/dev/null; then
  eval "$(uv --generate-shell-completion zsh)"
fi

if command -v uvx &>/dev/null; then
  eval "$(uvx --generate-shell-completion zsh)"
fi

if [ -f "$HOME/miniconda3/bin/conda" ]; then
  eval "$(~/miniconda3/bin/conda shell.zsh hook)"
fi

if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

if command -v pipx &>/dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi

if command -v pipenv &>/dev/null; then
  # Tell pipenv to create virtual environments inside the project directory
  export PIPENV_VENV_IN_PROJECT=1
fi

if command -v poetry &>/dev/null; then
  export POETRY_VIRTUALENVS_IN_PROJECT=true
fi

if command -v marimo &>/dev/null; then
  eval "$(_MARIMO_COMPLETE=zsh_source marimo)"
fi

##############################################################################
# Go
##############################################################################
if command -v go &>/dev/null; then
#  export GOPATH=$HOME/Go
#  export GOBIN=$GOPATH/bin
#  export PATH=$PATH:$GOBIN
fi

##############################################################################
# LM Studio
##############################################################################
if [ -d "$HOME/.lmstudio/bin" ]; then
  export PATH="$PATH:$HOME/.lmstudio/bin"
fi

if command -v jj &>/dev/null; then
  # source <(jj util completion zsh)
  source <(COMPLETE=zsh jj)
fi

##############################################################################
# Common command replacements and aliases
##############################################################################

##############################################################################
# Changing/making/removing directory
##############################################################################
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d

##############################################################################
# Zoxide - a smarter cd command, inspired by z and autojump
# https://github.com/ajeetdsouza/zoxide
##############################################################################
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd=z
fi

# EZA is a better ls: https://github.com/eza-community/eza
if command -v eza &>/dev/null; then
  alias ls='eza --git --group-directories-first --group --time-style=long-iso --icons'
  export EXA_ICON_SPACING=2
  # export EXA_COLORS='di=38;5;25:da=38;5;59'
fi
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# Colorized cat
if command -v bat &>/dev/null; then
  alias cat='bat -p'
  export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'"
fi

# prefer neovim
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
fi

# httpie - https://httpie.org/
if command -v http &>/dev/null; then
  alias https='http --default-scheme=https'
fi

##############################################################################
# AWS CLI helper functions and aliases
##############################################################################

# Run AWS CLI commands with Localstack
alias awsl='aws --endpoint-url=http://localhost:4566'

# Show all AWS related environment variables and test authentication
function awse() {
  env | grep AWS_ | sed -n "s/^\(.*\)=\(.*\)$/\x1b[34m\1\x1b[0m=\x1b[32m\2\x1b[0m/gp" 
  echo "Caller identity:" && aws sts get-caller-identity | jq
}

# Clear AWS related environment variables
alias awsc='unset `env | grep AWS_ | cut -d'=' -f1 | grep -v "AWS_VAULT_"`'

# AWS SSO session selector function
function aws_sso_session_selector() {
  sessions=$(sed -n "s/\[sso-session \(.*\)\]/\1/gp" ~/.aws/config | sort)

  if command -v gum &>/dev/null; then
    echo $sessions | gum filter --placeholder='Select session...' --select-if-one --indicator='👉'
    return 0
  fi

  if command -v fzf &>/dev/null; then
    echo $sessions | fzf -1 +m --height 40% --border rounded
    return 0
  fi

  echo "aws_sso_session_selector requires either gum or fzf."
  return -1
}

# AWS Profile selector function
function aws_profile_selector() {
  profiles=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | sort)

  if command -v gum &>/dev/null; then
    echo $profiles | gum filter --placeholder='Select profile...' --select-if-one --indicator='👉'
    return 0
  fi

  if command -v fzf &>/dev/null; then
    echo $profiles | fzf -1 +m --height 40% --border rounded
    return 0
  fi

  echo "aws_profile_selector requires either gum or fzf."
  return -1
}

# Activate AWS profile
function awsp() {
  profile=$(aws_profile_selector)
  [ ! -z "$profile" ] && export AWS_PROFILE=$profile
}

# Authenticate using AWS SSO session
function awsso() {
  session=$(aws_sso_session_selector)
  [ ! -z "$session" ] && aws sso login --sso-session $session
}

##############################################################################
# Direnv
##############################################################################
if command -v direnv &>/dev/null; then
  export DIRENV_LOG_FORMAT=
  eval "$(direnv hook zsh)"
fi

##############################################################################
# Prompt https://starship.rs
##############################################################################
#if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]]; then
  if command -v starship &>/dev/null; then
    export STARSHIP_LOG=error
    eval "$(starship init zsh)"
  fi
#fi

##############################################################################
# Prompt https://ohmyposh.dev
##############################################################################
#if [[ ! "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]]; then
#  if command -v oh-my-posh &>/dev/null; then
#    eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/dave.yaml)"
#  fi
#fi

##############################################################################
#  Detect platform
##############################################################################
SYSTEM=$(uname -s)
case "$SYSTEM" in
  Linux)
    DIST=$(lsb_release -i | grep -E 'Distributor ID:' | cut -f2)
    ;;
  Darwin)
    DIST=MacOS
    ;;
  *)
    echo "Unknown system: '$SYSTEM'."
esac

##############################################################################
# Common aliases
##############################################################################
alias e="$EDITOR"
alias path="tr ':' '\n' <<< \$PATH" # list path elements vertiacally for easier reading
alias lastmod="find . -type f -exec stat --format '%Y :%y %n' \"{}\" \; | sort -nr | cut -d: -f2-"
alias serve="python -m http.server"
alias gwp="gradle properties | grep plugins: | sed 's/^.*\[\(.*\)\]$/\1/' | tr \",\" \"\n\" | xargs -n 1 | sort"
alias qr='qrencode -t ANSI -s 1 -m 1'
alias emoji-test='curl https://unicode.org/Public/emoji/11.0/emoji-test.txt | less -S'

function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }

# AWS Vault
if command -v aws-vault &>/dev/null; then
  declare -A PROMPTS
  PROMPTS[Linux]="zenity"
  PROMPTS[Darwin]="osascript"
  export AWS_VAULT_PROMPT=$prompts[$SYSTEM]
  eval "$(aws-vault --completion-script-zsh)"
  if command -v aws_profile_selector &>/dev/null; then
    function awsv() {
      profile=$(aws_profile_selector)
      [ ! -z "$profile" ] && aws-vault exec $profile -- ${@:-zsh}
    }
    function awsvs() {
      profile=$(aws_profile_selector)
      [ ! -z "$profile" ] && aws-vault exec --ec2-server $profile -- ${@:-zsh}
    }
  fi
fi

# Nix Home Manager
if command -v home-manager &>/dev/null; then
  alias hm='home-manager'
  alias hmu='nix flake update ~/.config/home-manager'
  alias hms='home-manager switch --flake ~/.config/home-manager'
  alias hme='"$EDITOR" ~/.config/home-manager/home.nix'
  alias hmgc='nix-env --profile home-manager --delete-generations +5'
  alias nxgc='nix-store --gc && nix-collect-garbage -d'
fi

case "$SYSTEM" in
  Linux)
    # Set default libvirt mode to 'system'
    # don't forget to:
    # sudo usermod -aG libvirt "$USER"
    export LIBVIRT_DEFAULT_URI='qemu:///system'

    # aliases common to all Linux systems
    alias sdn='sudo shutdown now'
    alias reboot='sudo reboot'
    alias ip='ip -c' # use colored output
    alias docker-up='sudo systemctl start {containerd.service,docker.socket}; systemctl status {containerd.service,docker.socket,docker.service} --no-pager'
    alias docker-down='sudo systemctl stop {docker.service,docker.socket,containerd.service}; sudo ip link delete docker0; systemctl status {docker.service,docker.socket,containerd.service} --no-pager'
    #alias kvm-up='sudo systemctl start libvirtd; systemctl status {libvirtd.service,libvirtd-admin.socket,libvirtd-ro.socket,libvirtd.socket} --no-pager'
    #alias kvm-down='sudo systemctl stop {libvirtd.service,libvirtd-admin.socket,libvirtd-ro.socket,libvirtd.socket}; systemctl status {libvirtd.service,libvirtd-admin.socket,libvirtd-ro.socket,libvirtd.socket} --no-pager'
    alias clean-logs='sudo journalctl --rotate && sudo journalctl --vacuum-time=1d'

    function clean-docker-images() {
        docker image ls -n | grep '^localhost/' | tr -s ' ' ' ' | cut -d' ' -f3 | xargs docker image rm -f
    }

    # Disable Fn mode for F keys for Mac keyboards
    # This is needed when I'm using my Keychron K3 on Linux
    alias fkeys='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode >/dev/null'

    # show what ports are open and listening
    function eports() { sudo ss -ntapl | awk '$1=="LISTEN" && $4!~/^(127\.|\[::1\])/' }

    alias lld='lsblk -o NAME,FSTYPE,PARTLABEL,LABEL,MOUNTPOINT,FSUSE%'
    alias vc-list='sudo veracrypt --text -l'
    alias vc-mount='sudo veracrypt --text --pim 0 --keyfiles "" --protect-hidden no --mount'
    alias vc-umount='sudo veracrypt --text -d'

    function kvm-status() {
      systemctl --state=running --no-legend --no-pager | grep 'virt'
    }

    function kvm-up() {
      for drv in qemu interface network nodedev nwfilter secret storage; do
        sudo systemctl start virt${drv}d.service
        sudo systemctl start virt${drv}d{,-ro,-admin}.socket
      done
    }

    function kvm-down() {
      for drv in qemu interface network nodedev nwfilter secret storage; do
        sudo systemctl stop virt${drv}d.service
        sudo systemctl stop virt${drv}d{,-ro,-admin}.socket 
      done	
    }

    # Open IntelliJ IDEA and detach from terminal
    if command -v idea-ultimate &>/dev/null; then
      function idea() {
        nohup idea-ultimate "$@" &>/dev/null &!
      }
    fi

    function it-tools-up() {
      docker run --name it-tools -d --rm -p 8180:80 ghcr.io/corentinth/it-tools:latest
      xdg-open http://localhost:8180
    }
    alias it-tools-down='docker stop it-tools'
    alias it-tools-update='docker pull ghcr.io/corentinth/it-tools:latest'

     function xdraw-up() {
      docker run --name xdraw -d --rm -p "8280:80" excalidraw/excalidraw:latest
      xdg-open http://localhost:8280
    }
    alias xdraw-down='docker stop xdraw'
    alias xdraw-update='docker pull excalidraw/excalidraw:latest'

    case "$DIST" in

      Arch)
        alias mirrors='reflector --verbose -f 5 -c US -p https'
        alias umirrors='mirrors | sudo tee /etc/pacman.d/mirrorlist'
        alias up='paru -Syu --noconfirm && paru -Sc --noconfirm && paru -Ps'
        alias pkgs='paru -Qett'
        alias ipkg='paru -Slq | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -S'
        alias upkg='paru -Qett | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -Rc' 
        alias clean-pkgs='paru -c'
        alias restart-audio='systemctl --user restart pipewire.service pipewire-pulse.socket wireplumber.service'
        ;;


      Fedora)
        alias checkupdates='dnf check-update'
        alias up='sudo dnf update -y'

        if [[ -f /opt/intellij-idea/bin/idea.sh ]]; then
          function idea() {
            nohup /opt/intellij-idea/bin/idea.sh "$@" &>/dev/null &!
          }
        fi
        ;;

      openSUSE)
        alias zp='zypper'
        alias szp='sudo zypper'
        ;;
    
    esac
    ;;

  Darwin)
    # add sbin to path for Homebrew
    export PATH=/usr/local/sbin:$PATH

    alias myip='ipconfig getifaddr en0'
    alias eports='lsof -i -P | grep LISTEN'

    # Resolve k8s names via telepresence
    # workaround for netty and CLI utils that don't support more than one resolver
    function tp-service() {
      dscacheutil -q host -a name "$1.services" | grep ip_address: | cut -d ' ' -f 2
    }

    function it-tools-up() {
      docker run --name it-tools -d --rm -p 8180:80 ghcr.io/corentinth/it-tools:latest
      open http://localhost:8180
    }
    alias it-tools-down='docker stop it-tools'
    alias it-tools-update='docker pull ghcr.io/corentinth/it-tools:latest'

     function xdraw-up() {
      docker run --name xdraw -d --rm -p "8280:80" excalidraw/excalidraw:latest
      open http://localhost:8280
    }
    alias xdraw-down='docker stop xdraw'
    alias xdraw-update='docker pull excalidraw/excalidraw:latest'

   ;;
esac

# load local system configuration if it exists
if [ -f "$HOME/.zsh_local" ]; then
  source "$HOME/.zsh_local"
fi
