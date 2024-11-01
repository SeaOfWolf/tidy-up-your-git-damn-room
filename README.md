# 🧹 Tidy Up Your Git Damn Room

A simple bash script for managing and cleaning up Git branches. This tool was created just to help me maintain a clean repository by categorizing and managing different types of branches:

- ✅ Merged branches that are safe to delete
- 👀 Review branches that were created but never modified
- 🚧 Work in progress branches with unique commits

## Features

- 🎨 Color-coded output for better visibility
- 🔍 Automatic detection of default branch (main/master)
- 📊 Branch statistics and information
- ⚠️ Safety checks to prevent accidental deletions
- 🗑️ Interactive menu for different cleanup options
- 🔄 Repository optimization with git gc

### Branch Information Displayed

For each branch, you'll see:
- Last modification date
- Author
- Number of unique commits
- Latest commit message
- Branch status (merged/review/WIP)

## Installation

### 1. Set Up Local Binary

Place the script in your personal bin directory:

```bash
# Create bin directory if it doesn't exist
mkdir -p ~/bin

# Move the script
mv git-cleanup.sh ~/bin/git-cleanup

# Make it executable
chmod +x ~/bin/git-cleanup

# Add to PATH (if not already there)
# Add to ~/.bashrc or ~/.zshrc:
export PATH="$HOME/bin:$PATH"

# Reload shell configuration
source ~/.zshrc  # or ~/.bashrc
```

### 2. Git Alias Setup (Optional)

Edit your `~/.gitconfig` file and add:

```ini
[alias]
    cleanup = !$HOME/bin/git-cleanup
```

## Usage

Run the script from any directory in your Git repository:
```bash
git cleanup
# or
git-cleanup
```

### Interactive Menu Options

1. **Delete Merged Branches**
   - Lists and safely removes branches that have been merged into the default branch

2. **Delete Review Branches**
   - Identifies and removes branches created for review but never modified
   - Useful for cleaning up after code reviews or explorations

3. **Delete Specific Branches**
   - Select individual branches for removal
   - Shows detailed branch information before deletion

4. **Show Branch Details**
   - Display comprehensive information about any branch
   - Helps make informed decisions about branch management

5. **Exit**
   - Safely exit the cleanup process

## Safety Features

- ✋ Confirmation prompts before any deletion
- 🔒 Checks for uncommitted changes
- 🎯 Different deletion commands for merged (-d) vs unmerged (-D) branches
- 📝 Detailed branch information before any action
- 🔄 Automatic backup of current work

## Example Output

```
Git cleanup crew are starting up 🧹

Current repository:
Path: /your/repo/path
Remote origin URL: git@github.com:username/repo.git
Current branch: main

Branch Categories:
1. Merged branches (safe to delete):
Branch: feature/completed-work
  Last modified: 2 days ago
  Author: John Doe
  Unique commits: 0
  Status: Merge completed feature

2. Review branches (created but never modified):
Branch: review/potential-change
  Last modified: 5 days ago
  Author: Jane Smith
  Unique commits: 0
  Status: Initial commit

3. Work in progress branches:
Branch: feature/active-development
  Last modified: 1 hour ago
  Author: John Doe
  Unique commits: 3
  Status: WIP: Adding new feature
```

## Benefits

- 🌟 Available for all your projects
- 🔄 Not tied to any specific repository
- 📍 Run from anywhere when in PATH
- 🎯 Precise control over branch management
- 📊 Better visibility of repository state

## Requirements

- Git
- Bash shell
- Standard Unix utilities (du, grep, etc.)

There ya go, automated cleanup done! ⚙️🧹

## Contributing

Feel free to submit issues and enhancement requests!

---

*Note: This script is designed with safety in mind, but always ensure your work is committed or stashed before running cleanup operations.*
