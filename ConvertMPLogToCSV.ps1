[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true,
               Position = 1,
               HelpMessage = 'Specify the Microsoft Defender MPLog file to parse.')]
    [String]$InputFile,
    [Parameter(Mandatory = $true,
               Position = 2,
               HelpMessage = 'Specify the folder where the output file will be placed.')]
    [String]$OutputFolder,
    [Parameter(Mandatory = $false,
               HelpMessage = 'Specify the output file name (by default Microsoft_WindowsDefender_<FILENAME>.csv).')]
    [String]$outputFile
)

try {
    # Check if $InputFile exists.
    if (-not (Test-Path -Path $InputFile -PathType Leaf)) {
        throw "The file $InputFile does not exist."
    }

    # Create the $OutputFolder path if it does not exist.
    if (-not (Test-Path -Path $OutputFolder -PathType Container)) {
        # Create the directory, but do not prompt for confirmation (-Confirm:$false).
        [void] (New-Item -ItemType Directory -Path $OutputFolder -Confirm:$false)
    }

    $LogFile = Get-Item -Path $InputFile
    $LogData = $LogFile | Get-Content -Encoding utf8 -Raw
    $LogOutput = New-Object System.Collections.ArrayList

    # Regex with a positive lookahead assertion to find the date pattern (YYYY-MM-DDThh:mm:ss) at the start of each line, and then uses that as a delimiter to split the file content into individual log entries.
    # (?m) flag enables multiline mode so that ^ matches the start of each line.
    $LogEntries = $LogData -split "(?m)^(?=\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z)"

    Foreach ($LogEntry in $LogEntries) {

        if ($null -eq $LogEntry -or "" -eq $LogEntry.Trim()) { continue }

        # Split the log entry in the component: timestamp, provider, and raw message. Each component is separated by white spaces.
        # The provider is not always specified, as the log format does not follow a schema.

        # Previous version with unamed groups:
        # $LogExtract = $LogEntry | Select-String -Pattern "^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.*?)\s(\[.*?]|\S+?:)?\s?((?s).*)$"
        # $Timestamp, $Provider, $Message = $LogExtract.Matches[0].Groups[1..3].Value

        $LogExtract = $LogEntry | Select-String -Pattern "^(?<Timestamp>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.*?)\s(?<Provider>\[.*?]|\S+?:)?\s?(?<Message>(?s).*)$"

        If ($LogExtract.Matches.Count -eq 0) {
            Write-Warning "No extracted fields from log line: '$LogEntry'"
            continue
        }

        $Timestamp = $LogExtract.Matches[0].Groups['Timestamp'].Value
        $Provider = $LogExtract.Matches[0].Groups['Provider'].Value
        $Message = $LogExtract.Matches[0].Groups['Message'].Value.Trim()

        # Extract the provider from "[<PROVIDER>]" or "<PROVIDER>:".
        $null = $Provider -match '^\[?(?<ProviderExtracted>.*?)]?:?$'
        $Provider = If ($Matches.Contains("ProviderExtracted")) { $Matches["ProviderExtracted"] }

        $null = $LogOutput.Add([PSCustomObject] @{
            Timestamp = $Timestamp
            Provider = $Provider
            Message = $Message
        })
    }

    $LogOutput | Export-Csv -NoTypeInformation "$OutputFolder\\Microsoft_WindowsDefender_$($LogFile.BaseName).csv"
}

catch [System.Exception] {
    # If an error occurred, print error details
    Write-Error "An error occurred while running this script"
    Write-Error "Exception type: $($_.Exception.GetType().FullName)"
    Write-Error "Exception message: $($_.Exception.Message)"
}