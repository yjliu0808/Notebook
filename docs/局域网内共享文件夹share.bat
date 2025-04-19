@echo off
title One-click LAN Share Setup (Clean Console)
chcp 65001 >nul
setlocal

set "TEMP_PS1=%TEMP%\share_temp_script.ps1"
del "%TEMP_PS1%" >nul 2>&1

:: Write PowerShell script content
>>"%TEMP_PS1%" echo [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
>>"%TEMP_PS1%" echo $FolderPath = "D:\LANShareFolder"
>>"%TEMP_PS1%" echo $ShareName = "SharedFolder"
>>"%TEMP_PS1%" echo $Description = "LAN Shared Folder"

:: IP detection
>>"%TEMP_PS1%" echo $lanIP = Get-NetIPAddress -AddressFamily IPv4 ^| Where-Object { $_.IPAddress -like "192.168.1.*" -and $_.InterfaceAlias -notmatch "VMware^|VirtualBox^|Loopback" } ^| Select-Object -ExpandProperty IPAddress -First 1
>>"%TEMP_PS1%" echo if (-not $lanIP) { Write-Host "[ERROR] No LAN IP found. Please connect to Wi-Fi or LAN." -ForegroundColor Red; exit 1 }
>>"%TEMP_PS1%" echo Write-Host "[OK] Detected LAN IP: $lanIP"

:: Folder and share setup
>>"%TEMP_PS1%" echo if (!(Test-Path $FolderPath)) { New-Item -ItemType Directory -Path $FolderPath ^| Out-Null; Write-Host "[OK] Folder created: $FolderPath" }
>>"%TEMP_PS1%" echo if (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue) { Remove-SmbShare -Name $ShareName -Force; Write-Host "[INFO] Existing share removed." }
>>"%TEMP_PS1%" echo New-SmbShare -Name $ShareName -Path $FolderPath -FullAccess Everyone -Description $Description

:: Grant full control to Everyone
>>"%TEMP_PS1%" echo $acl = Get-Acl $FolderPath
>>"%TEMP_PS1%" echo $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
>>"%TEMP_PS1%" echo $acl.SetAccessRule($rule)
>>"%TEMP_PS1%" echo Set-Acl $FolderPath $acl

:: Enable firewall rules
>>"%TEMP_PS1%" echo Get-NetFirewallRule -DisplayName "*File and Printer Sharing*" ^| Enable-NetFirewallRule ^| Out-Null
>>"%TEMP_PS1%" echo Get-NetFirewallRule -DisplayName "*Echo Request*" ^| Enable-NetFirewallRule ^| Out-Null
>>"%TEMP_PS1%" echo Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LimitBlankPasswordUse" -Value 0

:: Final output
>>"%TEMP_PS1%" echo Write-Host ""
>>"%TEMP_PS1%" echo Write-Host "[OK] LAN share setup complete. You can access it from other devices via:" -ForegroundColor Green
>>"%TEMP_PS1%" echo Write-Host "`"\\$lanIP\$ShareName`"" -ForegroundColor Yellow
>>"%TEMP_PS1%" echo pause

:: Check if script was written
if not exist "%TEMP_PS1%" (
    echo [ERROR] Failed to write PowerShell script.
    pause
    exit /b
)

:: Run PowerShell script (in current window)
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_PS1%"
pause
endlocal
