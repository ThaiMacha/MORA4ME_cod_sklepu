# 🐳 Docker Installation Verification Script
# Uruchom po instalacji Docker Desktop

Write-Host "🔍 Sprawdzanie instalacji Docker Desktop..." -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Test 1: Docker version
Write-Host "`n1️⃣ Sprawdzanie wersji Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker: $dockerVersion" -ForegroundColor Green
}
catch {
    Write-Host "❌ Docker nie jest dostępny w PATH" -ForegroundColor Red
    Write-Host "   Sprawdź czy Docker Desktop jest uruchomiony" -ForegroundColor Yellow
    exit 1
}

# Test 2: Docker Compose version
Write-Host "`n2️⃣ Sprawdzanie Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version
    Write-Host "✅ Docker Compose: $composeVersion" -ForegroundColor Green
}
catch {
    Write-Host "❌ Docker Compose nie jest dostępny" -ForegroundColor Red
    exit 1
}

# Test 3: Docker daemon status
Write-Host "`n3️⃣ Sprawdzanie Docker daemon..." -ForegroundColor Yellow
try {
    $dockerInfo = docker info --format "{{.ServerVersion}}" 2>$null
    if ($dockerInfo) {
        Write-Host "✅ Docker daemon działa (wersja: $dockerInfo)" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Docker daemon nie odpowiada" -ForegroundColor Red
        Write-Host "   Uruchom Docker Desktop i poczekaj na inicjalizację" -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "❌ Nie można połączyć się z Docker daemon" -ForegroundColor Red
    exit 1
}

# Test 4: Test kontener
Write-Host "`n4️⃣ Test uruchomienia kontenera..." -ForegroundColor Yellow
try {
    Write-Host "   Pobieranie hello-world image..." -ForegroundColor Gray
    $testResult = docker run --rm hello-world 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Test kontener uruchomiony pomyślnie" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Błąd uruchomienia test kontenera" -ForegroundColor Red
        Write-Host "   $testResult" -ForegroundColor Red
    }
}
catch {
    Write-Host "❌ Nie można uruchomić test kontenera" -ForegroundColor Red
}

# Test 5: Sprawdź resources
Write-Host "`n5️⃣ Sprawdzanie zasobów systemowych..." -ForegroundColor Yellow
try {
    $memory = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
    $memoryGB = [math]::Round($memory / 1GB, 1)

    if ($memoryGB -ge 8) {
        Write-Host "✅ RAM: $memoryGB GB (wystarczający)" -ForegroundColor Green
    }
    elseif ($memoryGB -ge 4) {
        Write-Host "⚠️  RAM: $memoryGB GB (minimalny)" -ForegroundColor Yellow
    }
    else {
        Write-Host "❌ RAM: $memoryGB GB (niewystarczający)" -ForegroundColor Red
    }
}
catch {
    Write-Host "⚠️  Nie można sprawdzić ilości RAM" -ForegroundColor Yellow
}

Write-Host "`n🎉 PODSUMOWANIE" -ForegroundColor Green
Write-Host "===============" -ForegroundColor Green
Write-Host "✅ Docker Desktop jest gotowy do użycia!" -ForegroundColor Green
Write-Host "✅ Można teraz uruchomić projekt MORA4ME" -ForegroundColor Green

Write-Host "`n📋 NASTĘPNE KROKI:" -ForegroundColor Cyan
Write-Host "1. Uruchom: docker-compose up -d" -ForegroundColor White
Write-Host "2. Poczekaj na pobranie obrazów (~5-10 min przy pierwszym uruchomieniu)" -ForegroundColor White
Write-Host "3. Otwórz: http://localhost:8000" -ForegroundColor White

Write-Host "`n💡 WSKAZÓWKI:" -ForegroundColor Yellow
Write-Host "• Docker Desktop musi być uruchomiony przed każdą pracą" -ForegroundColor Gray
Write-Host "• Pierwsze uruchomienie może zająć więcej czasu" -ForegroundColor Gray
Write-Host "• W razie problemów: docker-compose down && docker-compose up -d" -ForegroundColor Gray
