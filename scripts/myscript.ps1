
New-Item -ItemType Directory -Path test3

if (Test-Path test3) {
    Write-Host "Directory test3 exists"
} else {
    Write-Host "Directory test3 does not exist"
}
