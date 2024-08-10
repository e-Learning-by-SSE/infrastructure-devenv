# infrastructure-devenv


## Javascript
```
VERSION=v2-node21 docker build -t ghcr.io/e-learning-by-sse/dev-env-javascript:${VERSION} -t ghcr.io/e-learning-by-sse/dev-env-javascript:latest .
docker login
docker push ghcr.io/e-learning-by-sse/dev-env-javascript:${VERSION}
docker push ghcr.io/e-learning-by-sse/dev-env-javascript:latest
```
During registry login, use a github token instead of the github password https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
