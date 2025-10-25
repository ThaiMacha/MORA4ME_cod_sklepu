# MORA4ME Production Deployment Script for Windows
# PowerShell script to deploy to production server

param(
    [string]$Domain = "sklep.mora4me.com",
    [string]$Email = "admin@mora4me.com"
)

Write-Host "🚀 MORA4ME Production Deployment" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green

# Server details
$ServerIP = "57.128.225.66"
$ServerPort = "2233"
$ServerUser = "ubuntu"
$SSHKey = "C:\Users\PC\.ssh\id_ed25519"

Write-Host "📋 Deployment Details:" -ForegroundColor Yellow
Write-Host "Server: ${ServerIP}:${ServerPort}"
Write-Host "Domain: $Domain"
Write-Host "Email: $Email"
Write-Host ""

# Test SSH connection
Write-Host "🔑 Testing SSH connection..." -ForegroundColor Blue
try {
    $testConnection = ssh -i $SSHKey -p $ServerPort -o ConnectTimeout=10 -o StrictHostKeyChecking=no $ServerUser@$ServerIP "echo 'Connection successful'"
    if ($testConnection -eq "Connection successful") {
        Write-Host "✅ SSH connection successful" -ForegroundColor Green
    }
    else {
        throw "SSH connection failed"
    }
}
catch {
    Write-Host "❌ SSH connection failed: $_" -ForegroundColor Red
    Write-Host "Please check your SSH configuration and server status" -ForegroundColor Yellow
    exit 1
}

# Copy deployment script to server
Write-Host "📤 Copying deployment script to server..." -ForegroundColor Blue
try {
    scp -i $SSHKey -P $ServerPort -o StrictHostKeyChecking=no "deploy-production.sh" "${ServerUser}@${ServerIP}:/tmp/"
    Write-Host "✅ Deployment script copied successfully" -ForegroundColor Green
}
catch {
    Write-Host "❌ Failed to copy deployment script: $_" -ForegroundColor Red
    exit 1
}

# Make script executable
Write-Host "🔧 Making script executable..." -ForegroundColor Blue
ssh -i $SSHKey -p $ServerPort -o StrictHostKeyChecking=no $ServerUser@$ServerIP "chmod +x /tmp/deploy-production.sh"

# Run deployment
Write-Host "🚀 Starting deployment on server..." -ForegroundColor Blue
Write-Host "This may take 10-15 minutes..." -ForegroundColor Yellow

try {
    ssh -i $SSHKey -p $ServerPort -o StrictHostKeyChecking=no $ServerUser@$ServerIP "DOMAIN=$Domain EMAIL=$Email /tmp/deploy-production.sh"
    Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "❌ Deployment failed: $_" -ForegroundColor Red
    Write-Host "Check the server logs for more details" -ForegroundColor Yellow
    exit 1
}

# Get deployment info
Write-Host "📋 Retrieving deployment information..." -ForegroundColor Blue
ssh -i $SSHKey -p $ServerPort -o StrictHostKeyChecking=no $ServerUser@$ServerIP "cat /var/www/mora4me/deployment-info.txt"

Write-Host ""
Write-Host "🎉 MORA4ME Production Deployment Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "🌐 Your shop is now available at: https://$Domain" -ForegroundColor Cyan
Write-Host "🔧 Admin panel: https://$Domain/admin" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Yellow
Write-Host "1. Point your domain DNS to: $ServerIP"
Write-Host "2. Wait for SSL certificate generation (up to 10 minutes)"
Write-Host "3. Login to admin panel with: admin / shopware"
Write-Host "4. Configure your shop settings"
Write-Host ""
Write-Host "💡 Useful commands:" -ForegroundColor Yellow
Write-Host "- Connect to server: ssh production-server"
Write-Host "- Check status: ssh production-server 'cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml ps'"
Write-Host "- View logs: ssh production-server 'cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml logs -f'"
