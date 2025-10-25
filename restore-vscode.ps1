# 🔄 MORA4ME VS Code Session Restore Script
# Ten skrypt pomaga przywrócić ustawienia VS Code i Copilot po restarcie

param(
    [switch]$Force,
    [switch]$Verbose
)

Write-Host "🚀 MORA4ME VS Code Session Restore" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# Sprawdź czy VS Code jest uruchomiony
$vscodeProcess = Get-Process -Name "Code" -ErrorAction SilentlyContinue
if ($vscodeProcess) {
    Write-Host "⚠️  VS Code jest aktualnie uruchomiony." -ForegroundColor Yellow
    if (!$Force) {
        $response = Read-Host "Czy chcesz zamknąć VS Code i kontynuować? (y/N)"
        if ($response -ne "y" -and $response -ne "Y") {
            Write-Host "❌ Operacja anulowana." -ForegroundColor Red
            exit
        }
    }

    Write-Host "🔄 Zamykanie VS Code..." -ForegroundColor Yellow
    $vscodeProcess | Stop-Process -Force
    Start-Sleep -Seconds 3
}

# Ścieżki do konfiguracji
$workspaceRoot = $PSScriptRoot
$vscodeFolder = Join-Path $workspaceRoot ".vscode"
$workspaceFile = Join-Path $workspaceRoot "MORA4ME.code-workspace"

Write-Host "📁 Sprawdzanie struktury projektu..." -ForegroundColor Cyan

# Sprawdź czy folder .vscode istnieje
if (!(Test-Path $vscodeFolder)) {
    Write-Host "❌ Folder .vscode nie istnieje!" -ForegroundColor Red
    exit 1
}

# Sprawdź czy plik workspace istnieje
if (!(Test-Path $workspaceFile)) {
    Write-Host "❌ Plik workspace nie istnieje!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Struktura projektu poprawna" -ForegroundColor Green

# Sprawdź zainstalowane rozszerzenia VS Code
Write-Host "🔍 Sprawdzanie rozszerzeń VS Code..." -ForegroundColor Cyan

$requiredExtensions = @(
    "GitHub.copilot",
    "GitHub.copilot-chat",
    "bmewburn.vscode-intelephense-client",
    "xdebug.php-debug",
    "vue.volar",
    "ms-azuretools.vscode-docker"
)

$installedExtensions = & code --list-extensions 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Nie można sprawdzić rozszerzeń. VS Code może nie być zainstalowany." -ForegroundColor Yellow
}
else {
    foreach ($extension in $requiredExtensions) {
        if ($installedExtensions -contains $extension) {
            Write-Host "✅ $extension" -ForegroundColor Green
        }
        else {
            Write-Host "❌ $extension (brak)" -ForegroundColor Red
            Write-Host "   Instalowanie..." -ForegroundColor Yellow
            & code --install-extension $extension --force
        }
    }
}

# Sprawdź ustawienia Copilot
Write-Host "🤖 Sprawdzanie konfiguracji GitHub Copilot..." -ForegroundColor Cyan

$userSettings = Join-Path $env:APPDATA "Code\User\settings.json"
if (Test-Path $userSettings) {
    $settings = Get-Content $userSettings -Raw | ConvertFrom-Json
    if ($settings.'github.copilot.enable') {
        Write-Host "✅ GitHub Copilot włączony" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  GitHub Copilot może być wyłączony" -ForegroundColor Yellow
    }
}
else {
    Write-Host "⚠️  Nie znaleziono globalnych ustawień VS Code" -ForegroundColor Yellow
}

# Ustaw zmienne środowiskowe dla Docker
Write-Host "🐳 Konfigurowanie zmiennych środowiskowych..." -ForegroundColor Cyan

$env:COMPOSE_PROJECT_NAME = "mora4me"
$env:DOCKER_BUILDKIT = "1"

Write-Host "✅ Zmienne środowiskowe ustawione" -ForegroundColor Green

# Sprawdź status Docker
Write-Host "🐳 Sprawdzanie statusu Docker..." -ForegroundColor Cyan

try {
    $dockerInfo = docker info 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker jest uruchomiony" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Docker nie jest uruchomiony" -ForegroundColor Red
        Write-Host "   Uruchom Docker Desktop przed kontynuowaniem" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "❌ Docker nie jest zainstalowany lub niedostępny" -ForegroundColor Red
}

# Sprawdź czy projekt Docker jest uruchomiony
try {
    $composeStatus = docker-compose ps -q 2>$null
    if ($composeStatus) {
        Write-Host "✅ Kontener projektowy jest uruchomiony" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  Kontener projektowy nie jest uruchomiony" -ForegroundColor Yellow
        $response = Read-Host "Czy chcesz uruchomić środowisko Docker? (y/N)"
        if ($response -eq "y" -or $response -eq "Y") {
            Write-Host "🚀 Uruchamianie środowiska Docker..." -ForegroundColor Yellow
            docker-compose up -d
        }
    }
}
catch {
    Write-Host "⚠️  Nie można sprawdzić statusu Docker Compose" -ForegroundColor Yellow
}

# Uruchom VS Code z workspace
Write-Host "🚀 Uruchamianie VS Code..." -ForegroundColor Green

if ($Verbose) {
    Write-Host "   Workspace: $workspaceFile" -ForegroundColor Gray
    Write-Host "   Folder: $vscodeFolder" -ForegroundColor Gray
}

# Uruchom VS Code z workspace
Start-Process "code" -ArgumentList "`"$workspaceFile`"" -NoNewWindow

Write-Host ""
Write-Host "🎉 VS Code został uruchomiony z konfiguracją MORA4ME!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Sprawdź czy:" -ForegroundColor Cyan
Write-Host "   • GitHub Copilot działa poprawnie" -ForegroundColor White
Write-Host "   • Wszystkie panele są otwarte" -ForegroundColor White
Write-Host "   • Terminal ma poprawną konfigurację" -ForegroundColor White
Write-Host "   • Rozszerzenia są załadowane" -ForegroundColor White
Write-Host ""
Write-Host "💡 Jeśli masz problemy, uruchom: .\restore-vscode.ps1 -Force -Verbose" -ForegroundColor Yellow
