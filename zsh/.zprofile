export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Fix rendering issues for Java applications
#export _JAVA_AWT_WM_NONREPARENTING=1

# Turn off debug logging for things like albert
export QT_LOGGING_RULES="*.debug=false;*.info=false"

#export GBM_BACKEND=nvidia-drm
#export __GLX_VENDOR_LIBRARY_NAME=nvidia

#if command -v mise &>/dev/null; then
#  eval "$(mise activate zsh)"
#fi

export MOZ_ENABLE_WAYLAND=1
