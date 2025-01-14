Clear-Host

$jmap_path = Read-Host "Enter JMap path: "
$minecraftpid = Read-Host "Enter Minecraft PID: "


$output = (& $jmap_path "-histo" $minecraftpid) -split "`n"


foreach($out in $output) {
    if (-not $out.Contains("com.") -and -not $out.Contains("org.") -and -not $out.Contains("net.") -and -not $out.Contains("java.") -and -not $out.Contains("jdk.") -and -not $out.Contains("sun.") -and -not $out.Contains("io.")) {
        Write-Host $out
    }   
}