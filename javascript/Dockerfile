FROM debian:12

ENV NPM_CONFIG_LOGLEVEL warn

# Update the package lists and install prerequisites including common development tools also adding podman
RUN apt-get update --fix-missing && apt-get install -y curl xz-utils build-essential python3 git vim bash iptables podman uidmap software-properties-common sudo

COPY install-docker.sh /tmp/install-docker.sh
RUN /tmp/install-docker.sh

# Add NodeSource repository to install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash -
RUN apt-get install -y nodejs

RUN useradd -m node -s /bin/bash && \
    mkdir -p /com.docker.devenvironments.code && \
    chown node:node /com.docker.devenvironments.code && chown -R node:node /home/node && usermod -aG docker node

RUN echo 'node ALL=(ALL) NOPASSWD: /usr/bin/docker' >> /etc/sudoers

USER node
COPY home/* /home/node/

WORKDIR //com.docker.devenvironments.code

EXPOSE 3000

CMD ["/bin/bash"]
