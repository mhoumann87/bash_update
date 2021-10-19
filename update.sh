#!/bin/bash

# Update is a command line tool made to make it easy for me to update my
# Ubuntu based Linux system
# Based on Joe Collins script Up - https://github.com/EzeeLinux/up-debian_ubuntu_update_tool
# By Michael Houmann 

# Set bash to quit script and exit on errors
set -e

# Functions

update() {
  echo "Starting full system update"
  sudo apt update
  sudo apt full-upgrade -yy
}

clean() {
  echo "Removing apt cache packages that can no longer be downloaded"
  sudo apt autoclean
}

remove() {
  echo "Removing no longer in use packages"
  sudo apt autoremove -yy
  sudo apt remove --purge $(dpkg -l | grep "^rc" | awk '{print $2}') -yy
}

leave() {
  echo "==================="
  echo "= Update Complete ="
  echo "==================="
  exit
}

update_help() {
  less << _EOF_

  Update - toole to clean and update Ubuntu based Linux system version 1.0

  Press "q" to exit this help page.

  Commands:

    * update = Full system update.

    Running "update" with no options will update the apt cache and then\
    preform a full distribution update automatically.

    * up --remove = Full system update with useless packages removed.
    * up --clean = Full system update with full system cleanup.

    Adding the "--clean" flag will invoke the apt command to search for\
    and remove locally cached packages that are no longer in the repos\
    and remove orphaned packages that are no longer needed by programs.

    The "--remove" flag will only remove orphaned packages, leaving the\
    apt cache alone.

    * up --help = shows this help page.

_EOF_
}

# Execution

echo "Update - Update and clean your Linux System (Version 1)"

# Update and clean

if [ "$1" == "--remove" ]; then
  update
  remove
  leave
fi

# update and clean

if [ "$1" == "--clean" ]; then
  update
  remove
  clean
  leave
fi

# Help

if [ "$1" == "--help" ]; then
  update_help
  exit
fi

# Check for invalid argument

if [ -n "$1" ]; then
  echo "Invalid argument. Try 'update --help' for more info.">&2
  exit 1
fi

# Update

update
leave
