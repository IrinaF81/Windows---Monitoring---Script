
# Systemüberwachungsskript (auf Deutsch)
# Erstellt von Irina :)

# CPU-Auslastung prüfen
$cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
$cpuLast = [math]::Round($cpu.Average, 2)

# RAM prüfen
$ram = Get-CimInstance Win32_OperatingSystem
$ramFrei = [math]::Round($ram.FreePhysicalMemory / 1MB, 2)
$ramGesamt = [math]::Round($ram.TotalVisibleMemorySize / 1MB, 2)

# Festplatten prüfen
$laufwerke = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

# Ausgabe
Write-Host "🖥️ CPU-Auslastung: $cpuLast %"
Write-Host "💾 Verfügbarer RAM: $ramFrei MB von $ramGesamt MB"
Write-Host "📂 Festplattenplatz:"
foreach ($d in $laufwerke) {
    $frei = [math]::Round($d.FreeSpace / 1GB, 2)
    $gesamt = [math]::Round($d.Size / 1GB, 2)
    Write-Host " - Laufwerk $($d.DeviceID): $frei GB frei von $gesamt GB"

    # Warnung bei wenig Speicherplatz
    if ($frei -lt 5) {
        Write-Warning "⚠️ Wenig Speicherplatz auf $($d.DeviceID): nur $frei GB frei!"
    }
}

# Warnung bei hoher CPU-Auslastung
if ($cpuLast -gt 90) {
    Write-Warning "⚠️ Hohe CPU-Auslastung: $cpuLast %"
}

# Warnung bei wenig RAM
if ($ramFrei -lt 500) {
    Write-Warning "⚠️ Wenig verfügbarer RAM: $ramFrei MB"
}
