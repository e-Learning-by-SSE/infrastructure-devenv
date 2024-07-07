#!/bin/bash

# Function to display usage instructions
usage() {
  echo "Usage: $0 [-d|--delete] [-f|--file compose-file] -r|--repo <GitHub Repository URL> -p|--project <Project Name> [--setup-compose <js>]"
  echo "  -d, --delete         Delete the volume before cloning"
  echo "  -f, --file           Specify the Docker Compose file (default: compose-dev.yml)"
  echo "  -r, --repo           Specify the GitHub Repository URL"
  echo "  -p, --project        Specify the Project Name"
  echo "  --setup-compose      Generate a default Docker Compose file for the specified project type (e.g., js)"
  exit 1
}

# Set default values
DELETE_VOLUME=false
COMPOSE_FILE="compose-dev.yml"
REPO_URL=""
PROJECT_NAME=""
VOLUME_NAME=""
SETUP_COMPOSE=false
PROJECT_TYPE=""

# Check options
OPTS=$(getopt -o df:r:p: --long delete,file:,repo:,project:,setup-compose: -n 'parse-options' -- "$@")
if [ $? != 0 ] ; then usage ; exit 1 ; fi

eval set -- "$OPTS"

while true; do
  case "$1" in
    -d | --delete ) DELETE_VOLUME=true; shift ;;
    -f | --file ) COMPOSE_FILE="$2"; shift; shift ;;
    -r | --repo ) REPO_URL="$2"; shift; shift ;;
    -p | --project ) PROJECT_NAME="$2"; shift; shift ;;
    --setup-compose ) SETUP_COMPOSE=true; PROJECT_TYPE="$2"; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# Check if required arguments are provided
if [ -z "$REPO_URL" ] || [ -z "$PROJECT_NAME" ] && [ "$SETUP_COMPOSE" = false ]; then
  usage
fi

# Set volume name based on project name
VOLUME_NAME="${PROJECT_NAME}-repository"

# Function to generate Docker Compose file
generate_compose_file() {
  local project_name="$1"
  local compose_file="$2"
  local volume_name="$3"
  local project_type="$4"

  if [ "$project_type" == "js" ]; then
    cat <<EOF > /${project_name}/${compose_file}
services:
  app:
    image: ghcr.io/e-learning-by-sse/dev-env-javascript:latest
    entrypoint:
      - sleep
      - infinity
    init: true
    volumes:
      - type: bind
        source: /var/run/docker.sock
        target: /var/run/docker.sock
      - codebase:/com.docker.devenvironments.code

volumes:
  codebase:
    external: true
    name: ${volume_name}
EOF
    echo "Docker Compose file ${compose_file} has been generated for JavaScript project."
  else
    echo "Unsupported project type: ${project_type}"
    exit 1
  fi
}

# Delete the volume if the -d option is set
if $DELETE_VOLUME; then
  echo "Deleting volume ${VOLUME_NAME}..."
  docker volume rm ${VOLUME_NAME} || echo "Volume ${VOLUME_NAME} does not exist, continuing..."
  echo "Proceeding after attempting to delete volume ${VOLUME_NAME}."
fi

# Check if the volume already exists
VOLUME_EXISTS=$(docker volume ls --format '{{.Name}}' | grep -w ${VOLUME_NAME})

if [ -z "$VOLUME_EXISTS" ]; then
  # Use a Docker container to clone the repository into the volume
  echo "Cloning repository ${REPO_URL} into volume ${VOLUME_NAME}..."
  if ! docker run --rm -it -v ${VOLUME_NAME}:/${PROJECT_NAME} docker git clone ${REPO_URL} /${PROJECT_NAME}; then
    echo "Failed to clone repository."
    exit 1
  fi
  echo "Repository cloned into volume ${VOLUME_NAME} successfully."

  # Set permissions to 1000 for the cloned repository
  echo "Setting permissions for ${PROJECT_NAME} to 1000..."
  if ! docker run --rm -v ${VOLUME_NAME}:/${PROJECT_NAME} docker chown -R 1000:1000 /${PROJECT_NAME}; then
    echo "Failed to set permissions."
    exit 1
  fi
  echo "Permissions set successfully."

else
  echo "Volume ${VOLUME_NAME} already exists. Skipping clone."
fi

# Generate Docker Compose file if setup-compose is set and volume already exists
if $SETUP_COMPOSE; then
  echo "Generating Docker Compose file for project ${PROJECT_NAME}..."
  docker run --rm -v ${VOLUME_NAME}:/${PROJECT_NAME} docker sh -c "$(declare -f generate_compose_file); generate_compose_file ${PROJECT_NAME} ${COMPOSE_FILE} ${VOLUME_NAME} ${PROJECT_TYPE}"
fi

# Run Docker Compose using the cloned repository as a volume
echo "Starting Docker Compose with ${COMPOSE_FILE}..."
docker run --rm -e VOLUME_NAME=${VOLUME_NAME} -v ${VOLUME_NAME}:/${PROJECT_NAME} -v /var/run/docker.sock:/var/run/docker.sock -w /${PROJECT_NAME} docker compose -f ${COMPOSE_FILE} up

