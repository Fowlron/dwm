#!/bin/sh
git checkout master
git branch | sed '/*/d' | while read -r branch
do
    echo "--------------------------------Rebasing $branch--------------------------------"
    git checkout $branch
    git rebase master
    git checkout master
done
