# MORA4ME Database Configuration
# Konfiguracja połączeń z bazą danych

# ===========================================
# LOKALNE POŁĄCZENIE (przez tunel SSH)
# ===========================================
# Użyj gdy chcesz łączyć się lokalnie przez tunel SSH

# Parametry połączenia lokalnego
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=shopware
DB_USERNAME=shopware
DB_PASSWORD=shopwarepass

# Database URL dla Symfony (lokalne)
DATABASE_URL_LOCAL=mysql://shopware:shopwarepass@127.0.0.1:3306/shopware

# ===========================================
# BEZPOŚREDNIE POŁĄCZENIE PRODUKCYJNE
# ===========================================
# Użyj gdy łączysz się bezpośrednio do serwera VPS

# Parametry serwera produkcyjnego
PROD_DB_HOST=57.128.225.66
PROD_DB_PORT=3306
PROD_DB_DATABASE=shopware
PROD_DB_USERNAME=shopware
PROD_DB_PASSWORD=shopwarepass

# Database URL dla produkcji (bezpośrednie)
DATABASE_URL_PROD=mysql://shopware:shopwarepass@57.128.225.66:3306/shopware

# ===========================================
# TUNEL SSH DO BAZY DANYCH
# ===========================================
# Instrukcje utworzenia tunelu SSH

# 1. Utwórz tunel SSH (w osobnym terminalu):
# ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 -L 3306:localhost:3306 ubuntu@57.128.225.66

# 2. Po utworzeniu tunelu użyj parametrów lokalnych:
# Host: 127.0.0.1
# Port: 3306
# Database: shopware
# Username: shopware
# Password: shopwarepass

# ===========================================
# NARZĘDZIA BAZY DANYCH
# ===========================================

# Adminer (web interface)
ADMINER_URL=http://57.128.225.66:9080

# MySQL CLI przez SSH
# ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 ubuntu@57.128.225.66 "docker exec -it mora4me_database mysql -u shopware -p shopware"

# ===========================================
# SKRYPTY BACKUPU
# ===========================================

# Backup przez SSH
# ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 ubuntu@57.128.225.66 "cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml exec -T database mysqldump -u shopware -pshopwarepass shopware" > backup.sql

# Restore przez SSH
# cat backup.sql | ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 ubuntu@57.128.225.66 "cd /var/www/mora4me && docker-compose -f docker-compose.prod.yml exec -T database mysql -u shopware -pshopwarepass shopware"
