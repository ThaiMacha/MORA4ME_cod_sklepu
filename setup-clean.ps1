# MORA4ME Auto-Setup Script
# Automatyczna instalacja i konfiguracja calego srodowiska

param(
    [switch]$Force,
    [switch]$SkipRestart,
    [switch]$Verbose
)

Write-Host "MORA4ME - Automatyczna Instalacja Srodowiska" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Sprawdz uprawnienia administratora
function Test-IsAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Uruchom jako administrator jesli potrzeba
if (-not (Test-IsAdmin)) {
    Write-Host "Skrypt wymaga uprawnien administratora..." -ForegroundColor Yellow
    Write-Host "Uruchamianie jako administrator..." -ForegroundColor Yellow

    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($Force) { $arguments += " -Force" }
    if ($SkipRestart) { $arguments += " -SkipRestart" }
    if ($Verbose) { $arguments += " -Verbose" }

    Start-Process PowerShell -ArgumentList $arguments -Verb RunAs -Wait
    exit
}

Write-Host "Uruchomiony z uprawnieniami administratora" -ForegroundColor Green

# Funkcja logowania
function Write-Step {
    param($Message, $Color = "Cyan")
    Write-Host "`n$Message" -ForegroundColor $Color
    Write-Host ("=" * $Message.Length) -ForegroundColor $Color
}

# Krok 1: Sprawdz Docker Desktop
Write-Step "Sprawdzanie Docker Desktop"
try {
    $dockerVersion = docker --version 2>$null
    if ($dockerVersion) {
        Write-Host "Docker Desktop: $dockerVersion" -ForegroundColor Green
    }
    else {
        Write-Host "Docker Desktop nie jest zainstalowany!" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "Docker Desktop nie jest dostepny!" -ForegroundColor Red
    exit 1
}

# Krok 2: Sprawdz WSL
Write-Step "Sprawdzanie WSL"
try {
    $wslStatus = wsl --status 2>$null
    Write-Host "WSL jest dostepny" -ForegroundColor Green
}
catch {
    Write-Host "WSL nie jest dostepny - wlaczanie..." -ForegroundColor Yellow
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-Host "WSL zostal wlaczony" -ForegroundColor Green
}

# Krok 3: Sprawdz dystrybucje WSL
Write-Step "Sprawdzanie dystrybucji WSL"
$wslList = wsl -l -v 2>$null
if ($LASTEXITCODE -ne 0 -or $wslList -match "nie ma zainstalowanych dystrybucji") {
    Write-Host "Instalowanie Ubuntu WSL..." -ForegroundColor Yellow

    try {
        Write-Host "Pobieranie Ubuntu..." -ForegroundColor Gray
        wsl --install Ubuntu --no-launch

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Ubuntu WSL zostal zainstalowany" -ForegroundColor Green
        }
        else {
            Write-Host "Blad instalacji Ubuntu WSL" -ForegroundColor Red
            Write-Host "Proba alternatywnej metody..." -ForegroundColor Yellow
            wsl --set-default-version 2
            wsl --install --distribution Ubuntu
        }
    }
    catch {
        Write-Host "Nie mozna zainstalowac Ubuntu WSL" -ForegroundColor Red
        Write-Host "Blad: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "Dystrybucja WSL juz zainstalowana" -ForegroundColor Green
    Write-Host $wslList
}

# Krok 4: Ustaw WSL 2 jako domyslna wersja
Write-Step "Konfiguracja WSL 2"
try {
    wsl --set-default-version 2
    Write-Host "WSL 2 ustawiony jako domyslny" -ForegroundColor Green
}
catch {
    Write-Host "Nie mozna ustawic WSL 2 jako domyslnego" -ForegroundColor Yellow
}

# Krok 5: Sprawdz czy potrzebny restart
Write-Step "Sprawdzanie koniecznosci restartu"
$needsRestart = $false

try {
    $wslTest = wsl echo "test" 2>$null
    if ($LASTEXITCODE -ne 0) {
        $needsRestart = $true
        Write-Host "WSL wymaga restartu systemu" -ForegroundColor Yellow
    }
}
catch {
    $needsRestart = $true
}

if ($needsRestart -and -not $SkipRestart) {
    Write-Host "`nWYMAGANY RESTART SYSTEMU" -ForegroundColor Red
    Write-Host "WSL wymaga restartu aby dzialac poprawnie." -ForegroundColor Yellow
    Write-Host "`nPo restarcie:" -ForegroundColor Cyan
    Write-Host "1. Uruchom Docker Desktop" -ForegroundColor White
    Write-Host "2. Uruchom ponownie: .\auto-setup.ps1" -ForegroundColor White

    if (-not $Force) {
        $response = Read-Host "`nCzy zrestartowac teraz? (y/N)"
        if ($response -eq "y" -or $response -eq "Y") {
            Write-Host "Restart systemu za 10 sekund..." -ForegroundColor Yellow
            Start-Sleep -Seconds 10
            Restart-Computer -Force
        }
    }
    exit 0
}

# Krok 6: Sprawdz projekt MORA4ME
Write-Step "Sprawdzanie projektu MORA4ME"
$projectPath = $PSScriptRoot
if (Test-Path "$projectPath\compose.yaml") {
    Write-Host "Projekt MORA4ME znaleziony: $projectPath" -ForegroundColor Green
}
else {
    Write-Host "Nie znaleziono pliku compose.yaml!" -ForegroundColor Red
    exit 1
}

# Krok 7: Sprawdz czy Docker Desktop dziala
Write-Step "Sprawdzanie Docker Desktop"
$dockerRetries = 0
$maxRetries = 3

do {
    try {
        $dockerInfo = docker info 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Docker Desktop dziala poprawnie" -ForegroundColor Green
            break
        }
        else {
            $dockerRetries++
            if ($dockerRetries -le $maxRetries) {
                Write-Host "Docker Desktop nie odpowiada (proba $dockerRetries/$maxRetries)" -ForegroundColor Yellow
                Write-Host "Uruchamianie Docker Desktop..." -ForegroundColor Gray

                Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
                Start-Sleep -Seconds 15
            }
        }
    }
    catch {
        $dockerRetries++
        if ($dockerRetries -le $maxRetries) {
            Write-Host "Blad Docker (proba $dockerRetries/$maxRetries)" -ForegroundColor Yellow
            Start-Sleep -Seconds 10
        }
    }
} while ($dockerRetries -le $maxRetries -and $LASTEXITCODE -ne 0)

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker Desktop nie dziala!" -ForegroundColor Red
    Write-Host "Uruchom Docker Desktop recznie i sprobuj ponownie" -ForegroundColor Yellow
    exit 1
}

# Krok 8: Uruchom srodowisko MORA4ME
Write-Step "Uruchamianie srodowiska MORA4ME"
try {
    Write-Host "Pobieranie obrazow Docker (moze zajac kilka minut)..." -ForegroundColor Yellow
    docker-compose pull

    Write-Host "Uruchamianie kontenerow..." -ForegroundColor Yellow
    docker-compose up -d

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Srodowisko MORA4ME zostalo uruchomione!" -ForegroundColor Green
    }
    else {
        Write-Host "Blad uruchamiania srodowiska" -ForegroundColor Red
        Write-Host "Sprawdz logi: docker-compose logs" -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "Blad uruchamiania: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Krok 9: Sprawdz status kontenerow
Write-Step "Sprawdzanie kontenerow"
Start-Sleep -Seconds 10
$containers = docker-compose ps
Write-Host $containers

# Krok 10: Instalacja zaleznosci
Write-Step "Instalacja zaleznosci"
try {
    Write-Host "Instalowanie zaleznosci PHP (Composer)..." -ForegroundColor Yellow
    docker-compose exec -T web composer install --no-interaction --optimize-autoloader

    Write-Host "Zaleznosci zostaly zainstalowane" -ForegroundColor Green
}
catch {
    Write-Host "Blad instalacji zaleznosci: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Krok 11: Konfiguracja Shopware
Write-Step "Konfiguracja Shopware"
try {
    Write-Host "Instalowanie systemu Shopware..." -ForegroundColor Yellow
    docker-compose exec -T web bin/console system:install --create-database --basic-setup --force

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Shopware zostal skonfigurowany" -ForegroundColor Green
    }
    else {
        Write-Host "Instalacja Shopware - sprawdz logi" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Blad konfiguracji Shopware: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Krok 12: Podsumowanie
Write-Step "INSTALACJA ZAKONCZONA!" "Green"
Write-Host ""
Write-Host "DOSTEP DO APLIKACJI:" -ForegroundColor Cyan
Write-Host "Sklep (Storefront):    http://localhost:8000" -ForegroundColor White
Write-Host "Panel Admin:           http://localhost:8000/admin" -ForegroundColor White
Write-Host "Dane logowania:        admin / shopware" -ForegroundColor White
Write-Host ""
Write-Host "PRZYDATNE KOMENDY:" -ForegroundColor Cyan
Write-Host "Status:                docker-compose ps" -ForegroundColor White
Write-Host "Logi:                  docker-compose logs" -ForegroundColor White
Write-Host "Zatrzymaj:             docker-compose down" -ForegroundColor White
Write-Host "Restart:               docker-compose restart" -ForegroundColor White
Write-Host ""
Write-Host "NASTEPNE KROKI:" -ForegroundColor Cyan
Write-Host "1. Otworz VS Code: code ." -ForegroundColor White
Write-Host "2. Sprawdz http://localhost:8000" -ForegroundColor White
Write-Host "3. Zaloguj sie do admin panelu" -ForegroundColor White
Write-Host "4. Rozpocznij development!" -ForegroundColor White
Write-Host ""
Write-Host "GitHub Copilot jest gotowy do uzycia w VS Code!" -ForegroundColor Green
