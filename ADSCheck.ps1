$file = Read-Host "Provide txts of SearchIndexer or Csrss or Explorer"
if (-not (Test-Path $file -PathType Leaf)) {
    Write-Host "Unidentified"
    exit
}
Get-Content $file | ForEach-Object {
    $line = $_.Trim()
    if ($line -match "^([a-zA-Z]:\\.+)\\?$") {
        $path = $Matches[1]
        if ($path.EndsWith(":")) {
            Write-Host "Potential ADS in: $path"
            $parentDirectory = Split-Path $path -Parent
            Write-Host ("Results of 'dir /a' for $parentDirectory`:")
            Push-Location $parentDirectory
            Get-ChildItem -Force | ForEach-Object {
                $_.FullName
            }
            Pop-Location
            Write-Host
        }
    }
}