# MORA4ME Database Tunnel Manager (Updated for Infrastructure)
# PowerShell script to manage SSH tunnel for Shopware database access

param(
    [string]$Action = "start",  # start, stop, status
    [string]$LocalPort = "3306"
)

$ServerIP = "57.128.225.66"
$ServerPort = "2233"
$ServerUser = "ubuntu"
$SSHKey = "C:\Users\PC\.ssh\id_ed25519"
$RemotePort = "3307"  # Shopware database port (to avoid conflict with existing MySQL)

Write-Host "?? MORA4ME Shopware Database Tunnel" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

switch ($Action.ToLower()) {
    "start" {
        Write-Host "?? Starting SSH tunnel to Shopware database..." -ForegroundColor Blue
        Write-Host "Local Port: $LocalPort" -ForegroundColor Yellow
        Write-Host "Remote: ${ServerIP}:${RemotePort} (Shopware DB)" -ForegroundColor Yellow

        # Check if tunnel already exists
        $existingProcess = Get-Process | Where-Object { $_.ProcessName -eq "ssh" -and $_.CommandLine -like "*$LocalPort*" }
        if ($existingProcess) {
            Write-Host "??  SSH tunnel already running on port $LocalPort" -ForegroundColor Yellow
            Write-Host "Process ID: $($existingProcess.Id)" -ForegroundColor Gray
            exit 0
        }

        # Start SSH tunnel to Shopware database
        try {
            Write-Host "Creating tunnel: localhost:$LocalPort -> ${ServerIP}:${RemotePort}" -ForegroundColor Cyan
            $process = Start-Process -FilePath "ssh" -ArgumentList @(
                "-i", $SSHKey,
                "-p", $ServerPort,
                "-L", "${LocalPort}:localhost:${RemotePort}",
                "-N",
                "-f",
                "${ServerUser}@${ServerIP}"
            ) -PassThru -WindowStyle Hidden

            Start-Sleep -Seconds 3

            # Verify tunnel
            $tunnelProcess = Get-Process | Where-Object { $_.ProcessName -eq "ssh" -and $_.Id -eq $process.Id }
            if ($tunnelProcess) {
                Write-Host "? SSH tunnel to Shopware database started successfully!" -ForegroundColor Green
                Write-Host "?? Shopware DB accessible at: 127.0.0.1:$LocalPort" -ForegroundColor Cyan
                Write-Host "?? Process ID: $($process.Id)" -ForegroundColor Gray

                # Save tunnel info
                $tunnelInfo = @{
                    ProcessId  = $process.Id
                    LocalPort  = $LocalPort
                    RemoteHost = $ServerIP
                    RemotePort = $RemotePort
                    Database   = "shopware"
                    StartTime  = Get-Date
                }
                $tunnelInfo | ConvertTo-Json | Out-File -FilePath "shopware-tunnel-info.json"

                Write-Host ""
                Write-Host "?? Shopware Database Connection:" -ForegroundColor Yellow
                Write-Host "Host: 127.0.0.1"
                Write-Host "Port: $LocalPort"
                Write-Host "Database: shopware"
                Write-Host "Username: shopware"
                Write-Host "Password: shopwarepass"
                Write-Host ""
                Write-Host "?? Access URLs after deployment:" -ForegroundColor Cyan
                Write-Host "Storefront: https://sklep.mora4me.com"
                Write-Host "Admin Panel: https://sklep.mora4me.com/admin"
                Write-Host ""
                Write-Host "???  Stop tunnel: .\shopware-tunnel.ps1 -Action stop"
            }
            else {
                Write-Host "? Failed to start SSH tunnel" -ForegroundColor Red
                exit 1
            }
        }
        catch {
            Write-Host "? Error starting tunnel: $_" -ForegroundColor Red
            exit 1
        }
    }

    "stop" {
        Write-Host "?? Stopping Shopware database tunnel..." -ForegroundColor Blue

        # Find and kill SSH processes
        $sshProcesses = Get-Process | Where-Object {
            $_.ProcessName -eq "ssh" -and
            ($_.CommandLine -like "*$LocalPort*" -or $_.CommandLine -like "*$ServerIP*")
        }

        if ($sshProcesses) {
            foreach ($process in $sshProcesses) {
                try {
                    Write-Host "Stopping process ID: $($process.Id)" -ForegroundColor Yellow
                    Stop-Process -Id $process.Id -Force
                    Write-Host "? Process $($process.Id) stopped" -ForegroundColor Green
                }
                catch {
                    Write-Host "??  Failed to stop process $($process.Id): $_" -ForegroundColor Yellow
                }
            }

            # Remove tunnel info file
            if (Test-Path "shopware-tunnel-info.json") {
                Remove-Item "shopware-tunnel-info.json"
            }

            Write-Host "? Shopware database tunnel stopped" -ForegroundColor Green
        }
        else {
            Write-Host "??  No Shopware database tunnel found running" -ForegroundColor Gray
        }
    }

    "status" {
        Write-Host "?? Checking Shopware database tunnel status..." -ForegroundColor Blue

        # Check for SSH processes
        $sshProcesses = Get-Process | Where-Object {
            $_.ProcessName -eq "ssh" -and
            ($_.CommandLine -like "*$LocalPort*" -or $_.CommandLine -like "*$ServerIP*")
        }

        if ($sshProcesses) {
            Write-Host "? Shopware database tunnel is running" -ForegroundColor Green
            foreach ($process in $sshProcesses) {
                Write-Host "?? Process ID: $($process.Id)" -ForegroundColor Gray
                Write-Host "?? Start Time: $($process.StartTime)" -ForegroundColor Gray
                Write-Host "?? CPU Time: $($process.TotalProcessorTime)" -ForegroundColor Gray
            }

            # Show tunnel info if available
            if (Test-Path "shopware-tunnel-info.json") {
                $tunnelInfo = Get-Content "shopware-tunnel-info.json" | ConvertFrom-Json
                Write-Host ""
                Write-Host "?? Tunnel Details:" -ForegroundColor Yellow
                Write-Host "Local Port: $($tunnelInfo.LocalPort)"
                Write-Host "Remote: $($tunnelInfo.RemoteHost):$($tunnelInfo.RemotePort)"
                Write-Host "Database: $($tunnelInfo.Database)"
                Write-Host "Started: $($tunnelInfo.StartTime)"
            }

            # Test connection
            Write-Host ""
            Write-Host "?? Testing connection..." -ForegroundColor Blue
            try {
                $connection = Test-NetConnection -ComputerName "127.0.0.1" -Port $LocalPort -WarningAction SilentlyContinue
                if ($connection.TcpTestSucceeded) {
                    Write-Host "? Port $LocalPort is accessible" -ForegroundColor Green
                }
                else {
                    Write-Host "? Port $LocalPort is not accessible" -ForegroundColor Red
                }
            }
            catch {
                Write-Host "??  Could not test port: $_" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "? No Shopware database tunnel running" -ForegroundColor Red
            Write-Host "?? Start tunnel: .\shopware-tunnel.ps1 -Action start" -ForegroundColor Gray
        }
    }

    default {
        Write-Host "? Invalid action: $Action" -ForegroundColor Red
        Write-Host ""
        Write-Host "?? Usage:" -ForegroundColor Yellow
        Write-Host "  .\shopware-tunnel.ps1 -Action start    # Start tunnel"
        Write-Host "  .\shopware-tunnel.ps1 -Action stop     # Stop tunnel"
        Write-Host "  .\shopware-tunnel.ps1 -Action status   # Check status"
        Write-Host ""
        Write-Host "?? Examples:" -ForegroundColor Yellow
        Write-Host "  .\shopware-tunnel.ps1 -Action start -LocalPort 3307"
        Write-Host "  .\shopware-tunnel.ps1 -Action status"
        exit 1
    }
}

Write-Host ""
Write-Host "?? Infrastructure Overview:" -ForegroundColor Gray
Write-Host "   Nextcloud: https://mora4me.com (port 80/443)"
Write-Host "   Shopware: https://sklep.mora4me.com (port 8080 -> 80/443)"
Write-Host "   Database: 127.0.0.1:$LocalPort -> ${ServerIP}:${RemotePort}"
Write-Host ""
Write-Host "?? Shopware Database Connection:" -ForegroundColor Gray
Write-Host "   Host: 127.0.0.1"
Write-Host "   Port: $LocalPort"
Write-Host "   Database: shopware"
Write-Host "   Username: shopware"
Write-Host "   Password: shopwarepass"
