# Instrukcje Bezpieczeństwa i Konserwacji - MORA4ME VPS

## 🔒 Status Bezpieczeństwa - ZAKOŃCZONE ✅

### Firewall UFW - Skonfigurowany
```bash
Status: active

Dozwolone porty:
- 2233/tcp  # SSH (niestandardowy port)
- 80/tcp    # HTTP
- 443/tcp   # HTTPS
- 8080/tcp  # Apache backend
- 8501/tcp  # Nextcloud (wewnętrzny)
```

### Backup Klucza SSH - Utworzony ✅
- Lokalizacja: `C:\Users\PC\Desktop\backup_bezpieczne_miejsce\`
- Plik: `id_ed25519_backup_2025-10-25`
- **UWAGA**: Przechowuj w bezpiecznym miejscu!

### Aktualizacje Systemu - Zakończone ✅
- Ubuntu 24.04.3 LTS (Noble)
- Docker 28.2.2 (najnowsza wersja)
- Wszystkie pakiety zaktualizowane

## 📊 Status Systemu

### Zasoby Serwera
```
Dysk: 50GB/96GB użyte (52%)
RAM: 1.1GB/11GB użyte
Uptime: 19 godzin
Load average: 0.20 (niski)
```

### Usługi Działające
- ✅ Apache 2.4 (port 8080)
- ✅ Caddy Proxy (porty 80, 443)
- ✅ SSH (port 2233)
- ✅ 6 kontenerów Docker (Nextcloud, Shopware)

## 🔧 Rutynowa Konserwacja

### Codziennie
```bash
# Sprawdzenie statusu usług
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66 \
  "systemctl status apache2 caddy docker"

# Sprawdzenie logów błędów
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66 \
  "sudo tail -20 /var/log/apache2/error.log"
```

### Tygodniowo
```bash
# Aktualizacje bezpieczeństwa
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66 \
  "sudo apt update && sudo apt upgrade -y"

# Sprawdzenie miejsca na dysku
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66 \
  "df -h && docker system df"

# Czyszczenie starych logów Docker
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66 \
  "docker system prune -f"
```

### Miesięcznie
```bash
# Backup bazy danych
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66 \
  "docker exec nextcloud_db_1 mysqldump -u root -p --all-databases > /home/ubuntu/backup_$(date +%Y%m%d).sql"

# Backup konfiguracji
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66 \
  "tar -czf /home/ubuntu/config_backup_$(date +%Y%m%d).tar.gz /etc/apache2/ /home/ubuntu/nextcloud/"
```

## 🚨 Monitorowanie

### Alerty do Sprawdzenia

1. **Wykorzystanie dysku > 80%**
   ```bash
   df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
   ```

2. **Wysokie zużycie RAM > 8GB**
   ```bash
   free -m | awk 'NR==2 {print $3}'
   ```

3. **Load average > 2.0**
   ```bash
   uptime | awk '{print $10}' | sed 's/,//'
   ```

### Logi do Sprawdzenia
```bash
# Apache errors
sudo tail -f /var/log/apache2/error.log

# System logs
sudo journalctl -f -u apache2 -u docker

# Failed login attempts
sudo grep "Failed password" /var/log/auth.log | tail -10
```

## 🔐 Bezpieczeństwo

### Najlepsze Praktyki - WDROŻONE ✅

1. **SSH**: Niestandardowy port 2233
2. **Firewall**: Tylko niezbędne porty otwarte
3. **Klucze SSH**: Backup utworzony
4. **Aktualizacje**: Automatyczne security updates
5. **Docker**: Najnowsze wersje

### Dodatkowe Zalecenia

1. **Zmiana haseł co 3 miesiące**
   ```bash
   # Hasło bazy danych
   docker exec -it nextcloud_db_1 mysql -u root -p \
     -e "ALTER USER 'twoj_user'@'%' IDENTIFIED BY 'nowe_haslo';"
   ```

2. **Rotacja kluczy SSH co 6 miesięcy**
   ```bash
   ssh-keygen -t ed25519 -C "nowy-klucz-$(date +%Y%m%d)"
   ```

3. **Regular security scan**
   ```bash
   sudo apt install -y chkrootkit rkhunter
   sudo chkrootkit
   sudo rkhunter --check
   ```

## 📱 Kontakty Awaryjne

### W przypadku problemów:
1. **Brak dostępu SSH**: Użyj konsoli VPS od dostawcy
2. **Strona nie działa**: Sprawdź status Apache i Caddy
3. **Błędy bazy danych**: Zrestartuj kontener nextcloud_db_1
4. **Brak miejsca na dysku**: Wyczyść logi i stare backupy

### Komendy awaryjne:
```bash
# Restart wszystkich usług
sudo systemctl restart apache2 docker

# Restart kontenerów Docker
cd /home/ubuntu/nextcloud && docker-compose restart

# Przywrócenie z backupu
docker exec nextcloud_db_1 mysql -u root -p < backup_YYYYMMDD.sql
```

## 📈 Statystyki Projektu

### Bazy Danych
- `nextcloud`: Główna baza Nextcloud
- `twoj_projekt`: Baza dla custom projektu
- Użytkownik: `twoj_user` z ograniczonymi uprawnieniami

### Domeny i SSL
- `sklep.mora4me.com`: Shopware (SSL aktywny)
- `nextcloud.mora4me.com`: Nextcloud (SSL aktywny)
- `twoja-domena.com`: Custom projekt (wymaga konfiguracji DNS)

### Deployment
- GitHub Actions: Skonfigurowane
- Automatyczne wdrażanie z branch `trunk`
- Backup i rollback: Dostępny

---

**Ostatnia aktualizacja**: 25 października 2025
**Status**: ✅ SYSTEM ZABEZPIECZONY I GOTOWY DO PRODUKCJI
