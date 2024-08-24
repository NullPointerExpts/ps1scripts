cls
@echo off


Powershell "wmic path win32_computersystemproduct get uuid"
Powershell "getmac"
Powershell "Get-WmiObject -Class Win32_Processor -ComputerName. | Select-Object -Property ProcessorId*"

echo Done.
pause





