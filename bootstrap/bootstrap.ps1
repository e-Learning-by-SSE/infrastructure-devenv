param (
    [switch]$Delete,
    [string]$File = "compose-dev.yml",
    [string]$Repo,
    [Parameter(Mandatory=$true)][string]$Project,
    [string]$SetupCompose,
    [switch]$Podman
)

function Usage {
    Write-Host "Usage: bootstrap.ps1 [-Delete] [-File <compose-file>] -Repo <GitHub Repo> -Project <name> [-SetupCompose <type>] [-Podman]"
    exit 1
}

$RuntimeCmd = if ($Podman) { "podman" } else { "docker" }
$ComposeCmd = if ($Podman) { "podman-compose" } else { "docker-compose" }

$VolumeName = $Project
$ProjectDir = Join-Path -Path $PSScriptRoot -ChildPath $Project

# Delete project dir if needed
if ($Delete) {
    Write-Host "Deleting $ProjectDir..."
    Remove-Item -Recurse -Force -ErrorAction Stop $ProjectDir
}

# Clone if necessary
if (-not (Test-Path $ProjectDir)) {
    if (-not $Repo) {
        Write-Error "Missing required parameter: --repo"
        Usage
    }

    Write-Host "Cloning $Repo into $ProjectDir..."
    git clone $Repo $ProjectDir
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to clone repository."
        exit 1
    }
}

# Generate compose file
if ($SetupCompose) {
    if ($SetupCompose -eq "js") {
        Write-Host "Generating $File for javascript..."
        @"
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
      - PROJECT_NAME=${Project}
      - VOLUME_NAME=${VolumeName}
"@ | Set-Content -Path (Join-Path $ProjectDir $File)
        Write-Host "$File generated."
    }
    else {
        Write-Error "Unsupported project type: $SetupCompose"
        exit 1
    }
}

# Start environment
Write-Host "Starting $ComposeCmd with PROJECT_NAME=$Project..."

Push-Location $ProjectDir
$env:PROJECT_NAME = $Project
$env:VOLUME_NAME = $VolumeName
& $ComposeCmd -f $File up
Pop-Location
