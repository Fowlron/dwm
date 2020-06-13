#!/bin/sh
git branch | sed '/*/d' | while read -r branch
do
    echo "--------------------------------Merging $branch--------------------------------"
    git merge $branch -m $branch
done
echo "--------------------------------Installing--------------------------------"
sudo make clean install
echo "--------------------------------Cleaning--------------------------------"
make clean && rm -f config.h && git reset --hard origin/master
