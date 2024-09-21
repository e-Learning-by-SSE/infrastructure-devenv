FROM debian:12

ENV NPM_CONFIG_LOGLEVEL=warn

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    curl \
    xz-utils \
    build-essential \
    python3 \
    git \
    vim \
    bash \
    iptables \
    podman \
    uidmap \
    software-properties-common \
    sudo \
    fish && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY install-docker.sh /tmp/install-docker.sh
RUN /tmp/install-docker.sh && rm /tmp/install-docker.sh

RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m node -s /bin/bash && \
    mkdir -p /com.docker.devenvironments.code && \
    chown node:node /com.docker.devenvironments.code && \
    chown -R node:node /home/node && \
    usermod -aG docker node

RUN echo 'node ALL=(ALL) NOPASSWD: /usr/bin/docker' >> /etc/sudoers


USER node

COPY home/* /home/node/

WORKDIR /com.docker.devenvironments.code

EXPOSE 3000

CMD ["/bin/bash"]

