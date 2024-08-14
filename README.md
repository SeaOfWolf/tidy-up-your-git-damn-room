# 🧹 Tidy Up Your Git Damn Room

Quick bash script to tidy up branches that have been merged into main. 

The script has some `y/n` checks in there to ensure that you're always aware of what the script is doing and prevent accidental deletions. With this setup, you can run `git-cleanup` (or `git cleanup` if you set up the alias in .gitconfig) from any directory within any of your Git repositories, and it will clean up that specific repository.

---
Place the script in a personal bin directory:

```
~/bin/git-cleanup
```

**Benefits of this approach:**

- It's available for all your projects.
- It's not tied to any specific repository.
- If ~/bin is in your PATH, you can run it from anywhere.

**To set this up:**

1. Create the bin directory if it doesn't exist:

```bash
mkdir -p ~/bin
```

2. Move the script there:

```bash
mv git-cleanup.sh ~/bin/git-cleanup

```

3. Make it executable:

```bash
chmod +x ~/bin/git-cleanup
```

4. Add the bin directory to your PATH if it's not already there. Add this line to your ~/.bashrc or ~/.zshrc:

```bash
export PATH="$HOME/bin:$PATH"
```

5. Reload your shell configuration:

```bash
source ~/.zshrc #or ~/.bashrc#
```

**Make it a Git alias:**
You can also set up the script as a Git alias for even easier use:
Edit your ~/.gitconfig file and add:

```
[alias]
    cleanup = !$HOME/bin/git-cleanup
```

Now you can run it with:

```bash
git cleanup
```

There ya go, automated cleanup, noice! ⚙️🧹
