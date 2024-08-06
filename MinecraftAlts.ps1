$minecraftPath = "$env:APPDATA\.minecraft"
$usernameCachePath = Join-Path -Path $minecraftPath -ChildPath "usernamecache.json"
$userCachePath = Join-Path -Path $minecraftPath -ChildPath "usercache.json"

if (Test-Path $minecraftPath) {
    if (Test-Path $usernameCachePath) {
        $usernameCacheContent = Get-Content -Path $usernameCachePath -Raw | ConvertFrom-Json
        $otherUsernames = $usernameCacheContent | ForEach-Object {
            $_.PSObject.Properties.Value
        } | Where-Object { $_ -match '^[A-Za-z0-9_]+$' } | Select-Object -Unique
        
        Write-Output "Outras contas encontradas no usernamecache.json:"
        $otherUsernames
        Write-Output ""
    }
    else {
        Write-Output "O arquivo usernamecache.json não existe na pasta .minecraft"
        Write-Output ""
    }
    
    if (Test-Path $userCachePath) {
        $userCacheContent = Get-Content -Path $userCachePath -Raw | ConvertFrom-Json
        $otherAccounts = $userCacheContent | Select-Object -ExpandProperty "name" | Select-Object -Unique
        
        Write-Output "Outras contas encontradas no usercache.json:"
        $otherAccounts
    }
    else {
        Write-Output "O arquivo usercache.json não existe na pasta .minecraft"
    }
}
else {
    Write-Output "A pasta .minecraft não existe no caminho: $minecraftPath"
}

Write-Output ""
Write-Output "█░█░█ █ █▄▀ █▄█   █▀ █▀"
Write-Output "▀▄▀▄▀ █ █░█ ░█░   ▄█ ▄█https://discord.gg/9mPAyZaMCw"