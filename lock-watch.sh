#!/bin/bash

# Get the source directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Set the script root path
PATH_ROOT="$DIR"

# Set the scripts root path
PATH_SCRIPTS_ROOT="$PATH_ROOT/scripts"

runLockScripts() {
	run-parts --regex '\.sh$' '$PATH_SCRIPTS_ROOT/lock'
}

runUnlockScripts() {
	run-parts --regex '\.sh$' '$PATH_SCRIPTS_ROOT/unlock'
}

# Start monitoring for the lock and unlock events
dbus-monitor --session "type='signal',interface='org.mate.ScreenSaver'" | \
(
while true; do
	read X;
	if echo $X | grep "boolean true" &> /dev/null; then
	runLockScripts;
	elif echo $X | grep "boolean false" &> /dev/null; then
	runUnlockScripts;
	fi
done
)