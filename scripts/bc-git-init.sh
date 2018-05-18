#!/bin/bash

printf "Provide git remote path (eg. git@github.com:BetterCollective/wordpress-guidedupari-com.git): "; read git_remote

echo -n "Do you have Github permissions to read/write from the desired repository (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    cd wordpress
    git init .
    git remote add origin $git_remote
    git fetch --all
    git reset --hard origin/staging
    git checkout staging
    echo "Git has been initiated on the repository. Go to ./wordpress/ to develop."
else
    echo "Contact DevOps or IT to get the desired Github access."
fi
