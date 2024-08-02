# Use Debian 12 as the base image
FROM debian:12

# Set environment variables to make npm installs less verbose
ENV NPM_CONFIG_LOGLEVEL warn

# Update the package lists and install prerequisites including common development tools
RUN apt-get update --fix-missing && apt-get install -y curl xz-utils build-essential python3 git vim bash

# Add NodeSource repository to install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash -

# Install Node.js and npm
RUN apt-get install -y nodejs

# Create node user and set ownership of the app directory
RUN useradd -m node -s /bin/bash && \
    mkdir -p /com.docker.devenvironments.code && \
    chown node:node /com.docker.devenvironments.code

# Switch to node user
USER node

COPY home/* /home/node/

# Set the working directory to the app directory
WORKDIR //com.docker.devenvironments.code

# Optionally, expose a common port for web applications
EXPOSE 3000

# Start an interactive shell as the default command
CMD ["/bin/bash"]
