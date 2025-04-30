# ChrisTerm

A customized terminal environment setup focused on productivity and aesthetics.

## Overview

It's my terminal. It's meant for a Debian environment, can be customized and riced further.

## Features

- **Kitty Terminal** - GPU-accelerated, feature-rich terminal emulator
- **Zsh & Oh My Zsh** - Powerful shell with extensive customization options
- **Powerlevel10k** - Fast, flexible, and feature-rich Zsh theme
- **Nerd Fonts** - JetBrainsMono Nerd Font for programming ligatures and icons
- **Productivity Plugins** - Autosuggestions, syntax highlighting, and completions
- **Custom Aliases** - Shortcuts for git, system commands, and navigation
- **Vim Configuration** - Sensible defaults for the Vim text editor
- **Beautiful Themes** - Dracula color scheme for a consistent experience

## Installation

### Prerequisites

- Debian-based Linux distribution (Ubuntu, Debian, etc.)
- `sudo` privileges
- Internet connection for downloading packages

### Automatic Installation

```bash
# Clone the repository
git clone https://github.com/username/christerm.git
cd christerm

# Make the script executable
chmod +x setup.sh

# Run the setup script
sudo ./setup.sh
```

### Manual Installation

If you prefer to install components individually, follow these steps:

1. Install Kitty Terminal
2. Install Zsh
3. Set Zsh as Default Shell
4. Install Nerd Fonts
5. Install Oh My Zsh
6. Install Powerlevel10k Theme
7. Install Zsh Plugins
8. Set Up Vim
9. Configure Kitty Terminal
10. Create Zsh Configuration
11. Create Powerlevel10k Configuration

Detailed instructions for each step can be found in the [Wiki](https://github.com/username/christerm/wiki).

## Customization

### Kitty Configuration

Edit `~/.config/kitty/kitty.conf` to customize your terminal appearance, keybindings, and behavior.

### Zsh Configuration

Edit `~/.zshrc` to customize your shell environment, aliases, functions, and plugins.

### Powerlevel10k

Run `p10k configure` to interactively customize your prompt appearance.

### Vim Configuration

Edit `~/.vimrc` to customize your text editor settings.

## Keyboard Shortcuts

### Kitty Shortcuts

- `Ctrl+Shift+C`: Copy to clipboard
- `Ctrl+Shift+V`: Paste from clipboard
- `Ctrl+Shift+T`: New tab
- `Ctrl+Shift+Enter`: New window
- `Ctrl+Shift+L`: Cycle through layouts
- `Ctrl+Shift+Q`: Quit Kitty
- `Ctrl+Shift+Plus/Minus`: Increase/decrease font size

### Zsh Shortcuts

- `Ctrl+R`: Fuzzy search command history
- `Ctrl+A/E`: Move to beginning/end of line
- `Alt+B/F`: Move backward/forward one word

### Vim Shortcuts

- `,w`: Save file
- `,q`: Quit
- `,x`: Save and quit
- `,v`: Vertical split
- `,s`: Horizontal split

## Included Aliases

### System Aliases

- `cls`: Clear the screen
- `..`: Go up one directory
- `...`: Go up two directories
- `desk`: Go to Desktop
- `docs`: Go to Documents
- `dl`: Go to Downloads
- `update`: Update system packages

### Git Aliases

- `ga`: Git add
- `gc`: Git commit with message
- `gs`: Git status
- `gl`: Git log (oneline)
- `gp`: Git push
- `gpl`: Git pull

## Known Issues

- Powerlevel10k configuration may not load immediately on first launch
- Some Nerd Font icons might not display correctly in all applications

## Acknowledgments

- [Kitty Terminal](https://sw.kovidgoyal.net/kitty/)
- [Zsh](https://www.zsh.org/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Dracula Theme](https://draculatheme.com/)
