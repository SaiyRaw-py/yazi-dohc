#!/bin/bash

# Define directories
DOTFILES_DIR="$HOME/.config/yazi-dohc"
CONFIG_DIR="$HOME/.config"

# Ensure the target config directory exists
mkdir -p "$CONFIG_DIR/yazi"

# Loop through all files in the dotfiles yazi directory
for file in "$DOTFILES_DIR/yazi/"*; do
    # Extract just the filename from the path
    filename=$(basename "$file")
    
    target="$CONFIG_DIR/yazi/$filename"
    
    # Check if a real file already exists there (and isn't a symlink)
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing file: $target to $target.backup"
        mv "$target" "$target.backup"
    fi
    
    # Create the symlink
    # -s: create symbolic link
    # -f: force (overwrite existing symlinks if they exist)
    ln -sf "$file" "$target"
    echo "Symlinked: $filename -> $target"
done

echo "Yazi dotfiles injected successfully!"