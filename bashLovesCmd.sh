#!/bin/bash

# Exits from bash back into the bashex wrapper.

# NOTE: At this time there is no obvious way to validate that bashex.bat was the caller of bash
#   as opposed to bash being launched directly from the command line. If the latter was how we got here
#   then we will not achieve the desired output. 
# TODO: Find a method to determine if bash is being wrapped by bashex
echo "bashex default override detected. Are you using bashex?" 

# NOTE: At this time although this script can be called freely, we have not added any steps to
#   that the params passed reference an bashex command. This is no big deal as long as this script is
#   only ever called through alias and if the user's bash_aliases file has been set up correctly.
# TODO: Check if this function is one of the bashLovesCmd aliased executables

# current working directory is inherritted (not the location of the script)
# so we can freely parse pwd as the location to transition to on exit.
# parse the root '/' from the string meaning the number of interations is how many dirs
# up from root we are
# NOTE: Windows bash has C Drive @ /mnt/c/ of the bash structure
path=${PWD:1}

# loop over the working directory and after the first 2 dirs (mnt + c) begin appending to the C Drive location
cPath="C:";
depth=0
# http://stackoverflow.com/a/918931
while IFS='/' read -ra ADDR; do
    for i in "${ADDR[@]}"; do
        # process "$i"
        # increment depth counter
        depth=$((depth+1));
        # if at depth 3 or greater append to cPath
        if [ "$depth" -ge 3 ]; then
            cPath="$cPath\\$i"
        fi
    done
done <<< "$path"
# if we never appended a path force the addition of the root of cDrive 
if [ "$depth" -lt 3 ]; then
    cPath="$cPath\\"
fi

# if the file exists and if we cannot write to it then we need to sudo rm it.
# else it will be overwritten/created tomorrow
# note: this will only occurr if bashex wrapper did not properly prime with the deletion of this file.
filename="cmdQueue.temp"
queueFile="/mnt/c/CmdLovesBash/$filename"
if test -e $queueFile ; then
    if [ ! -w $queueFile ] ; then
        echo "Oops: A current version of the cmdQueue exists and cannot be overwritten. Your permission is required to continue."
        sudo rm $queueFile;
    fi
fi

# Create/Overwrite with the dir to cd to on exit
echo "$cPath" > "$queueFile"
# Add the command that needs to be execute by cmd prompt before returning
# alias adds the original alias name back in as the first arg ($0 points to this) meaning
# all args of this is the full cmd to be executed by cmd prompt.
echo $* >> "$queueFile"

# kills the bash process and falls back to the bash cmd wrapper.
kill -9 $PPID