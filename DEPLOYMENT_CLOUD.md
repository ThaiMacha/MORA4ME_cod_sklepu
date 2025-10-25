# MORA4ME Cloud Deployment Guide

## Opcje wdrożenia w chmurze

### 1. DigitalOcean Droplet (Zalecane)

```bash
# 1. Utwórz Droplet Ubuntu 22.04 (minimum 2GB RAM)
# 2. Połącz się przez SSH
ssh root@your-server-ip

# 3. Uruchom deployment
curl -sSL https://raw.githubusercontent.com/ThaiMacha/MORA4ME_cod_sklepu/trunk/deploy-cloud.sh | bash
```

### 2. AWS EC2

```bash
# 1. Uruchom instancję EC2 Ubuntu 22.04 (t3.medium lub większa)
# 2. Skonfiguruj Security Groups (porty 80, 443, 22)
# 3. Połącz się przez SSH
ssh -i your-key.pem ubuntu@your-ec2-ip

# 4. Uruchom deployment
sudo su -
curl -sSL https://raw.githubusercontent.com/ThaiMacha/MORA4ME_cod_sklepu/trunk/deploy-cloud.sh | bash
```

### 3. Google Cloud Platform

```bash
# 1. Utwórz VM instance Ubuntu 22.04 (e2-standard-2)
# 2. Otwórz porty 80 i 443 w firewall
# 3. Połącz się przez SSH
gcloud compute ssh your-instance-name

# 4. Uruchom deployment
sudo su -
curl -sSL https://raw.githubusercontent.com/ThaiMacha/MORA4ME_cod_sklepu/trunk/deploy-cloud.sh | bash
```

### 4. Hetzner Cloud

```bash
# 1. Utwórz serwer Ubuntu 22.04 (CX21 lub większy)
# 2. Połącz się przez SSH
ssh root@your-hetzner-ip

# 3. Uruchom deployment
curl -sSL https://raw.githubusercontent.com/ThaiMacha/MORA4ME_cod_sklepu/trunk/deploy-cloud.sh | bash
```

## Konfiguracja przed wdrożeniem

### Ustaw zmienne środowiskowe:
```bash
export DOMAIN="your-shop-domain.com"
export EMAIL="admin@your-domain.com"
export DB_PASSWORD="secure-password-123"
```

### Wskaż domenę na serwer:
1. Ustaw rekordy DNS A na IP serwera
2. Opcjonalnie: ustaw CNAME www -> @

## Po wdrożeniu

### Dostęp do sklepu:
- **Storefront**: https://your-domain.com
- **Admin Panel**: https://your-domain.com/admin
- **Dane logowania**: admin / shopware

### Monitoring:
```bash
# Status kontenerów
docker ps

# Logi
docker-compose -f docker-compose.prod.yml logs -f

# Restart serwisów
docker-compose -f docker-compose.prod.yml restart
```

### Backup:
```bash
# Backup bazy danych
docker-compose -f docker-compose.prod.yml exec database mysqldump -u shopware -p shopware > backup.sql

# Backup plików
tar -czf files-backup.tar.gz var/
```

## Wymagania systemowe

### Minimalne:
- **CPU**: 2 vCPU
- **RAM**: 4GB
- **Dysk**: 20GB SSD
- **OS**: Ubuntu 22.04 LTS

### Zalecane produkcja:
- **CPU**: 4 vCPU
- **RAM**: 8GB
- **Dysk**: 50GB SSD
- **CDN**: Cloudflare
- **Backup**: Automatyczny

## Koszty miesięczne (orientacyjne)

| Provider | Konfiguracja | Cena |
|----------|--------------|------|
| DigitalOcean | 2GB/1vCPU | $12/miesiąc |
| Hetzner | 4GB/2vCPU | €4.90/miesiąc |
| AWS EC2 | t3.medium | ~$30/miesiąc |
| GCP | e2-standard-2 | ~$35/miesiąc |

## Wsparcie

Skrypt automatycznie:
- ✅ Instaluje Docker i Docker Compose
- ✅ Konfiguruje SSL certyfikaty (Let's Encrypt)
- ✅ Ustawia produkcyjną konfigurację
- ✅ Instaluje wszystkie zależności
- ✅ Inicjalizuje bazę danych
- ✅ Konfiguruje Caddy jako reverse proxy
