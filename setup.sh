#!/bin/bash

# Chris' Terminal Setup - Complete Configuration
# This script sets up a fully customized terminal environment

set -e  # Exit on error

echo "===================================="
echo "    Chris' Terminal Setup           "
echo "===================================="
echo

# Function to print section headers
section() {
    echo
    echo "------------------------------------"
    echo " $1 "
    echo "------------------------------------"
}

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script should be run with sudo or as root."
  exit 1
fi

# Store username for later use
USERNAME=$SUDO_USER

# Step 1: Install Kitty (if not already done)
section "1. Installing Kitty Terminal"
if ! command -v kitty &> /dev/null; then
  apt update
  apt install -y curl wget
  
  # Try to install from Debian repos first
  apt install -y kitty

  # If the above fails, use the installer script
  if [ $? -ne 0 ]; then
    echo "Debian repository installation failed, trying installer script..."
    su -c "curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin" $USERNAME
    
    # Create symlinks to make kitty available in PATH
    ln -sf /home/$USERNAME/.local/kitty.app/bin/kitty /usr/local/bin/
    ln -sf /home/$USERNAME/.local/kitty.app/bin/kitten /usr/local/bin/
  fi
else
  echo "Kitty is already installed, skipping..."
fi

# Step 2: Install Zsh
section "2. Installing Zsh"
apt update
apt install -y zsh

# Step 3: Set Zsh as default shell
section "3. Setting Zsh as default shell"
chsh -s $(which zsh) $USERNAME
echo "Zsh is now the default shell for $USERNAME"

# Step 4: Install Nerd Fonts
section "4. Installing Nerd Fonts"
FONT_DIR="/usr/share/fonts/truetype/nerd-fonts"
mkdir -p $FONT_DIR

# Install JetBrainsMono Nerd Font
echo "Installing JetBrainsMono Nerd Font..."
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
unzip -q /tmp/JetBrainsMono.zip -d /tmp/JetBrainsMono
cp /tmp/JetBrainsMono/*.ttf $FONT_DIR
rm -rf /tmp/JetBrainsMono /tmp/JetBrainsMono.zip

# Update font cache
fc-cache -f -v
echo "JetBrainsMono Nerd Font installed"

# Step 5: Install Oh My Zsh (as user, not root)
section "5. Installing Oh My Zsh"
# Temporarily save .zshrc if it exists
if [ -f /home/$USERNAME/.zshrc ]; then
  mv /home/$USERNAME/.zshrc /home/$USERNAME/.zshrc.backup
fi

# Install Oh My Zsh as the user (not as root)
su - $USERNAME -c 'curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh'

# Step 6: Install Powerlevel10k
section "6. Installing Powerlevel10k"
su - $USERNAME -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-/home/$USERNAME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Step 7: Install Zsh plugins
section "7. Installing Zsh plugins"

# zsh-autosuggestions
su - $USERNAME -c "git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-/home/$USERNAME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# zsh-syntax-highlighting
su - $USERNAME -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-/home/$USERNAME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# zsh-completions
su - $USERNAME -c "git clone https://github.com/zsh-users/zsh-completions \
  ${ZSH_CUSTOM:-/home/$USERNAME/.oh-my-zsh/custom}/plugins/zsh-completions"

# fzf - command-line fuzzy finder
apt install -y fzf

echo "Zsh plugins installed"

# Step 8: Configure Vim
section "8. Setting up Vim"
apt install -y vim

# Create .vimrc with a nice configuration
cat > /home/$USERNAME/.vimrc << 'EOF'
" Chris' Vim Configuration

" General settings
set nocompatible
syntax on
set number
set relativenumber
set cursorline
set showmatch
set incsearch
set hlsearch
set smartcase
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set backspace=indent,eol,start
set scrolloff=5
set wildmenu
set wildmode=list:longest
set mouse=a
set clipboard=unnamedplus
set history=1000
set undolevels=1000
set title
set encoding=utf-8
set fileencodings=utf-8
set background=dark
set noerrorbells
set visualbell
set t_vb=
set laststatus=2
set showcmd
set ruler
set confirm
set splitbelow
set splitright

" Color settings
if &term =~ '256color'
  set t_ut=
endif

highlight LineNr ctermfg=grey
highlight CursorLineNr ctermfg=yellow
highlight CursorLine cterm=NONE ctermbg=234

" Key mappings
let mapleader=","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>/ :nohlsearch<CR>
nnoremap <leader>n :set relativenumber!<CR>

" File type specific settings
filetype plugin indent on
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab
EOF

chown $USERNAME:$USERNAME /home/$USERNAME/.vimrc
echo "Vim configuration created"

# Step 9: Configure Kitty with a cool theme
section "9. Configuring Kitty Terminal"
mkdir -p /home/$USERNAME/.config/kitty
cat > /home/$USERNAME/.config/kitty/kitty.conf << 'EOF'
# Chris' Kitty Terminal Configuration

# Font configuration
font_family      JetBrainsMono Nerd Font
bold_font        JetBrainsMono Nerd Font Bold
italic_font      JetBrainsMono Nerd Font Italic
bold_italic_font JetBrainsMono Nerd Font Bold Italic
font_size 13.0

# Window padding
window_padding_width 10

# Tab bar style
tab_bar_style powerline
tab_powerline_style slanted
active_tab_background #50fa7b
active_tab_foreground #282a36
inactive_tab_background #282a36
inactive_tab_foreground #f8f8f2

# Window layout
enabled_layouts tall,grid,stack

# Background opacity
background_opacity 0.9

# Color scheme - Dracula theme
foreground #f8f8f2
background #282a36

# Dracula color palette
color0 #21222c
color8 #6272a4
color1 #ff5555
color9 #ff6e6e
color2 #50fa7b
color10 #69ff94
color3 #f1fa8c
color11 #ffffa5
color4 #bd93f9
color12 #d6acff
color5 #ff79c6
color13 #ff92df
color6 #8be9fd
color14 #a4ffff
color7 #f8f8f2
color15 #ffffff

# Cursor
cursor #f8f8f2
cursor_shape beam
cursor_beam_thickness 1.5

# URL style
url_color #8be9fd
url_style single

# Terminal bell - disable it
enable_audio_bell no
visual_bell_duration 0.0
window_alert_on_bell no
bell_on_tab no

# Scrollback
scrollback_lines 10000
scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER

# Performance tuning
repaint_delay 10
input_delay 3
sync_to_monitor yes

# Essential keyboard shortcuts
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+equal change_font_size all +2.0
map ctrl+shift+minus change_font_size all -2.0
map ctrl+shift+n new_os_window
map ctrl+shift+t new_tab
map ctrl+shift+q quit
map ctrl+shift+l next_layout
map ctrl+tab next_tab
map ctrl+shift+tab previous_tab
EOF

chown -R $USERNAME:$USERNAME /home/$USERNAME/.config/kitty
echo "Kitty configuration created"

# Step 10: Create .zshrc with custom configuration
section "10. Creating Zsh configuration"
cat > /home/$USERNAME/.zshrc << EOF
# Chris' Zsh Configuration

# Enable Powerlevel10k instant prompt
if [[ -r "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh" ]]; then
  source "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="\$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  sudo
  docker
  docker-compose
  fzf
  history
  dirhistory
  colorize
  command-not-found
)

# Load Oh My Zsh
source \$ZSH/oh-my-zsh.sh

# Environment variables
export EDITOR='vim'
export VISUAL='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"

# Custom path additions
export PATH="\$HOME/.local/bin:\$PATH"

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Directory navigation shortcuts
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# Completions
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist

# Better directory listing
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -a'
alias l='ls -CF'

# System aliases
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias desk='cd ~/Desktop'
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias sysinfo='neofetch'
alias myip='curl http://ipecho.net/plain; echo'
alias ip-ext='curl -s ifconfig.me'
alias ports='netstat -tulanp'
alias disk='df -h'
alias mem='free -h'
alias c='clear'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}"'
alias dcl='docker container ls'
alias dcla='docker container ls -a'
alias dex='docker exec -it'

# Git aliases
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gf='git fetch'
alias grb='git rebase'
alias gm='git merge'
alias gr='git reset'
alias grh='git reset --hard'
alias grs='git reset --soft'

# Directory shortcuts
hash -d desk=~/Desktop
hash -d docs=~/Documents
hash -d dl=~/Downloads
hash -d code=~/code
hash -d projects=~/projects

# Custom functions
# Extract various archive formats
extract() {
  if [ -f \$1 ] ; then
    case \$1 in
      *.tar.bz2)   tar xjf \$1     ;;
      *.tar.gz)    tar xzf \$1     ;;
      *.bz2)       bunzip2 \$1     ;;
      *.rar)       unrar e \$1     ;;
      *.gz)        gunzip \$1      ;;
      *.tar)       tar xf \$1      ;;
      *.tbz2)      tar xjf \$1     ;;
      *.tgz)       tar xzf \$1     ;;
      *.zip)       unzip \$1       ;;
      *.Z)         uncompress \$1  ;;
      *.7z)        7z x \$1        ;;
      *)           echo "'\\$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'\\$1' is not a valid file"
  fi
}

# Create a new directory and enter it
mkcd() {
  mkdir -p "\$@" && cd "\$@"
}

# Show directory contents after cd
cd() {
  builtin cd "\$@" && ls
}

# Quick find
qfind() {
  find . -name "\$1" -type f
}

# Find process
fps() {
  ps aux | grep -i "\$1"
}

# Kill process
kp() {
  ps aux | grep -i "\$1" | awk '{print \$2}' | xargs kill -9
}

# Git commit all with message
gca() {
  git add --all && git commit -m "\$1"
}

# Weather information
weather() {
  curl -s "wttr.in/\${1:-}"
}

# Backup file with timestamp
bak() {
  cp "\$1" "\$1.bak-\$(date +%Y%m%d-%H%M%S)"
}

# Source fzf if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc
echo "Zsh configuration created"

# Step 11: Create p10k configuration
section "11. Creating Powerlevel10k configuration"
cat > /home/$USERNAME/.p10k.zsh << 'EOF'
# Generated by Powerlevel10k configuration wizard on 2023-01-01 at 12:00 local time.
# Basic Powerlevel10k configuration for brevity
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  local -A POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=() POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
  
  # Basic prompt configuration
  POWERLEVEL9K_MODE='nerdfont-complete'
  POWERLEVEL9K_ICON_PADDING=none
  POWERLEVEL9K_BACKGROUND=none
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs)
  
  # Add newline before each prompt
  POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  
  # Directory settings
  POWERLEVEL9K_DIR_BACKGROUND='none'
  POWERLEVEL9K_DIR_FOREGROUND='blue'
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  
  # VCS settings
  POWERLEVEL9K_VCS_BACKGROUND='none'
  POWERLEVEL9K_VCS_CLEAN_FOREGROUND='green'
  POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='yellow'
  POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='cyan'
  
  # OS icon
  POWERLEVEL9K_OS_ICON_BACKGROUND='none'
  POWERLEVEL9K_OS_ICON_FOREGROUND='red'
  
  # Status
  POWERLEVEL9K_STATUS_OK=false
  POWERLEVEL9K_STATUS_ERROR_BACKGROUND='none'
  POWERLEVEL9K_STATUS_ERROR_FOREGROUND='red'
  
  # Command execution time
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='yellow'
  
  # Background jobs
  POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='none'
  POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='blue'
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
EOF

chown $USERNAME:$USERNAME /home/$USERNAME/.p10k.zsh
echo "Powerlevel10k configuration created"

# Final message
section "Setup Complete!"
echo ""
echo "What's been installed:"
echo "✓ Kitty Terminal with a Dracula theme"
echo "✓ Zsh as the default shell"
echo "✓ Oh My Zsh framework"
echo "✓ Powerlevel10k theme"
echo "✓ JetBrainsMono Nerd Font"
echo "✓ Useful Zsh plugins"
echo "✓ Custom Vim configuration"
echo "✓ Aliases and functions for productivity"
echo ""
echo "To start using your new setup:"
echo "1. Log out and log back in, or run 'zsh' to start a new shell"
echo "2. Launch Kitty terminal from your applications menu"
echo "3. The first time you launch, Powerlevel10k may ask you some questions"
echo ""