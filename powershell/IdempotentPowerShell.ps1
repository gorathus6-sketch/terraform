# set path variable
$Path = "C:\Temp"

if (-not (Test-Path $Path)) { New-Item -Item-Type Directory -Path $Path }