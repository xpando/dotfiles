# Bail out if not running interactively
[[ $- != *i* ]] && return

##############################################################################
# Path 
##############################################################################
export PATH=~/.local/bin:~/cargo/bin:$PATH
export LESS=FRX
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
#autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

##############################################################################
# Nix and Home Manager Environment
##############################################################################
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" 2>/dev/null; fi

##############################################################################
# Homebrew package manager (Linux)
##############################################################################
if [ -e "$HOME/.brew/bin/brew" ]; then eval "$($HOME/.brew/bin/brew shellenv)"; fi

##############################################################################
# Privacy
##############################################################################
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SAM_CLI_TELEMETRY=0

##############################################################################
# Wezterm shell integration
##############################################################################
if [ -f "$HOME/.config/wezterm/shell_integration.sh" ]; then
  source "$HOME/.config/wezterm/shell_integration.sh"
fi

##############################################################################
# Prompt https://starship.rs
##############################################################################
if command -v starship &>/dev/null; then
  export STARSHIP_LOG=error
  eval "$(starship init zsh)"
fi

##############################################################################
# JetBrains CLI scripts
##############################################################################
if [ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ]; then
  export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
fi

##############################################################################
# SDK Man - manage multiple versions of JVM based tools
##############################################################################
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$HOME/.sdkman/bin/sdkman-init.sh" 2>/dev/null
  function java_list_cacerts() {
    keytool -list -cacerts -storepass changeit
  }
  function java_trust_aws_rds_cacert() {
    if [ ! -f "$1" ]; then
      echo "Certificate file '$1' not found"
      return 2 # No such file or directory
    fi
    keytool -import -cacerts -storepass changeit -alias awsRdsRootCaCertificate -file $1
  }
fi

##############################################################################
# asdf - manage multiple versions of dev tools
##############################################################################
#if [ -f "$HOME/.asdf/asdf.sh" ]; then
#  autoload -U +X bashcompinit && bashcompinit # asdf requires bash completions :(
#  fpath=($HOME/.asdf/completions $fpath)
#  source "$HOME/.asdf/asdf.sh"
#fi
# mise is a replacement for asdf written in Rust
# see: https://mise.jdx.dev/
if [ -f "$HOME/.local/bin/mise" ]; then
	eval "$($HOME/.local/bin/mise activate zsh)"
fi

##############################################################################
# Python
##############################################################################
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

##############################################################################
# Go
##############################################################################
if command -v go &>/dev/null; then
#  export GOPATH=$HOME/Go
#  export GOBIN=$GOPATH/bin
#  export PATH=$PATH:$GOBIN
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
fi

# EXA is a better ls written in rust: https://the.exa.website/
# if command -v exa &>/dev/null; then
#   alias ls='exa --git --group-directories-first --group --time-style=long-iso --icons'
#   export EXA_ICON_SPACING=2
# fi
# EXA seems to no longer be maintained so I'm using this fork: https://github.com/eza-community/eza
if command -v eza &>/dev/null; then
  alias ls='eza --git --group-directories-first --group --time-style=long-iso --icons'
  export EXA_ICON_SPACING=2
fi
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# Colorized cat
if command -v bat &>/dev/null; then
  alias cat='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# prefer neovim
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
fi

# Git
alias g='git'
alias gfa='g fetch --all'
alias gfp='g fetch --prune --all'
alias grp='g remote prune'

# httpie - https://httpie.org/
if command -v http &>/dev/null; then
  alias https='http --default-scheme=https'
fi

# AWS CLI
if command -v aws &>/dev/null; then
  # AWS CLI with Localstack
  alias awsl='aws --endpoint-url=http://localhost:4566'
  
  # AWS SSO login
  alias aws-login='aws --profile $(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | head -n 1) sso login'

  # Show all AWS related environment variables
  alias awse='env | grep AWS_ | sed -n "s/^\(.*\)=\(.*\)$/\x1b[34m\1\x1b[0m=\x1b[32m\2\x1b[0m/gp" && echo "Caller identity:" && aws sts get-caller-identity | jq'
  
  # Clear AWS related environment variables
  alias awsc='unset `env | grep AWS_ | cut -d'=' -f1 | grep -v "AWS_VAULT_"`'

  # AWS Profile selector function
  function aws_profile_selector() {
    get_profiles='sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | sort'
    if command -v gum &>/dev/null; then
      eval "$get_profiles | gum filter --placeholder='Select profile...' --indicator='👉'"
    elif command -v fzf &>/dev/null; then
      eval "$get_profiles | fzf +m --height 40% --border rounded"
    else
      echo "select_aws_profile requires either gum or fzf."
      return -1
    fi
  }

  if command -v aws_profile_selector &>/dev/null; then
    function awsp() {
      profile=$(aws_profile_selector)
      [ ! -z "$profile" ] && export AWS_PROFILE=$profile
    }
  fi
fi

## Ocaml package manager
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null

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

##############################################################################
# Platform specific aliases
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

case "$SYSTEM" in
  Linux)
    # aliases common to all Linux systems
    alias sdn='sudo shutdown now'
    alias reboot='sudo reboot'
    alias ip='ip -c' # use colored output
    alias docker-up='sudo systemctl start {containerd.service,docker.socket}; systemctl status {containerd.service,docker.socket,docker.service} --no-pager'
    alias docker-down='sudo systemctl stop {docker.service,docker.socket,containerd.service}; sudo ip link delete docker0; systemctl status {docker.service,docker.socket,containerd.service} --no-pager'
    alias kvm-up='sudo systemctl start libvirtd; systemctl status {libvirtd.service,libvirtd-admin.socket,libvirtd-ro.socket,libvirtd.socket} --no-pager'
    alias kvm-down='sudo systemctl stop {libvirtd.service,libvirtd-admin.socket,libvirtd-ro.socket,libvirtd.socket}; systemctl status {libvirtd.service,libvirtd-admin.socket,libvirtd-ro.socket,libvirtd.socket} --no-pager'
    alias vmw-up='sudo systemctl start vmware-networks vmware-networks-configuration vmware-usbarbitrator && sudo systemctl status vmware-networks vmware-networks-configuration vmware-usbarbitrator'
    alias vmw-down='sudo systemctl stop vmware-usbarbitrator vmware-networks-configuration vmware-networks && sudo systemctl status vmware-networks vmware-networks-configuration vmware-usbarbitrator'
    alias clean-logs='sudo journalctl --rotate && sudo journalctl --vacuum-time=1s'

    # Disable Fn mode for F keys for Mac keyboards
    # This is needed when I'm using my Keychron K3 on Linux
    alias fkeys='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode >/dev/null'

    # show what ports are open and listening
    function eports() { sudo ss -ntapl | awk '$1=="LISTEN" && $4!~/^(127\.|\[::1\])/' }

    case "$DIST" in
      Arch)
        alias mirrors='reflector --verbose -f 5 -c US -p https'
        alias umirrors='mirrors | sudo tee /etc/pacman.d/mirrorlist'
        alias up='paru -Syu --noconfirm && paru -Sc --noconfirm && paru -Ps'
        alias pkgs='paru -Qett'
        alias ipkg='paru -Slq | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -S'
        alias upkg='paru -Qett | fzf -m --preview '\''cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}")'\'' | xargs -ro paru -Rc' 
        alias clean-pkgs='paru -c'
        alias wezup='paru -S wezterm-nightly-bin'
        alias restart-autio='systemctl --user restart pipewire.service pipewire-pulse.socket wireplumber.service'
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
    ;;
esac

# load local system configuration if it exists
if [ -f "$HOME/.zsh_local" ]; then
  source "$HOME/.zsh_local"
fi
