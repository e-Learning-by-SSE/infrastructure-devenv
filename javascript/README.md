
### Usage
The default user is an unprivileged 'devuser'.

We provide two versions: a normal version and a slim version. The normal version aims to offer a feature-rich and convenient environment to support your development. The slim version is designed to reduce disk space usage. We recommend using the slim version only if you have network (e.g., frequent downloads) or storage (e.g., limited disk space) constraints.

### Makefile Documentation

This Makefile is used to build and publish Docker images with optional components such as Docker, Node.js, and Fish shell. Below is a brief description of the targets, variables, and how to use them.

#### Feature Tags
- **FISH**: Set to [`true`] to include Fish shell in the Docker image.
- **DOCKER**: Set to [`true`] to include Docker and Podman CLI in the Docker image.
- **NODEJS**: Set to [`true`]to include Node.js in the Docker image.
- **IMAGE_TAG**: Specifies the tag for the Docker image. Defaults to [`latest`] if not set.

#### Targets

- **image**: Builds the Docker image with the specified components.
  ```makefile
  make image
  ```

- **publish**: Publishes the Docker image to a Docker registry with the specified tag under ghcr.io/e-learning-by-sse/dev-env-javascript
  ```makefile
  make publish
  ```

For a full feature build which includes a publish:
```makefile
make image FISH=true NODEJS=true DOCKER=true TAG=latest,v3-node21 publish
```

And for a slim version:
```makefile
make slim-image publish TAG=v3-slim 
```

You need to do a `docker login` before you can push the image. For authentication, use a github token instead of the github password https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry. 