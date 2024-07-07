param (
    [switch]$delete,
    [string]$file = "compose-dev.yml",
    [string]$repo,
    [string]$volume
)

# Funktion zur Anzeige der Nutzungshinweise
function Show-Usage {
    Write-Host "Usage: bootstrap.ps1 [-d|--delete] [-f|--file compose-file] -r|--repo <GitHub Repository URL> -v|--volume <Volume Name>"
    Write-Host "  -d, --delete         Delete the volume before cloning"
    Write-Host "  -f, --file           Specify the Docker Compose file (default: compose-dev.yml)"
    Write-Host "  -r, --repo           Specify the GitHub Repository URL"
    Write-Host "  -v, --volume         Specify the Docker Volume Name"
    exit 1
}

# Standardwerte setzen
$DELETE_VOLUME = $false
$COMPOSE_FILE = $file
$REPO_URL = $repo
$VOLUME_NAME = $volume

# Überprüfen der Optionen
if ($delete) {
    $DELETE_VOLUME = $true
}

# Überprüfen, ob die erforderlichen Argumente übergeben wurden
if ([string]::IsNullOrEmpty($REPO_URL) -or [string]::IsNullOrEmpty($VOLUME_NAME)) {
    Show-Usage
}

# Löschen des Volumes, falls die Option -d gesetzt wurde
if ($DELETE_VOLUME) {
    Write-Host "Deleting volume $VOLUME_NAME..."
    if (-not (docker volume rm $VOLUME_NAME)) {
        Write-Host "Failed to delete volume $VOLUME_NAME."
        exit 1
    }
    Write-Host "Volume $VOLUME_NAME deleted successfully."
}

# Überprüfen, ob das Volume bereits existiert
$VOLUME_EXISTS = docker volume ls --format '{{.Name}}' | Where-Object { $_ -eq $VOLUME_NAME }

if (-not $VOLUME_EXISTS) {
    # Docker-Container verwenden, um das Repository in das Volume zu klonen
    Write-Host "Cloning repository $REPO_URL into volume $VOLUME_NAME..."
    if (-not (docker run --rm -v ${VOLUME_NAME}:/devenv docker git clone $REPO_URL /devenv)) {
        Write-Host "Failed to clone repository."
        exit 1
    }
    Write-Host "Repository cloned into volume $VOLUME_NAME successfully."
} else {
    Write-Host "Volume $VOLUME_NAME already exists. Skipping clone."
}

# Docker Compose ausführen, wobei das geklonte Repository als Volume verwendet wird
Write-Host "Starting Docker Compose with $COMPOSE_FILE..."
docker run --rm -e VOLUME_NAME=$VOLUME_NAME -v ${VOLUME_NAME}:/devenv -v /var/run/docker.sock:/var/run/docker.sock -w /devenv docker compose  -f ${COMPOSE_FILE} up

