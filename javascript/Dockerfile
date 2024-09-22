FROM debian:12

ARG INSTALL_FISH=false
ARG INSTALL_DOCKER=false
ARG INSTALL_NODEJS=true

ENV NPM_CONFIG_LOGLEVEL=warn

## <BASE Preparation>
RUN apt-get update --fix-missing && apt-get install -y \
    curl \
    xz-utils \
    build-essential \
    python3 \
    git \
    vim \
    bash \
    sudo && \
    apt-get clean
    
COPY home/* /home/node/

RUN useradd -m node -s /bin/bash && \
    mkdir -p /com.docker.devenvironments.code && \
    chown node:node /com.docker.devenvironments.code && \
    chown -R node:node /home/node
## </ Base Preparation>

## <Feature Tags>
COPY setup-docker.sh /tmp/setup-docker.sh
COPY setup-fish.sh /tmp/setup-fish.sh
RUN if [ "$INSTALL_DOCKER" = "true" ]; then \
        bash /tmp/setup-docker.sh; \
    fi; \
    if [ "$INSTALL_NODEJS" = "true" ]; then \
        curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
        apt-get install -y --no-install-recommends nodejs; \
    fi; \
    if [ "$INSTALL_FISH" = "true" ]; then \
        bash /tmp/setup-fish.sh; \
    fi; \
    apt-get clean;

## </ Feature Tags>
 
USER node

## <Non-Root Features>
## </Non-Root Features

WORKDIR /com.docker.devenvironments.code
VOLUME /com.docker.devenvironments.code
EXPOSE 3000
CMD ["/bin/bash"]

