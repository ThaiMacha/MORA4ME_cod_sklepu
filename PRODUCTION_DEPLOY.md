# 🚀 MORA4ME Production Deployment Guide

## Informacje o serwerze
- **IP**: 57.128.225.66
- **Port SSH**: 2233
- **User**: ubuntu
- **SSH Key**: C:\Users\PC\.ssh\id_ed25519

## 🚀 Szybkie wdrożenie

### Opcja 1: Automatyczne wdrożenie (PowerShell)
```powershell
# Uruchom w PowerShell z katalogu projektu
.\deploy-windows.ps1 -Domain "twoja-domena.com" -Email "admin@twoja-domena.com"
```

### Opcja 2: Manualne wdrożenie
```powershell
# 1. Połącz się z serwerem
ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 ubuntu@57.128.225.66

# 2. Uruchom skrypt na serwerze
curl -sSL https://raw.githubusercontent.com/ThaiMacha/MORA4ME_cod_sklepu/trunk/deploy-production.sh | DOMAIN="twoja-domena.com" EMAIL="admin@twoja-domena.com" bash
```

### Opcja 3: Połączenie przez SSH alias
```powershell
# Po skonfigurowaniu SSH config możesz używać:
ssh production-server
# lub
ssh mora4me
```

## ⚙️ Konfiguracja przed wdrożeniem

### 1. Ustaw domenę (opcjonalne)
```bash
export DOMAIN="twoja-domena.com"
export EMAIL="admin@twoja-domena.com"
```

### 2. Wskaż domenę na serwer
Ustaw rekord DNS A dla Twojej domeny na IP: `57.128.225.66`

## 📋 Co zostanie zainstalowane

### Usługi Docker:
- ✅ **Shopware 6.7** (PHP 8.4 + Caddy)
- ✅ **MariaDB 10.11** (baza danych)
- ✅ **Valkey/Redis** (cache)
- ✅ **OpenSearch** (wyszukiwarka)
- ✅ **Mailpit** (testy email)
- ✅ **Caddy** (web server + SSL)

### Automatyczne konfiguracje:
- ✅ SSL certyfikaty (Let's Encrypt)
- ✅ Optymalizacje produkcyjne
- ✅ Cache i indeksowanie
- ✅ Backup scriptu
- ✅ Monitoring podstawowy

## 🌐 Dostęp po wdrożeniu

| Usługa | URL | Login |
|--------|-----|-------|
| **Storefront** | https://twoja-domena.com | - |
| **Admin Panel** | https://twoja-domena.com/admin | admin / shopware |
| **Mail Testing** | http://twoja-domena.com:8025 | - |

## 📊 Monitoring serwera

### Sprawdzenie statusu:
```bash
ssh production-server
cd /var/www/mora4me
docker-compose -f docker-compose.prod.yml ps
```

### Logi aplikacji:
```bash
ssh production-server
cd /var/www/mora4me
docker-compose -f docker-compose.prod.yml logs -f web
```

### Restart serwisów:
```bash
ssh production-server
cd /var/www/mora4me
docker-compose -f docker-compose.prod.yml restart
```

## 💾 Backup

### Backup bazy danych:
```bash
ssh production-server
cd /var/www/mora4me
docker-compose -f docker-compose.prod.yml exec database mysqladump -u shopware -p shopware > backup-$(date +%Y%m%d).sql
```

### Backup plików:
```bash
ssh production-server
cd /var/www/mora4me
tar -czf backup-files-$(date +%Y%m%d).tar.gz var/ public/media/ public/thumbnail/
```

## ⚡ Szybkie komendy

### Status serwera:
```powershell
ssh production-server "cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml ps"
```

### Restart kompletny:
```powershell
ssh production-server "cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml down && docker-compose -f docker-compose.prod.yml up -d"
```

### Aktualizacja kodu:
```powershell
ssh production-server "cd /var/www/mora4me && git pull origin trunk && docker-compose -f docker-compose.prod.yml restart web"
```

## 🔧 Rozwiązywanie problemów

### Problem z połączeniem SSH:
```powershell
# Sprawdź klucz SSH
ssh-add "C:\Users\PC\.ssh\id_ed25519"

# Test połączenia
ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 -v ubuntu@57.128.225.66
```

### Problem z domeną:
1. Sprawdź czy DNS wskazuje na serwer: `nslookup twoja-domena.com`
2. Sprawdź czy SSL się generuje: `ssh production-server "docker logs mora4me_web"`
3. Poczekaj do 10 minut na certyfikat SSL

### Problem z usługami:
```bash
# Sprawdź wszystkie kontenery
docker ps -a

# Restart konkretnej usługi
docker-compose -f docker-compose.prod.yml restart web

# Sprawdź logi błędów
docker-compose -f docker-compose.prod.yml logs web | grep -i error
```

## 📞 Wsparcie

W razie problemów sprawdź:
1. 🔍 Logi serwera w `/var/www/mora4me/deployment-info.txt`
2. 🐳 Status kontenerów Docker
3. 🌐 Ustawienia DNS domeny
4. 🔐 Konfigurację SSH
