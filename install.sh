#!/bin/bash

# Define directories
DOTFILES_DIR="$HOME/.config/yazi-dohc"
CONFIG_DIR="$HOME/.config"

# Ensure the target config directory exists
mkdir -p "$CONFIG_DIR/yazi"

# --- NEW: Generate init.lua if it doesn't exist ---
INIT_LUA_PATH="$DOTFILES_DIR/yazi/init.lua"
if [ ! -f "$INIT_LUA_PATH" ]; then
    echo "Generating init.lua for Git plugin..."
    cat << 'EOF' > "$INIT_LUA_PATH"
-- Initialize the git plugin to show status in the file list
require("git"):setup()
EOF
fi
# --------------------------------------------------

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

# --- Yazi Plugin Installation ---
echo "Checking for Yazi plugins..."

if command -v ya >/dev/null 2>&1; then
    echo "Syncing plugins via 'ya pkg'..."
    
    # 'install' reads your package.toml and downloads them
    # 'upgrade' pulls the absolute latest versions from GitHub
    if ya pkg install && ya pkg upgrade; then
        echo "✅ Yazi plugins installed and updated successfully!"
    else
        echo "❌ Error: Failed to sync plugins."
    fi
else
    echo "⚠️ Warning: The 'ya' command was not found."
    echo "Please ensure Yazi is fully installed to sync plugins."
fi  