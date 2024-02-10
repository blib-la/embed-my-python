param(
    [string]$v = "3.10.9",
    [string]$r = ".\requirements.txt",
    [string]$d = ".\python-embedded",
    [string]$a
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


# Find the _pth file and read its content
$pthFile = Get-ChildItem -Path $pythonEmbeddedPath -Filter "python*._pth"
$contentLines = Get-Content $pthFile.FullName

# Initialize an empty list to hold the new content, excluding 'import site' lines
$newContent = @()

foreach ($line in $contentLines) {
    # Exclude lines that are exactly 'import site' or '#import site' (with optional whitespace)
    if (-not ($line -match '^\s*#?import site\s*$')) {
        $newContent += $line
    }
}

# Always add 'import site' at the end of the new content
$newContent += 'import site'

# If an additional path is provided and not already in the content, add it before 'import site'
if ($a -and -not ($newContent -contains $a)) {
    $newContent += $a
}

# Write the updated content back to the .pth file
$newContent | Set-Content $pthFile.FullName






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
