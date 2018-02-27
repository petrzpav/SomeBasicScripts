#!/bin/bash
if [ "$#" -ne 2 ]
  then
    echo -e "Invalid number of arguments!\nInput should be like\nReinitializeGit.sh <Project-Directory> <SSH-Cloning-Link>"
    exit 1
  elif [ ! -d "$1" ]
    then
      echo -e "First argument must be the directory you want to reinitialize"
      exit 1
  else
    cd "$1"
    rm -rf .git
    git init
    git remote add origin "$2"
    if [ "$?" -ne 0 ]
      then
        echo -e "Error occurred while connecting git... Exiting :("
        exit 1
      else
        git remote -v
        git add --all
        git commit -am "Reinitialization commit"
        git push --force --set-upstream origin master
      fi
  fi
