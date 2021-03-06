#!/bin/bash -e

trap 'killall' INT

killall() {
    trap '' INT TERM
    echo
    echo "shutting down..."
    kill -TERM 0
    wait
    echo "done!"
}

echo "######################################################################################"
echo "# This script will run several commands to watch the source files for changes.       #"
echo "#                                                                                    #"
echo "# This means all tests will automatically run when you make changes and the running  #"
echo "# server will also be automatically updated.                                         #"
echo "#                                                                                    #"
echo "# One downside is all output is currently just spammed onto the same terminal window #"
echo "# and may get a little hard to read.                                                 #"
echo "#                                                                                    #"
echo "# Killing this script will automatically kill all the spawned processes.             #"
echo "######################################################################################"

echo "[1] watching the js for changes..."
npm run watch &

echo "[2] automaitcally running the js tests on changes..."
npm run testing &

echo "[3] automatically running the server tests on changes..."
lein midje :autotest &

echo "[4] running the server..."
lein ring server-headless &

wait

# Proper clean up taken from this unix stackexchange post:
# http://unix.stackexchange.com/questions/55558/how-can-i-kill-and-wait-for-background-processes-to-finish-in-a-shell-script-whe