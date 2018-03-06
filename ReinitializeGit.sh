#!/bin/bash

[ "$#" -eq 2 ] \
  || { echo -e "Invalid number of arguments!\nInput should be like\nReinitializeGit.sh <Project-Directory> <SSH-Cloning-Link>"; exit 1; }

[ -d "$1" ] \
  || { echo -e "First argument must be the directory you want to reinitialize"; exit 1; } 

rm -rf .git \
  && git -C "$1" init \
  && git -C "$1" remote add origin "$2"
  || { echo -e "Error occurred while connecting git... Exiting :("; exit 1; }

git -C "$1" remote -v \
 && git -C "$1" add --all \
 && git -C "$1" commit -am "Reinitialization commit" \
 && git -C "$1" push --force --set-upstream origin master \
 || { echo -e "Err.. Exiting :("; exit 1; }
