#!/bin/bash
GIT_BIN=/home/ywgx/bin
GIT_DATA=/home/ywgx/data
DATE=$(date +"%Y-%m-%d-%H-%M-%S")
cd $GIT_BIN
git add *
git commit -m "$DATE"
git push -u origin master
cd $GIT_DATA
git add *
git commit -m "$DATE"
git push -u origin master
