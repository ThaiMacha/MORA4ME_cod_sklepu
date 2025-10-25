# 🚀 MORA4ME Auto-Setup Script
# Automatyczna instalacja i konfiguracja całego środowiska

param(
    [switch]$Force,
    [switch]$SkipRestart,
    [switch]$Verbose
)

Write-Host "🚀 MORA4ME - Automatyczna Instalacja Środowiska" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Sprawdź uprawnienia administratora
function Test-IsAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Uruchom jako administrator jeśli potrzeba
if (-not (Test-IsAdmin)) {
    Write-Host "🔐 Skrypt wymaga uprawnień administratora..." -ForegroundColor Yellow
    Write-Host "   Uruchamianie jako administrator..." -ForegroundColor Yellow

    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($Force) { $arguments += " -Force" }
    if ($SkipRestart) { $arguments += " -SkipRestart" }
    if ($Verbose) { $arguments += " -Verbose" }

    Start-Process PowerShell -ArgumentList $arguments -Verb RunAs -Wait
    exit
}

Write-Host "✅ Uruchomiony z uprawnieniami administratora" -ForegroundColor Green

# Funkcja logowania
function Write-Step {
    param($Message, $Color = "Cyan")
    Write-Host "`n📋 $Message" -ForegroundColor $Color
    Write-Host ("=" * ($Message.Length + 4)) -ForegroundColor $Color
}

# Krok 1: Sprawdź Docker Desktop
Write-Step "Sprawdzanie Docker Desktop"
try {
    $dockerVersion = docker --version 2>$null
    if ($dockerVersion) {
        Write-Host "✅ Docker Desktop: $dockerVersion" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Docker Desktop nie jest zainstalowany!" -ForegroundColor Red
        Write-Host "   Zainstaluj Docker Desktop przed kontynuowaniem" -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "❌ Docker Desktop nie jest dostępny!" -ForegroundColor Red
    exit 1
}

# Krok 2: Sprawdź WSL
Write-Step "Sprawdzanie WSL"
try {
    $wslStatus = wsl --status 2>$null
    Write-Host "✅ WSL jest dostępny" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  WSL nie jest dostępny - włączanie..." -ForegroundColor Yellow
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-Host "✅ WSL został włączony" -ForegroundColor Green
}

# Krok 3: Sprawdź dystrybucje WSL
Write-Step "Sprawdzanie dystrybucji WSL"
$wslList = wsl -l -v 2>$null
if ($LASTEXITCODE -ne 0 -or $wslList -match "nie ma zainstalowanych dystrybucji") {
    Write-Host "📦 Instalowanie Ubuntu WSL..." -ForegroundColor Yellow

    # Zainstaluj Ubuntu
    try {
        Write-Host "   Pobieranie Ubuntu..." -ForegroundColor Gray
        wsl --install Ubuntu --no-launch

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Ubuntu WSL został zainstalowany" -ForegroundColor Green
        }
        else {
            Write-Host "❌ Błąd instalacji Ubuntu WSL" -ForegroundColor Red
            # Spróbuj alternatywną metodę
            Write-Host "   Próba alternatywnej metody..." -ForegroundColor Yellow
            wsl --set-default-version 2
            wsl --install --distribution Ubuntu
        }
    }
    catch {
        Write-Host "❌ Nie można zainstalować Ubuntu WSL" -ForegroundColor Red
        Write-Host "   Błąd: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "✅ Dystrybucja WSL już zainstalowana" -ForegroundColor Green
    Write-Host $wslList
}

# Krok 4: Ustaw WSL 2 jako domyślną wersję
Write-Step "Konfiguracja WSL 2"
try {
    wsl --set-default-version 2
    Write-Host "✅ WSL 2 ustawiony jako domyślny" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  Nie można ustawić WSL 2 jako domyślnego" -ForegroundColor Yellow
}

# Krok 5: Sprawdź czy potrzebny restart
Write-Step "Sprawdzanie konieczności restartu"
$needsRestart = $false

# Sprawdź czy WSL wymaga restartu
try {
    $wslTest = wsl echo "test" 2>$null
    if ($LASTEXITCODE -ne 0) {
        $needsRestart = $true
        Write-Host "⚠️  WSL wymaga restartu systemu" -ForegroundColor Yellow
    }
}
catch {
    $needsRestart = $true
}

# Sprawdź czy Docker wymaga restartu
try {
    $dockerTest = docker info 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Docker wymaga restartu lub uruchomienia Docker Desktop" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "⚠️  Docker nie odpowiada" -ForegroundColor Yellow
}

if ($needsRestart -and -not $SkipRestart) {
    Write-Host "`n🔄 WYMAGANY RESTART SYSTEMU" -ForegroundColor Red
    Write-Host "==============================" -ForegroundColor Red
    Write-Host "WSL wymaga restartu aby działać poprawnie." -ForegroundColor Yellow
    Write-Host "`nPo restarcie:" -ForegroundColor Cyan
    Write-Host "1. Uruchom Docker Desktop" -ForegroundColor White
    Write-Host "2. Uruchom ponownie ten skrypt: .\auto-setup.ps1" -ForegroundColor White
    Write-Host "3. Lub przejdź do następnych kroków ręcznie" -ForegroundColor White

    if (-not $Force) {
        $response = Read-Host "`nCzy zrestartować teraz? (y/N)"
        if ($response -eq "y" -or $response -eq "Y") {
            Write-Host "🔄 Restart systemu za 10 sekund..." -ForegroundColor Yellow
            Start-Sleep -Seconds 10
            Restart-Computer -Force
        }
    }
    exit 0
}

# Krok 6: Sprawdź projekt MORA4ME
Write-Step "Sprawdzanie projektu MORA4ME"
$projectPath = $PSScriptRoot
if (Test-Path "$projectPath\compose.yaml") {
    Write-Host "✅ Projekt MORA4ME znaleziony: $projectPath" -ForegroundColor Green
}
else {
    Write-Host "❌ Nie znaleziono pliku compose.yaml!" -ForegroundColor Red
    Write-Host "   Upewnij się, że skrypt jest uruchomiony w folderze projektu" -ForegroundColor Yellow
    exit 1
}

# Krok 7: Sprawdź czy Docker Desktop działa
Write-Step "Sprawdzanie Docker Desktop"
$dockerRetries = 0
$maxRetries = 3

do {
    try {
        $dockerInfo = docker info 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Docker Desktop działa poprawnie" -ForegroundColor Green
            break
        }
        else {
            $dockerRetries++
            if ($dockerRetries -le $maxRetries) {
                Write-Host "⚠️  Docker Desktop nie odpowiada (próba $dockerRetries/$maxRetries)" -ForegroundColor Yellow
                Write-Host "   Uruchamianie Docker Desktop..." -ForegroundColor Gray

                # Spróbuj uruchomić Docker Desktop
                Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
                Start-Sleep -Seconds 15
            }
        }
    }
    catch {
        $dockerRetries++
        if ($dockerRetries -le $maxRetries) {
            Write-Host "⚠️  Błąd Docker (próba $dockerRetries/$maxRetries)" -ForegroundColor Yellow
            Start-Sleep -Seconds 10
        }
    }
} while ($dockerRetries -le $maxRetries -and $LASTEXITCODE -ne 0)

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker Desktop nie działa!" -ForegroundColor Red
    Write-Host "   Uruchom Docker Desktop ręcznie i spróbuj ponownie" -ForegroundColor Yellow
    Write-Host "   Lub uruchom: .\auto-setup.ps1 -Force" -ForegroundColor Yellow
    exit 1
}

# Krok 8: Uruchom środowisko MORA4ME
Write-Step "Uruchamianie środowiska MORA4ME"
try {
    Write-Host "📦 Pobieranie obrazów Docker (może zająć kilka minut)..." -ForegroundColor Yellow
    docker-compose pull

    Write-Host "🚀 Uruchamianie kontenerów..." -ForegroundColor Yellow
    docker-compose up -d

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Środowisko MORA4ME zostało uruchomione!" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Błąd uruchamiania środowiska" -ForegroundColor Red
        Write-Host "   Sprawdź logi: docker-compose logs" -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "❌ Błąd uruchamiania: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Krok 9: Sprawdź status kontenerów
Write-Step "Sprawdzanie kontenerów"
Start-Sleep -Seconds 5
$containers = docker-compose ps
Write-Host $containers

# Krok 10: Instalacja zależności
Write-Step "Instalacja zależności"
try {
    Write-Host "📦 Instalowanie zależności PHP (Composer)..." -ForegroundColor Yellow
    docker-compose exec -T web composer install --no-interaction --optimize-autoloader

    Write-Host "📦 Instalowanie zależności JavaScript (NPM)..." -ForegroundColor Yellow
    docker-compose exec -T web npm install --silent

    Write-Host "✅ Zależności zostały zainstalowane" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  Błąd instalacji zależności: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "   Będzie możliwość ręcznej instalacji później" -ForegroundColor Gray
}

# Krok 11: Konfiguracja Shopware
Write-Step "Konfiguracja Shopware"
try {
    Write-Host "⚙️  Instalowanie systemu Shopware..." -ForegroundColor Yellow
    $installResult = docker-compose exec -T web bin/console system:install --create-database --basic-setup --force 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Shopware został skonfigurowany" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  Instalacja Shopware - sprawdź logi" -ForegroundColor Yellow
        Write-Host $installResult
    }
}
catch {
}
catch {
    Write-Host "⚠️  Błąd konfiguracji Shopware: $($_.Exception.Message)" -ForegroundColor Yellow
}
}

# Krok 12: Podsumowanie
Write-Step "🎉 INSTALACJA ZAKOŃCZONA!" "Green"
Write-Host ""
Write-Host "🌐 DOSTĘP DO APLIKACJI:" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host "• Sklep (Storefront):    http://localhost:8000" -ForegroundColor White
Write-Host "• Panel Admin:           http://localhost:8000/admin" -ForegroundColor White
Write-Host "• Dane logowania:        admin / shopware" -ForegroundColor White
Write-Host ""
Write-Host "🔧 PRZYDATNE KOMENDY:" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host "• Status:                docker-compose ps" -ForegroundColor White
Write-Host "• Logi:                  docker-compose logs" -ForegroundColor White
Write-Host "• Zatrzymaj:             docker-compose down" -ForegroundColor White
Write-Host "• Restart:               docker-compose restart" -ForegroundColor White
Write-Host ""
Write-Host "🎯 NASTĘPNE KROKI:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host "1. Otwórz VS Code: code ." -ForegroundColor White
Write-Host "2. Sprawdź http://localhost:8000" -ForegroundColor White
Write-Host "3. Zaloguj się do admin panelu" -ForegroundColor White
Write-Host "4. Rozpocznij development! 🚀" -ForegroundColor White
Write-Host ""
Write-Host "🤖 GitHub Copilot jest gotowy do użycia w VS Code!" -ForegroundColor Green
