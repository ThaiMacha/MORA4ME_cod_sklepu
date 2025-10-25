# 🗄️ MORA4ME Database Quick Guide

## 📋 Parametry połączenia

### 🔧 Produkcyjne (bezpośrednie)
```
Host: 57.128.225.66
Port: 3306
Database: shopware
Username: shopware
Password: shopwarepass
URL: mysql://shopware:shopwarepass@57.128.225.66:3306/shopware
```

### 🏠 Lokalne (przez tunel SSH)
```
Host: 127.0.0.1
Port: 3306
Database: shopware
Username: shopware
Password: shopwarepass
URL: mysql://shopware:shopwarepass@127.0.0.1:3306/shopware
```

## 🚀 Szybkie komendy

### Uruchom tunel SSH
```powershell
.\db-tunnel.ps1 -Action start
```

### Sprawdź status tunelu
```powershell
.\db-tunnel.ps1 -Action status
```

### Zatrzymaj tunel
```powershell
.\db-tunnel.ps1 -Action stop
```

### Połącz się przez MySQL CLI
```powershell
# Przez tunel SSH
mysql -h 127.0.0.1 -P 3306 -u shopware -pshopwarepass shopware

# Bezpośrednio (jeśli port 3306 otwarty)
mysql -h 57.128.225.66 -P 3306 -u shopware -pshopwarepass shopware
```

## 🌐 Adminer (Web Interface)

### Przez serwer produkcyjny
```
URL: http://57.128.225.66:9080
Server: database
Username: shopware
Password: shopwarepass
Database: shopware
```

## 💾 Backup & Restore

### Backup przez SSH
```powershell
ssh production-server "cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml exec -T database mysqldump -u shopware -pshopwarepass shopware" > backup-$(Get-Date -Format "yyyyMMdd").sql
```

### Restore przez SSH
```powershell
Get-Content backup.sql | ssh production-server "cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml exec -T database mysql -u shopware -pshopwarepass shopware"
```

### Backup lokalny (przez tunel)
```powershell
# Uruchom tunel
.\db-tunnel.ps1 -Action start

# Backup
mysqldump -h 127.0.0.1 -P 3306 -u shopware -pshopwarepass shopware > backup-local.sql

# Restore
mysql -h 127.0.0.1 -P 3306 -u shopware -pshopwarepass shopware < backup-local.sql
```

## 🔧 Narzędzia GUI

### Zalecane aplikacje:
- **phpMyAdmin** (web)
- **MySQL Workbench** (desktop)
- **HeidiSQL** (Windows)
- **Sequel Pro** (Mac)
- **DBeaver** (cross-platform)

### Konfiguracja w narzędziach:
1. **Uruchom tunel**: `.\db-tunnel.ps1 -Action start`
2. **Host**: 127.0.0.1
3. **Port**: 3306
4. **Database**: shopware
5. **Username**: shopware
6. **Password**: shopwarepass

## ⚠️ Bezpieczeństwo

### Wytyczne:
- ✅ Używaj tunelu SSH dla bezpiecznego połączenia
- ✅ Nie udostępniaj hasła publicznie
- ✅ Regularnie rób backup bazy danych
- ❌ Unikaj bezpośrednich połączeń przez internet
- ❌ Nie pozostawiaj otwartych tuneli bez potrzeby

### Zmiana hasła:
```sql
-- Połącz się z bazą i wykonaj:
ALTER USER 'shopware'@'%' IDENTIFIED BY 'nowe-haslo';
FLUSH PRIVILEGES;
```

## 🐛 Rozwiązywanie problemów

### Tunel nie działa:
```powershell
# Sprawdź procesy SSH
Get-Process | Where-Object {$_.ProcessName -eq "ssh"}

# Zabij wszystkie tunele
.\db-tunnel.ps1 -Action stop

# Uruchom ponownie
.\db-tunnel.ps1 -Action start
```

### Błąd połączenia:
```powershell
# Test połączenia SSH
ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 ubuntu@57.128.225.66 "echo 'Connected'"

# Test portu
Test-NetConnection -ComputerName 127.0.0.1 -Port 3306
```

### Sprawdź status Docker na serwerze:
```powershell
ssh production-server "cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml ps"
```
