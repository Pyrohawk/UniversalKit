# 1. ENVIRONMENT DETECTION
# This tells the shell if we are on a Mac or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    export IS_MAC=1
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export IS_LINUX=1
fi

# 2. PATH SETTINGS
# Homebrew lives in different places on Intel Macs vs Apple Silicon/Linux
if [[ $IS_MAC ]]; then
    # Apple Silicon Mac path
    eval "$(/opt/homebrew/bin/brew shellenv)" 
else
    # Linux / WSL path
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 3. STARSHIP PROMPT (The Cross-Platform Look)
# This replaces Powerlevel10k with a single, fast command
eval "$(starship init zsh)"

# 4. UNIVERSAL ALIASES
# These work the same on all systems
alias ll="ls -lah"
alias update="brew update && brew upgrade"
alias dotfiles="cd ~/dotfiles"

# 5. OS-SPECIFIC EXTRAS
if [[ $IS_MAC ]]; then
    # Mac-only: Open current folder in Finder
    alias f="open ."
    # Flush DNS (Mac version)
    alias flush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
elif [[ $IS_LINUX ]]; then
    # Linux-only: Open current folder in File Explorer
    alias f="explorer.exe ."
    # Update system packages
    alias sys-update="sudo apt update && sudo apt upgrade -y"
fi

# 6. PLUGINS (Manual Loading for Speed)
# Instead of Oh My Zsh, we point directly to the plugin files
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# RESTORE FUNCTION
# Finds the latest backup folder and restores the original files
restore_dots() {
    LATEST_BACKUP=$(ls -td ~/dotfiles_backup_* 2>/dev/null | head -n 1)
    
    if [ -z "$LATEST_BACKUP" ]; then
        echo "❌ No backup folders found."
        return 1
    fi

    echo "🔄 Restoring from $LATEST_BACKUP..."
    
    # Remove the symlinks
    rm -f ~/.zshrc
    rm -f ~/.config/starship.toml
    
    # Move the original files back
    [ -f "$LATEST_BACKUP/.zshrc" ] && mv "$LATEST_BACKUP/.zshrc" ~/
    [ -f "$LATEST_BACKUP/starship.toml" ] && mv "$LATEST_BACKUP/starship.toml" ~/.config/
    
    echo "✅ Original configuration restored. Please restart your terminal."
}
alias restore-my-terminal="restore_dots"
