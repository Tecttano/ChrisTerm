#!/bin/bash

# This script installs my preferred terminal setup on Debian-based systems
echo "1. Save this script to a file (e.g., 'setup-wezterm.sh')"
echo "2. Make it executable with: chmod +x setup-wezterm.sh"
echo "3. Run it with: ./setup-wezterm.sh"

echo "STEP 1"
echo "==== INSTALLING WEZTERM ===="
echo "Updating package repositories"
sudo apt update

# Error check
if [ $? -ne 0 ]; then
    echo "Failed to update package repositories. Exiting"
    exit 1
fi

echo "Installing Wezterm. . ."
sudo apt install -y wezterm

# Error check
if [ $? -ne 0 ]; then
    echo "Failed to update package repositories. Exiting"
    exit 1
fi

# Verify install
echo "Checking if Wezterm is installed..."
if command -v wezterm &> /dev/null; then
    echo "Wezterm is installed at: $(which wezterm)"
    echo "Version: $(wezterm --version)"
else
    echo "Wezterm is not installed"
fi

echo ""
echo "STEP 2"
echo "==== SETTING WEZTERM AS DEFAULT TERMINAL ===="

# Method 1: Using update-alternatives (Debian standard way)
echo "Setting as default using update-alternatives..."
if command -v update-alternatives &> /dev/null; then
    # Install wezterm as an alternative for x-terminal-emulator with high priority (100)
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$(which wezterm)" 100
    
    # Set wezterm as the default alternative
    sudo update-alternatives --set x-terminal-emulator "$(which wezterm)"
    
    if [ $? -ne 0 ]; then
        echo "Failed to set Wezterm as default using update-alternatives."
    else
        echo "Successfully set Wezterm as default terminal via update-alternatives"
    fi
else
    echo "update-alternatives command not found, skipping this method"
fi

# Method 2: Using xdg-mime (works in many desktop environments)
echo "Setting as default using xdg-mime..."
if command -v xdg-mime &> /dev/null; then
    xdg-mime default org.wezfurlong.wezterm.desktop x-scheme-handler/terminal
    
    if [ $? -ne 0 ]; then
        echo "Failed to set Wezterm as default using xdg-mime."
    else
        echo "Successfully set Wezterm as default terminal handler via xdg-mime"
    fi
else
    echo "xdg-mime command not found, skipping this method"
fi

echo ""
echo "STEP 3"
echo "==== CREATING WEZTERM CONFIGURATION ===="

# Create config directory if it doesn't exist
CONFIG_DIR="$HOME/.config/wezterm"
echo "Creating configuration directory at $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"

# Error check
if [ $? -ne 0 ]; then
    echo "Failed to create configuration directory. Exiting."
    exit 1
fi

# Create basic config file if it doesn't exist
CONFIG_FILE="$CONFIG_DIR/wezterm.lua"
echo "Creating configuration file at $CONFIG_FILE..."

if [ -f "$CONFIG_FILE" ]; then
    echo "Configuration file already exists. Not overwriting."
else
    cat > "$CONFIG_FILE" << 'EOL'
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Basic configuration
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "DejaVu Sans Mono",
  "Consolas",
})
config.font_size = 11.0
config.color_scheme = 'Dracula'
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- Enable scrollbar
config.enable_scroll_bar = true

-- Return the configuration
return config
EOL

    # Error check
    if [ $? -ne 0 ]; then
        echo "Failed to create configuration file."
    else
        echo "Configuration file created successfully."
    fi
fi

# Final message
echo ""
echo "==== SETUP COMPLETE ===="
echo "Wezterm has been installed and configured!"
echo "You can now launch it by typing 'wezterm' or using your application menu."
echo "Configuration file is located at: $CONFIG_FILE"