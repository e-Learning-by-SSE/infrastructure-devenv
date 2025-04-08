#!/bin/bash
set -e

# Install Fish shell
apt-get update && apt-get install -y fish

# Get the username of the user with UID 1000
USER_NAME=$(getent passwd 1000 | cut -d: -f1)

# Run Fish setup as the target user
sudo -u "$USER_NAME" -i fish <<'EOF'
# Ensure fish is the default shell on login
grep -qxF 'exec fish' ~/.bashrc || echo 'exec fish' >> ~/.bashrc

# Install fisher and plugins
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o /tmp/fisher.fish
source /tmp/fisher.fish
fisher install jorgebucaran/fisher
fisher install jorgebucaran/nvm.fish
fisher install jorgebucaran/hydro
alias nx="npx nx" --save
alias ng="npx ng" --save
#alias npm="npx npm" --save
alias yarn="npx yarn" --save
alias tsc="npx tsc" --save
alias eslint="npx eslint" --save
alias prettier="npx prettier" --save
alias jest="npx jest" --save
set --universal hydro_color_pwd blue
set --universal hydro_color_git yellow
EOF
