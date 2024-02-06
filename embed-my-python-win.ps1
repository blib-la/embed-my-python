param(
    [string]$v = "3.10.9",
    [string]$r = ".\requirements.txt",
    [string]$d = ".\python-embedded"
)

$pythonVersion = $v
$requirementsPath = $r
$zipPath = "python_embedded-$v.zip"
$pythonEmbeddedPath = $d

# Download python
if (-Not (Test-Path $zipPath)) {
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/$pythonVersion/python-$pythonVersion-embed-amd64.zip" -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $pythonEmbeddedPath
}

Write-Output $zipPath

# Create destination folder
if (-Not (Test-Path $pythonEmbeddedPath)) {
    Expand-Archive -Path $zipPath -DestinationPath $pythonEmbeddedPath
}

# Set python
$pythonExePath = Join-Path -Path $pythonEmbeddedPath -ChildPath "python.exe"

# Get pip
$pipPath = Join-Path -Path $pythonEmbeddedPath -ChildPath "get-pip.py"
if (-Not (Test-Path $pipPath)) {
    Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile $pipPath
}

# Install pip
& $pythonExePath $pipPath

# Find the _pth file and uncomment "import site"
$pthFile = Get-ChildItem -Path $pythonEmbeddedPath -Filter "python*._pth"
$content = Get-Content $pthFile.FullName
$content = $content -replace '#import site', 'import site'
$content | Set-Content $pthFile.FullName

# Install requirements from requirements.txt
if (Test-Path $requirementsPath) {
    # Get the directory of the requirements.txt file
    $requirementsDir = Split-Path -Parent $requirementsPath

    # Change to the directory where requirements.txt is located
    Push-Location $requirementsDir

    # Execute pip install, now with the correct relative paths based on requirements.txt location
    & $pythonExePath -m pip install -r (Get-Item $requirementsPath).Name

    # Revert back to the original script directory
    Pop-Location
} else {
    Write-Host "requirements.txt not found at $requirementsPath"
}
