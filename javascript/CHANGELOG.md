# Changelog for the Javascript devenv container


## [upcoming] - ??

### Changed
- Default working dir is changed from `/com.docker.devenvironments.code` to `/code`. 
- default user is now `devuser`
- Base image is now debian bookworm

## [v3] - 22.09.2024

### Added
- Fish shell; this includes fisher plugins
- Docker and podman cli; the docker now supports "nesting" container
- Added a slim version with no additional features other than node. 

### Fixed
- Prompt problem: https://github.com/e-Learning-by-SSE/infrastructure-devenv/issues/1
- Permission problem in home directory #2

