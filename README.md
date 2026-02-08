# Lock Watch

Watch for and run scripts when locking and unlocking an Ubuntu desktop


## Install

The `lock-watch.sh` script is a long-running script which needs to be started on
boot. This can be achieved using whatever flavour of system service you prefer.

Under normal circumstances the script should never exit. It also has locks,
preventing multiple instances from running at once.


## Usage

When a lock or unlock event occurs all executable files with a `.sh` suffix in
the `scripts/lock` or `scripts/unlock` directory are run.


## Script Execution Order

The lock/unlock scripts are executed by `run-parts` and the order in which the
execution occurs is lexical sort order of the files names.

If you need to ensure an execution order I would recommenced naming your scripts
like this `00-my-script.sh` and `10-my-second-script.sh`


## System Support

By default this script listens for events from the [MATE](http://mate-desktop.org/)
screen saver to detect the locking and unlocking but it will work for Gnome or Unity
to if you use the `--system mate|gnome|unity` flag
