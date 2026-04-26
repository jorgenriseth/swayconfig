# function to prepend a directory to PATH if it's not already included
path_prepend() {
  [ -d "$1" ] || return 0

  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

export SKALLASCRIPTS="$HOME/.scripts"
if [ -r "$SKALLASCRIPTS/hosts/$(hostname)" ]; then
  . "$SKALLASCRIPTS/hosts/$(hostname)"
fi
path_prepend "$SKALLASCRIPTS/bin"
path_prepend "$SKALLASCRIPTS/screenlayouts"

# Consider removal as this is PhD-specific and probably not needed,
# unless for the purpose of refining software, which should entail
# more effective use of freesurfer
export FREESURFER_HOME="$HOME/software/freesurfer"

path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.pixi/bin"
if [ -r "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

export PATH

# Source .bashrc in interactive login-shells, running bash.
if [ -n "$BASH_VERSION" ] && [ -r "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
