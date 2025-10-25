# ===============================================
# MORA4ME - Rozwiązania problemów z SSH
# ===============================================

Write-Host "🔧 Diagnoza i rozwiązania problemów SSH" -ForegroundColor Red
Write-Host "=" * 50 -ForegroundColor Gray

Write-Host "`n❌ PROBLEM: SSH się zawiesza/wisi" -ForegroundColor Yellow

Write-Host "`n🔍 MOŻLIWE PRZYCZYNY:" -ForegroundColor Cyan
Write-Host "1. Timeout połączenia" -ForegroundColor White
Write-Host "2. Firewall blokuje długie sesje" -ForegroundColor White  
Write-Host "3. NAT/Router kończy połączenie" -ForegroundColor White
Write-Host "4. Brak aktywności w sesji" -ForegroundColor White

Write-Host "`n✅ ROZWIĄZANIA:" -ForegroundColor Green

Write-Host "`n🎯 1. VSCode Remote-SSH (NAJLEPSZE):" -ForegroundColor Yellow
Write-Host "   • Ctrl+Shift+P" -ForegroundColor Cyan
Write-Host "   • Remote-SSH: Connect to Host" -ForegroundColor Cyan
Write-Host "   • Wybierz: shopware-cloud" -ForegroundColor Cyan

Write-Host "`n🎯 2. SSH z keep-alive:" -ForegroundColor Yellow
Write-Host '   ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 shopware-cloud' -ForegroundColor Cyan

Write-Host "`n🎯 3. Krótkie sesje SSH (do zadań):" -ForegroundColor Yellow
Write-Host '   ssh shopware-cloud "cd /var/www/shopware && ls -la"' -ForegroundColor Cyan

Write-Host "`n🎯 4. SSH przez PuTTY (alternatywa):" -ForegroundColor Yellow
Write-Host "   Host: 57.128.225.66" -ForegroundColor Cyan
Write-Host "   Port: 2233" -ForegroundColor Cyan
Write-Host "   User: ubuntu" -ForegroundColor Cyan
Write-Host "   Key: C:\Users\PC\.ssh\id_ed25519" -ForegroundColor Cyan

Write-Host "`n🎯 5. WinSCP (do plików):" -ForegroundColor Yellow
Write-Host "   Protocol: SFTP" -ForegroundColor Cyan
Write-Host "   Host: 57.128.225.66:2233" -ForegroundColor Cyan

Write-Host "`n🚀 ZALECENIE: Użyj VSCode Remote-SSH!" -ForegroundColor Green
Write-Host "Jest najbardziej stabilny dla długich sesji." -ForegroundColor Gray