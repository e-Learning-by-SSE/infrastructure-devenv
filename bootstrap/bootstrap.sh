#!/bin/bash

usage() {
  echo "Usage: $0 [-d|--delete] [-f|--file compose-file] -r|--repo <GitHub Repository URL> -p|--project <Project Name> [--setup-compose <js>] [--podman]"
  exit 1
}

# Defaults
DELETE=false
COMPOSE_FILE="compose-dev.yml"
REPO_URL=""
PROJECT_NAME=""
SETUP_COMPOSE=false
PROJECT_TYPE=""
USE_PODMAN=false
RUNTIME_CMD="docker"
COMPOSE_CMD="docker-compose"

# Parse args
OPTS=$(getopt -o df:r:p: --long delete,file:,repo:,project:,setup-compose:,podman -n 'parse-options' -- "$@")
if [ $? != 0 ]; then usage; fi
eval set -- "$OPTS"

while true; do
  case "$1" in
    -d | --delete ) DELETE=true; shift ;;
    -f | --file ) COMPOSE_FILE="$2"; shift 2 ;;
    -r | --repo ) REPO_URL="$2"; shift 2 ;;
    -p | --project ) PROJECT_NAME="$2"; shift 2 ;;
    --setup-compose ) SETUP_COMPOSE=true; PROJECT_TYPE="$2"; shift 2 ;;
    --podman ) USE_PODMAN=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

[ -z "$PROJECT_NAME" ] && echo "Error: --project is required" && usage

# Set runtime
if $USE_PODMAN; then
  RUNTIME_CMD="podman"
  COMPOSE_CMD="podman-compose"
fi

VOLUME_NAME="$PROJECT_NAME"
PROJECT_DIR="./$PROJECT_NAME"

# Delete folder
if $DELETE; then
  echo "Deleting ${PROJECT_DIR}..."
  rm -rf "$PROJECT_DIR"
fi

# Clone if not present
if [ ! -d "$PROJECT_DIR" ]; then
  [ -z "$REPO_URL" ] && echo "Error: --repo is required for initial clone." && usage

  echo "Cloning ${REPO_URL} into ${PROJECT_DIR}..."
  git clone "$REPO_URL" "$PROJECT_DIR" || {
    echo "Failed to clone."
    exit 1
  }

  echo "Setting permissions..."
  chown -R $(id -u):$(id -g) "$PROJECT_DIR"
fi

# Compose file generation
if $SETUP_COMPOSE; then
  echo "Generating ${COMPOSE_FILE} for ${PROJECT_TYPE}..."

  if [ "$PROJECT_TYPE" == "js" ]; then
    cat <<EOF > "${PROJECT_DIR}/${COMPOSE_FILE}"
services:
  app:
    image: ghcr.io/e-learning-by-sse/dev-env-javascript:latest
    entrypoint: [ "sleep", "infinity" ]
    init: true
    volumes:
      - type: bind
        source: /var/run/docker.sock
        target: /var/run/docker.sock
      - type: bind
        source: .
        target: /code
    environment:
      - PROJECT_NAME=\${PROJECT_NAME}
      - VOLUME_NAME=\${VOLUME_NAME}
EOF
    echo "${COMPOSE_FILE} generated."
  else
    echo "Unsupported project type: ${PROJECT_TYPE}"
    exit 1
  fi
fi

# Start Compose with env vars
echo "Starting ${COMPOSE_CMD} with PROJECT_NAME=${PROJECT_NAME}..."

(
  cd "$PROJECT_DIR" || exit 1
  PROJECT_NAME="$PROJECT_NAME" VOLUME_NAME="$VOLUME_NAME" $COMPOSE_CMD -f "$COMPOSE_FILE" up
)

