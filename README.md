How to use this on a brand new computer
Open the default terminal.

Clone your repo:
git clone https://github.com/your-username/dotfiles.git ~/dotfiles

Run the script:

Bash
cd ~/dotfiles
chmod +x install.sh
./install.sh
Important Note on Security
Before you push your .zshrc to a public GitHub repository, make sure it doesn't contain any secrets (like API keys, passwords, or your home address). If you have sensitive things, it's better to put them in a separate file called .secrets that you don't upload to GitHub, and add source ~/.secrets to your .zshrc.
