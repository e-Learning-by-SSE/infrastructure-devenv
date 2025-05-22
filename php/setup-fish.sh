#!/bin/bash
set -e

# Install Fish
apt-get install -y fish

# Get the username of the user with UID 1000
USER_NAME=$(getent passwd 1000 | cut -d: -f1)

# Run the following commands as the target user
sudo -u $USER_NAME -i <<'EOF'
# Install fisher
fish -c 'curl -o /tmp/fisher.fish -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish && source /tmp/fisher.fish && fisher install jorgebucaran/fisher'

# Install node version management
fish -c 'fisher install jorgebucaran/nvm.fish'

# Install fancy prompt
fish -c 'fisher install jorgebucaran/hydro'

# Enable fish-shell
echo "exec fish" >> ~/.bashrc
EOF

#!/bin/bash
set -e

# Install Fish
apt-get install -y fish

# Get the username of the user with UID 1000
USER_NAME=$(getent passwd 1000 | cut -d: -f1)

# Run the following commands as the target user
sudo -u $USER_NAME -i fish <<'EOF'
echo "exec fish" >> ~/.bashrc
curl -o /tmp/fisher.fish -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish && \
     source /tmp/fisher.fish && \
     fisher install jorgebucaran/fisher && \
     fisher install jorgebucaran/nvm.fish && \
     fisher install jorgebucaran/hydro && \
     
     alias nx="npx nx" --save
     alias ng="npx ng" --save
     #alias npm="npx npm" --save
     alias yarn="npx yarn" --save
     alias tsc="npx tsc" --save
     alias eslint="npx eslint" --save
     alias prettier="npx prettier" --save
     alias jest="npx jest" --save
     
     echo "set -x NVM_DIR $HOME/.nvm" >> ~/.config/fish/config.fish

     set --universal hydro_color_pwd blue
     set --universal hydro_color_git yellow

EOF