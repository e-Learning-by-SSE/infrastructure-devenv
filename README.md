
This repository aims to provide reproducible, comprehensive, and convenient development environments. This is done through dev containers and bootstrapper scripts for them. 

## Bootstrap
The bootstrap script offers an easy method for setting up a development environment, inspired by the deprecated dev environments feature of Docker Desktop (https://docs.docker.com/desktop/dev-environments/set-up/).

### Usage

Quickstart:

```sh
bash bootstrap.sh --repo 'your-git-repo-url' --project project-name
```
- Ensure you have a `compose-dev.yml` file in the root directory of your repository. We recommend using one of our maintained containers.
- The entire repository is cloned into a Docker volume named after your project. On Linux, you only need to have Docker installed (Docker Compose is not required). Note that Podman is currently not supported (see issue #3).
- After the initial clone, simply run `bash bootstrap.sh --project project-name` to start the dev containers.

Additional Features:
- Run the script without any parameters to view the help page.
- The script can create a temporary `compose-dev.yml` file for you, in case you don't have one and want to use any of our provieded dev containers. See [this README](bootstrap/README.md) for further assistance.

## JavaScript

The JavaScript container is specifically designed for development with JavaScript/TypeScript projects.

[Pull](https://github.com/e-Learning-by-SSE/infrastructure-devenv/pkgs/container/dev-env-javascript) and run the container. Mount your code into `/code` as this is the default working directory. If you need backward compatibility with the Docker Desktop dev environment feature, use the v2 version of the JavaScript environment. For more information, see the linked documentation.


# Miscellaneous

This repository is a component of the `infrastructure` for SSE e-learning projects, which is reflected in its suffix of the repository name "infrastructure".