#!/bin/bash

runLockScripts() {
	echo "Screen Locked"
}

runUnlockScripts() {
	echo "Screen Unlocked"
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