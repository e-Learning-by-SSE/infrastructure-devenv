param (
    [switch]$Delete,
    [string]$ComposeFile = "compose-dev.yml",
    [string]$Repo,
    [string]$Project
)

function Usage {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [-Delete] [-ComposeFile <Compose File>] -Repo <GitHub Repository URL> -Project <Project Name>"
    Write-Host "  -Delete          Delete the volume before cloning"
    Write-Host "  -ComposeFile     Specify the Docker Compose file (default: compose-dev.yml)"
    Write-Host "  -Repo            Specify the GitHub Repository URL"
    Write-Host "  -Project         Specify the Project Name"
    exit 1
}

# Validate required parameters
if (-not $Repo -or -not $Project) {
    Usage
}

# Set volume name based on project name
$VolumeName = "${Project}-repository"

# Delete the volume if the -Delete option is set
if ($Delete) {
    Write-Host "Deleting volume $VolumeName..."
    docker volume rm $VolumeName -f
    Write-Host "Proceeding after attempting to delete volume $VolumeName."
}

# Check if the volume already exists
$VolumeExists = docker volume ls --format '{{.Name}}' |  Where-Object { $_ -eq $VolumeName }

if (-not $VolumeExists) {
    # Use a Docker container to clone the repository into the volume
    Write-Host "Cloning repository $Repo into volume $VolumeName..."
    if (-not (docker run --rm -it -v "${VolumeName}:/${Project}" docker git clone $Repo "/${Project}")) {
        Write-Host "Failed to clone repository."
        exit 1
    }
    Write-Host "Repository cloned into volume $VolumeName successfully."

    # Set permissions to 1000 for the cloned repository
    Write-Host "Setting permissions for ${Project} to 1000..."
    docker run --rm -v "${VolumeName}:/${Project}" docker chown -R 1000:1000 "/${Project}"
} else {
    Write-Host "Volume $VolumeName already exists. Skipping clone."
}

# Run Docker Compose using the cloned repository as a volume
Write-Host "Starting Docker Compose with $ComposeFile..."
docker run --rm -e VOLUME_NAME=$VolumeName -v "${VolumeName}:/${Project}" -v "/var/run/docker.sock:/var/run/docker.sock" -w "/${Project}" docker compose -f $ComposeFile up
