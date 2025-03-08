#!/bin/bash
# Prepare host environment to execute install scripts
# Needs to be injected by infrastructure platform

# Github CLI
sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

gh auth login --with-token < github_token.txt
gh auth setup-git

# Server repository
git clone --depth=1 --no-checkout https://github.com/deltasiege/game.git
cd game
git sparse-checkout set scripts server
git checkout
cd scripts

# Bun
sudo apt install unzip -y # Unzip (required by Bun)
curl -fsSL https://bun.sh/install | bash # Bun
source ~/.bashrc
bun install
bun prepare.ts linux