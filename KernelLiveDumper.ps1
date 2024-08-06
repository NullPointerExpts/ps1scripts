$StorageSubSystem = Get-CimInstance -ClassName MSFT_StorageSubSystem -Namespace Root\Microsoft\Windows\Storage
Invoke-CimMethod -InputObject $StorageSubSystem -MethodName "GetDiagnosticInfo" -Arguments @{
    DestinationPath = "C:\dmp"
    IncludeLiveDump = $True}