param(
    [string]$v = "3.10.9",
    [string]$r = ".\requirements.txt"
)

$pythonVersion = $v
$requirementsPath = $r
$zipPath = "python_embedded.zip"
$pythonEmbeddedPath = ".\python_embedded"


# Get python
if (-Not (Test-Path $zipPath)) {
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/$pythonVersion/python-$pythonVersion-embed-amd64.zip" -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $pythonEmbeddedPath
}

Set-Location $pythonEmbeddedPath

# Get pip
if (-Not (Test-Path "get-pip.py")) {
    Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "get-pip.py"
}

# Install pip
.\python.exe get-pip.py

# Find the _pth file and uncomment "import site"
# This makes it possible that python will use the packages installed inside the same folder
$pthFile = Get-ChildItem -Filter "python*._pth"
$content = Get-Content $pthFile
$content = $content -replace '#import site', 'import site'
$content | Set-Content $pthFile

Set-Location ".\.."

# Install requirements from requirements.txt
if (Test-Path $requirementsPath) {
    $pythonExePath = Join-Path -Path $pythonEmbeddedPath -ChildPath "python.exe"
    & $pythonExePath -m pip install -r $requirementsPath
} else {
    Write-Host "requirements.txt not found at $requirementsPath"
}
