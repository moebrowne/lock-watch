#!/bin/bash

pid=($(pgrep -U "$UID" "$(basename -- "$0")"))
pid_count=${#pid[@]}

if [[ ${#pid[@]} -gt "1" ]]; then
  echo "Lock watch is already running"
  exit 1
fi

# Get the source directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Set the script root path
PATH_ROOT="$DIR"

# Set the scripts root path
PATH_SCRIPTS_ROOT="$PATH_ROOT/scripts"

# Pad the passed arguments with spaces for better REGEX detection
args=" $@ "

# Look for the
regexSystemType=' --system (mate|gnome|unity) '
[[ $args =~ $regexSystemType ]]
if [ "${BASH_REMATCH[1]}" != "" ]; then
	SYSTEM_TYPE="${BASH_REMATCH[1]}"
else
	SYSTEM_TYPE="mate"
fi


runLockScripts() {
	run-parts --regex '\.sh$' "$PATH_SCRIPTS_ROOT/lock"
}

runUnlockScripts() {
	run-parts --regex '\.sh$' "$PATH_SCRIPTS_ROOT/unlock"
}

if [[ -z "${DBUS_SESSION_BUS_ADDRESS}" ]]; then
  export $(dbus-launch)
fi

# Start monitoring for the lock and unlock events
while read X; do
	if echo $X | grep "boolean true" &> /dev/null; then
	  runLockScripts;
	elif echo $X | grep "boolean false" &> /dev/null; then
	  runUnlockScripts;
	fi
done < <(dbus-monitor --session "type='signal',interface='org.$SYSTEM_TYPE.ScreenSaver'")