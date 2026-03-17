#!/bin/bash

# Define colors for better feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Safe Terminal Setup...${NC}"

# 1. Create Backup Directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
echo -e "${BLUE}📁 Creating backup folder at $BACKUP_DIR...${NC}"
mkdir -p "$BACKUP_DIR"

# Function to safely backup and link files
safe_link() {
    local source_file=$1
    local target_file=$2

    if [ -f "$target_file" ] || [ -d "$target_file" ]; then
        if [ ! -L "$target_file" ]; then
            echo "📦 Backing up original $target_file"
            mv "$target_file" "$BACKUP_DIR/"
        else
            echo "🔗 Removing old symbolic link $target_file"
            rm "$target_file"
        fi
    fi
    ln -s "$source_file" "$target_file"
}

# 2. Install Homebrew (Conditional)
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}🍺 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Load brew for this session
    [[ "$OSTYPE" == "darwin"* ]] && eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 3. Install Tools
echo -e "${BLUE}📦 Installing Starship and Plugins...${NC}"
brew install starship zsh-autosuggestions zsh-syntax-highlighting fastfetch

# 4. Apply Safe Links
mkdir -p ~/.config
safe_link ~/dotfiles/.zshrc ~/.zshrc
safe_link ~/dotfiles/starship.toml ~/.config/starship.toml

echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${GREEN}💡 Original files (if any) are safe in $BACKUP_DIR${NC}"
