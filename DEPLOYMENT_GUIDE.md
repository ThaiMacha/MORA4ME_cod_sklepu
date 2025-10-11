# 🚀 MORA4ME - Przewodnik Wdrożenia do Chmury

> **Kompleksowy przewodnik wdrożenia sklepu MORA4ME na VPS/Cloud**

## 🎯 Strategia Deployment

**Lokalne środowisko** - Rozwój i testowanie (masz gotowe)  
**Produkcja w chmurze** - Sklep mora4me.com dla klientów

## 📋 Wymagania VPS/Cloud

### Minimalne Wymagania
- **CPU**: 2 vCPU
- **RAM**: 4 GB
- **Storage**: 50 GB SSD
- **OS**: Ubuntu 22.04 LTS
- **Bandwidth**: Nielimitowany

### Zalecane dla Produkcji
- **CPU**: 4 vCPU
- **RAM**: 8 GB
- **Storage**: 100 GB SSD
- **Backup**: Automatyczny
- **CDN**: Cloudflare (opcjonalnie)

## 🛠️ Krok 1: Przygotowanie VPS

### 1.1 Łączenie z VPS
```bash
ssh root@YOUR_VPS_IP
```

### 1.2 Utworzenie użytkownika
```bash
adduser mora4me
usermod -aG sudo mora4me
su - mora4me
```

### 1.3 Konfiguracja SSH Key (zalecane)
```bash
# Na lokalnej maszynie
ssh-keygen -t rsa -b 4096 -C "admin@mora4me.com"
ssh-copy-id mora4me@YOUR_VPS_IP
```

### 1.4 Uruchomienie setup script
```bash
wget https://raw.githubusercontent.com/ThaiMacha/MORA4ME_cod_sklepu/main/setup-vps.sh
chmod +x setup-vps.sh
./setup-vps.sh
```

## 🌐 Krok 2: Konfiguracja Domeny

### 2.1 DNS Settings dla mora4me.com
```
Type    Name    Value               TTL
A       @       YOUR_VPS_IP         300
A       www     YOUR_VPS_IP         300
CNAME   *       mora4me.com         300
```

### 2.2 Weryfikacja DNS
```bash
dig mora4me.com
nslookup www.mora4me.com
```

## 🔐 Krok 3: SSL Certificate (Let's Encrypt)

### 3.1 Automatyczna konfiguracja SSL
```bash
sudo certbot --nginx -d mora4me.com -d www.mora4me.com
```

### 3.2 Test odnowienia certyfikatu
```bash
sudo certbot renew --dry-run
```

## 🚢 Krok 4: Deployment Sklepu

### 4.1 Konfiguracja zmiennych środowiskowych
```bash
cd /home/mora4me/shop
cp .env.prod.template .env.prod
nano .env.prod
```

Wypełnij wartości:
```env
APP_SECRET=twoj-32-znakowy-klucz-bezpieczenstwa
DB_PASSWORD=silne-haslo-bazy-danych
MYSQL_ROOT_PASSWORD=silne-haslo-root
MAILER_URL=smtp://user:pass@smtp.gmail.com:587
APP_URL=https://mora4me.com
```

### 4.2 Pierwsze uruchomienie
```bash
docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

### 4.3 Inicjalizacja sklepu
```bash
# Poczekaj 2-3 minuty na uruchomienie kontenerów

# Instalacja systemu
docker-compose -f docker-compose.prod.yml exec php bin/console system:install --create-database --basic-setup --force

# Migracje
docker-compose -f docker-compose.prod.yml exec php bin/console database:migrate --all

# Tworzenie admina
docker-compose -f docker-compose.prod.yml exec php bin/console user:create admin --admin --email=admin@mora4me.com --password=ZmieniMnie123!

# Cache
docker-compose -f docker-compose.prod.yml exec php bin/console cache:clear --env=prod

# Indeks wyszukiwania
docker-compose -f docker-compose.prod.yml exec php bin/console es:index
```

## ⚙️ Krok 5: GitHub Actions (Automatyczne Deployment)

### 5.1 Secrets w GitHub Repository
Dodaj w `Settings → Secrets and variables → Actions`:

```
VPS_HOST=your-vps-ip
VPS_USER=mora4me
VPS_SSH_KEY=-----BEGIN OPENSSH PRIVATE KEY-----...
VPS_PORT=22
APP_SECRET=twoj-32-znakowy-klucz
DB_PASSWORD=haslo-bazy
MYSQL_ROOT_PASSWORD=haslo-root
MAILER_URL=smtp://...
```

### 5.2 Testowanie Deployment
```bash
# W lokalnym repozytorium
git add .
git commit -m "Production deployment setup"
git push origin main
```

GitHub Actions automatycznie wdroży zmiany na VPS!

## 🔍 Krok 6: Weryfikacja

### 6.1 Sprawdzenie dostępności
- **Storefront**: https://mora4me.com
- **Admin Panel**: https://mora4me.com/admin
- **Health Check**: https://mora4me.com/health

### 6.2 Sprawdzenie kontenerów
```bash
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs -f
```

### 6.3 Monitoring wydajności
```bash
htop
docker stats
```

## 🗄️ Krok 7: Backup i Monitoring

### 7.1 Backup Configuration
Backup jest skonfigurowany automatycznie:
- **Baza danych**: Codziennie o 2:00
- **Media files**: Codziennie o 2:00
- **Lokalizacja**: `/home/mora4me/backups/`

### 7.2 Manual Backup
```bash
/home/mora4me/backup.sh
```

### 7.3 Przywracanie z backup
```bash
# Database restore
docker-compose -f docker-compose.prod.yml exec -T mysql mysql -u root -p$MYSQL_ROOT_PASSWORD shopware < /home/mora4me/backups/mysql/backup_file.sql

# Media restore
rsync -av /home/mora4me/backups/media/ /home/mora4me/shop/media/
```

## 🚀 Workflow Rozwoju

### 1. Lokalne środowisko
```bash
# Na lokalnej maszynie
cd MORA4ME_cod_sklepu
docker-compose up -d
# Rozwój funkcji...
```

### 2. Testowanie
```bash
# Testy lokalne
composer test
npm run test
```

### 3. Deployment
```bash
git add .
git commit -m "Nowa funkcja sklepu"
git push origin main
# GitHub Actions automatycznie wdroży na VPS
```

## 🔧 Przydatne Komendy

### Zarządzanie sklepem
```bash
# Restart sklepu
docker-compose -f /home/mora4me/shop/docker-compose.prod.yml restart

# Logi
docker-compose -f /home/mora4me/shop/docker-compose.prod.yml logs -f

# Update sklepu
cd /home/mora4me/shop && git pull && docker-compose -f docker-compose.prod.yml up -d --build

# Cache clear
docker-compose -f /home/mora4me/shop/docker-compose.prod.yml exec php bin/console cache:clear --env=prod

# Database console
docker-compose -f /home/mora4me/shop/docker-compose.prod.yml exec mysql mysql -u root -p

# PHP console
docker-compose -f /home/mora4me/shop/docker-compose.prod.yml exec php bash
```

### Monitoring
```bash
# Status kontenerów
docker ps

# Wykorzystanie zasobów
docker stats

# Przestrzeń dyskowa
df -h

# Logi Nginx
tail -f /var/log/nginx/mora4me_access.log
tail -f /var/log/nginx/mora4me_error.log
```

## 🆘 Troubleshooting

### Problem: Sklep nie działa
```bash
# Sprawdź status kontenerów
docker-compose -f docker-compose.prod.yml ps

# Sprawdź logi
docker-compose -f docker-compose.prod.yml logs

# Restart
docker-compose -f docker-compose.prod.yml restart
```

### Problem: SSL nie działa
```bash
# Sprawdź certyfikat
sudo certbot certificates

# Odnów certyfikat
sudo certbot renew

# Test konfiguracji Nginx
sudo nginx -t
```

### Problem: Baza danych
```bash
# Sprawdź połączenie
docker-compose -f docker-compose.prod.yml exec mysql mysql -u root -p -e "SHOW DATABASES;"

# Sprawdź logi MySQL
docker-compose -f docker-compose.prod.yml logs mysql
```

## 📞 Wsparcie

- **Dokumentacja**: README.md
- **Logi**: `/home/mora4me/logs/`
- **Backup**: `/home/mora4me/backups/`
- **GitHub Issues**: https://github.com/ThaiMacha/MORA4ME_cod_sklepu/issues

---

## 🎉 Gratulacje!

Twój sklep **MORA4ME** jest teraz dostępny pod adresem **https://mora4me.com**

### Następne kroki:
1. 🎨 **Kustomizacja** - Dodaj swoje produkty i dostosuj wygląd
2. 📊 **Analytics** - Skonfiguruj Google Analytics
3. 💳 **Płatności** - Skonfiguruj bramki płatności
4. 📦 **Shipping** - Skonfiguruj opcje dostawy
5. 🛡️ **Security** - Przejrzyj ustawienia bezpieczeństwa

**Happy selling! 🛍️**