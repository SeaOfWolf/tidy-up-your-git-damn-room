#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print_error "Not a git repository!"
    exit 1
fi

print_header "Git cleanup crew are starting up 🧹"

# Change to the root directory of the Git repository
cd "$(git rev-parse --show-toplevel)" || exit 1

# Print current repository information
print_header "Current repository:"
echo "Path: $(pwd)"
echo "Remote origin URL: $(git config --get remote.origin.url)"
echo "Current branch: $(git branch --show-current)"
echo

# Determine default branch
DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
print_header "Default branch detected as: $DEFAULT_BRANCH"

# Update default branch
git checkout "$DEFAULT_BRANCH"
git pull origin "$DEFAULT_BRANCH"

# Fetch from all remotes and prune dead branches
print_header "Fetching and pruning remote branches..."
git fetch --all --prune

# Function to show branch details
show_branch_details() {
    local branch=$1
    local last_commit_date=$(git log -1 --format=%cd --date=relative "$branch" 2>/dev/null)
    local commit_count=$(git rev-list --count "$branch" ^"$DEFAULT_BRANCH" 2>/dev/null || echo "0")
    local author=$(git log -1 --format=%an "$branch" 2>/dev/null)
    echo "Branch: $branch"
    echo "  Last modified: $last_commit_date"
    echo "  Author: $author"
    echo "  Unique commits: $commit_count"
    echo "  Status: $(git log -1 --format=%s "$branch" 2>/dev/null)"
    echo
}

# Categorize branches
print_header "Branch Categories:"

# 1. Merged branches
echo "1. Merged branches (safe to delete):"
merged_branches=$(git branch --merged "$DEFAULT_BRANCH" | grep -v "^\*" | grep -v "$DEFAULT_BRANCH")
if [ -n "$merged_branches" ]; then
    echo "$merged_branches" | while read -r branch; do
        show_branch_details "$branch"
    done
else
    echo "No merged branches found."
fi

# 2. Unmodified review branches (created but never committed to)
echo -e "\n2. Review branches (created but never modified):"
for branch in $(git branch | grep -v "^\*" | grep -v "$DEFAULT_BRANCH"); do
    if [ "$(git rev-list --count "$branch" ^"$DEFAULT_BRANCH")" -eq 0 ]; then
        show_branch_details "$branch"
    fi
done

# 3. Work in progress branches (have unique commits)
echo -e "\n3. Work in progress branches:"
for branch in $(git branch | grep -v "^\*" | grep -v "$DEFAULT_BRANCH"); do
    if [ "$(git rev-list --count "$branch" ^"$DEFAULT_BRANCH")" -gt 0 ]; then
        show_branch_details "$branch"
    fi
done

# Menu for actions
while true; do
    print_header "Cleanup Options:"
    echo "1. Delete merged branches"
    echo "2. Delete review branches (no unique commits)"
    echo "3. Delete specific branches"
    echo "4. Show branch details"
    echo "5. Exit"
    
    read -p "Select an option (1-5): " option
    
    case $option in
        1)
            if [ -n "$merged_branches" ]; then
                echo "$merged_branches"
                read -p "Delete these merged branches? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo "$merged_branches" | xargs -r git branch -d
                    print_success "Merged branches deleted!"
                fi
            else
                print_warning "No merged branches to delete."
            fi
            ;;
        2)
            review_branches=""
            for branch in $(git branch | grep -v "^\*" | grep -v "$DEFAULT_BRANCH"); do
                if [ "$(git rev-list --count "$branch" ^"$DEFAULT_BRANCH")" -eq 0 ]; then
                    review_branches="$review_branches$branch"$'\n'
                fi
            done
            if [ -n "$review_branches" ]; then
                echo "$review_branches"
                read -p "Delete these review branches? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo "$review_branches" | xargs -r git branch -D
                    print_success "Review branches deleted!"
                fi
            else
                print_warning "No review branches to delete."
            fi
            ;;
        3)
            read -p "Enter branch name to delete: " branch_name
            if git branch | grep -q "$branch_name"; then
                show_branch_details "$branch_name"
                read -p "Delete this branch? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    git branch -D "$branch_name"
                    print_success "Branch deleted!"
                fi
            else
                print_error "Branch not found!"
            fi
            ;;
        4)
            read -p "Enter branch name to show details: " branch_name
            if git branch | grep -q "$branch_name"; then
                show_branch_details "$branch_name"
            else
                print_error "Branch not found!"
            fi
            ;;
        5)
            print_success "Cleanup complete! You're now on the $DEFAULT_BRANCH branch."
            exit 0
            ;;
        *)
            print_error "Invalid option!"
            ;;
    esac
done
