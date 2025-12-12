Write-Host "flush-mem v0.6 by SammiLucia modified by YenLegion to be used as a pwsh script." -ForegroundColor Cyan
Write-Host ""

# Check for administrative privileges
Write-Host "Checking admin privileges..."
If (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Not found."
    Write-Host "`nRequesting admin - ONLY accept if you got this from me..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
} else {
    Write-Host "Found!"
}

# Memory flushing operations
# Use $PSScriptRoot to get the script's folder
$emptyStandbyListPath = Join-Path -Path $PSScriptRoot -ChildPath "EmptyStandbyList.exe"

Function Flush-Memory {
    param (
        [string]$Operation
    )
    Write-Host "Flushing $Operation..."
    Start-Process -FilePath $emptyStandbyListPath -ArgumentList $Operation -NoNewWindow -Wait
    Write-Host "Done."
}

Write-Host "Flushing Unused Memory:"
Flush-Memory "workingsets"
Flush-Memory "modifiedpagelist"
Flush-Memory "priority0standbylist"
Flush-Memory "standbylist"

# Completion message
Write-Host "`nDone! All standby memory is cleared."
For ($i = 3; $i -ge 1; $i--) {
    Write-Host "Closing in ($i)..."
    Start-Sleep -Seconds 1
}
Read-Host "Press Enter to exit"
