# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

#Extend path with custom scripts
export SKALLASCRIPTS=$HOME/.scripts
source $SKALLASCRIPTS/hosts/$(hostname)
PATH=$SKALLASCRIPTS/bin:$SKALLASCRIPTS/screenlayouts:$HOME/.local/bin:$PATH

export FREESURFER_HOME=$HOME/software/freesurfer

# Add texlive installation path
PATH=/home/jorgen/programs/texlive/2025/bin/x86_64-linux:$PATH

. "$HOME/.cargo/env"
#
# Force apps to use Wayland natively
# export MOZ_ENABLE_WAYLAND=1
# export QT_QPA_PLATFORM="wayland;xcb"
# export GDK_BACKEND="wayland,x11"
# export SDL_VIDEODRIVER="wayland"
# export XDG_SESSION_TYPE="wayland"
