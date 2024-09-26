# infrastructure-devenv


## Javascript

The javascript container is especially for developments with javascript/typescript projects. 

### Usage
Pull and run it. We recommend to mount your code to `com.docker.devenvironments.code` since this is the default working directory. The directory was choosen to create backwards compatbility with docker desktop devenvironments. 
The default user is an unprivileged node user. 

### Release

```
VERSION=v2-node21 docker build -t ghcr.io/e-learning-by-sse/dev-env-javascript:${VERSION} -t ghcr.io/e-learning-by-sse/dev-env-javascript:latest .
docker login
docker push ghcr.io/e-learning-by-sse/dev-env-javascript:${VERSION}
docker push ghcr.io/e-learning-by-sse/dev-env-javascript:latest
```
During registry login, use a github token instead of the github password https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry


## Bootstrap
The bootstrap tries to provide an easy method for setting up a dev environment, inspired by by the depricated devn environments feature of docker desktop.

### Usage

Quickstart: 
```
bash bootstrap.sh --repo 'your-git-repo-url' --project project-name
```
- You need to have a "compose-dev.yml" inside the root directory of the repository
- If you run a JS project, the script can create a temporary compose file for you.
- Run the script without any parameters for the help page
