ARG BASE_IMAGE=debian:trixie
FROM ${BASE_IMAGE}
ENV NPM_CONFIG_LOGLEVEL=warn

ARG INSTALL_FISH=false
ARG INSTALL_DOCKER=false
ARG INSTALL_NODEJS=true
ARG INSTALL_CYPRESS=true

## <BASE Preparation>
RUN apt-get update --fix-missing && apt-get install -y \
    curl \
    xz-utils \
    build-essential \
    python3 \
    git \
    vim \
    bash \
    sudo

COPY home/* /home/devuser/

RUN useradd -m devuser -u 1000 -s /bin/bash && \
    mkdir -p /code && \
    chown devuser:devuser /code && \
    chown -R devuser:devuser /home/devuser
## </ Base Preparation>

## <Feature Tags>
COPY setup-docker.sh /tmp/setup-docker.sh
COPY setup-fish.sh /tmp/setup-fish.sh
RUN if [ "$INSTALL_DOCKER" = "true" ]; then \
        bash /tmp/setup-docker.sh; \
    fi; \
    if [ "$INSTALL_NODEJS" = "true" ]; then \
        apt-get update && \
            apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            gnupg && \
        mkdir -p /etc/apt/keyrings && \
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
            | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_24.x nodistro main" \
            > /etc/apt/sources.list.d/nodesource.list && \
        apt-get update && \
        apt-get install -y --no-install-recommends nodejs; \
    fi; \
    if [ "$INSTALL_FISH" = "true" ]; then \
        bash /tmp/setup-fish.sh; \
    fi; \
    if [ "$INSTALL_CYPRESS" = "true" ]; then \
        apt-get update --fix-missing && apt-get install -y \
            libglib2.0-0t64 \
            libnss3 \
            libatk-bridge2.0-0 \
            libgtk-3-0t64 \
            libgbm-dev \
            libnotify-dev \
            libxss1 \
            libasound2t64 \
            libxshmfence1 \
            libgbm1 \
            libdrm2 \
            libatk1.0-0t64 \
            libxcomposite1 \
            libxdamage1 \
            libxrandr2 \
            libpango-1.0-0 \
            libcups2t64 \
            libpangocairo-1.0-0 \
            libatspi2.0-0 \
            libx11-xcb1 \
            libxinerama1 \
            xvfb \
            xauth \
            libxtst6; \
    fi; \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## </ Feature Tags>
 
USER devuser

## <Non-Root Features>
## </Non-Root Features

WORKDIR /code
VOLUME /code
EXPOSE 3000
CMD ["/bin/bash"]

