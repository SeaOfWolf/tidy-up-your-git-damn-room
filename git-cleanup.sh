#!/bin/bash

echo "Git cleanup crew are starting up 🧹"

# Change to the root directory of the Git repository
cd "$(git rev-parse --show-toplevel)" || exit 1

# Print current repository information
echo "Current repository:"
echo "Path: $(pwd)"
echo "Remote origin URL: $(git config --get remote.origin.url)"
echo ""

# Ask for confirmation
read -p "Is this the correct repository? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancelled."
    exit 1
fi

# Update main branch
git checkout main
git pull origin main

# Fetch from all remotes and prune dead branches
git fetch --all --prune

# List branches to be deleted
echo "The following local branches will be deleted:"
git branch --merged main | grep -v "^\*"

# Ask for confirmation before deleting
read -p "Do you want to proceed with deletion? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Delete local branches that have been merged into main
    git branch --merged main | grep -v "^\*" | xargs -n 1 git branch -d
else
    echo "Branch deletion cancelled."
fi

# List remaining branches
echo "Remaining branches:"
git branch -a

echo "Cleanup complete. You're now on the main branch."
echo "To delete unmerged branches, use: git branch -D branch-name"
