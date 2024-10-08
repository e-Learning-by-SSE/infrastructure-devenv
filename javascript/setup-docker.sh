set -e
# Install Docker

apt-get update
apt-get install lsb-release ca-certificates apt-transport-https software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Configure docker
usermod -aG docker node
echo 'node ALL=(ALL) NOPASSWD: /usr/bin/docker' >> /etc/sudoers

# Install Podman
apt-get install -y \
            iptables \
            podman \
            uidmap \
            software-properties-common \
