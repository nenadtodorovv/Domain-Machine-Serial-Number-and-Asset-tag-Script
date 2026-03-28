# Target computer name
$computerName = "Computer Name"

try {
    # Test if the computer is reachable first
    if (Test-Connection -ComputerName $computerName -Count 1 -Quiet) {
        try {
            # Query system enclosure info
            $systemEnclosure = Get-CimInstance -ClassName Win32_SystemEnclosure -ComputerName $computerName -ErrorAction Stop
            $biosInfo = Get-CimInstance -ClassName Win32_BIOS -ComputerName $computerName -ErrorAction Stop

            $assetTag = $systemEnclosure.SMBIOSAssetTag
            $serialNumber = $biosInfo.SerialNumber

            if ([string]::IsNullOrWhiteSpace($assetTag)) {
                $assetTag = "N/A"
            }
            if ([string]::IsNullOrWhiteSpace($serialNumber)) {
                $serialNumber = "N/A"
            }

            Write-Host "[$computerName] Inventory Number (Asset Tag): $assetTag"
            Write-Host "[$computerName] Serial Number: $serialNumber"
        }
        catch {
            Write-Host "[$computerName] Error retrieving hardware info: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[$computerName] is not reachable (Ping failed)." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
}
