cls

$minecraftpid = Read-Host "Enter Minecraft "
$process = Get-Process -Id $minecraftpid | ForEach-Object { $_.Modules } | Where-Object { $_.ModuleName -like "*.dll" } | Select-Object FileName -ErrorAction SilentlyContinue

foreach($dll in $process) {

    #Write-Host $dll.FileName

    if (-not $dll.FileVersionInfo.FileDescription) {

            $signature = Get-AuthenticodeSignature $dll.FileName
            
            
            if ($signature.Status -ne 'Valid') {
                $fileSize = (Get-Item "$($dll.FileName)").Length
                Write-Host "Suspicious DLL: $($fileSize)    $($dll.FileName)" -ForegroundColor Yellow
            }
    }
}
