#!/bin/bash
# MORA4ME Cloud Deployment Script

set -e

echo "🚀 MORA4ME Cloud Deployment Starting..."

# Configuration
DOMAIN=${DOMAIN:-"your-domain.com"}
EMAIL=${EMAIL:-"admin@your-domain.com"}
DB_PASSWORD=${DB_PASSWORD:-$(openssl rand -base64 32)}

# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
systemctl start docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Clone repository
git clone https://github.com/ThaiMacha/MORA4ME_cod_sklepu.git /var/www/mora4me
cd /var/www/mora4me

# Setup environment
cat > .env.prod << EOF
APP_ENV=prod
APP_SECRET=$(openssl rand -hex 32)
DATABASE_URL=mysql://shopware:${DB_PASSWORD}@database:3306/shopware
MAILER_URL=smtp://mailer:1025
REDIS_URL=redis://valkey:6379
OPENSEARCH_URL=http://opensearch:9200
INSTANCE_ID=$(openssl rand -hex 32)
JWT_PRIVATE_KEY_PASSPHRASE=$(openssl rand -base64 32)
APP_URL=https://${DOMAIN}
TRUSTED_PROXIES=127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
EOF

# Setup production docker-compose
cat > docker-compose.prod.yml << EOF
version: '3.8'

services:
  web:
    image: ghcr.io/shopware/docker-dev:php8.4-node24-caddy
    ports:
      - "80:8000"
      - "443:443"
    volumes:
      - .:/var/www/html:cached
      - caddy_data:/data
      - caddy_config:/config
    environment:
      - CADDY_DOMAIN=${DOMAIN}
      - CADDY_EMAIL=${EMAIL}
    depends_on:
      - database
      - valkey
      - opensearch
    restart: unless-stopped

  database:
    image: mariadb:latest
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_DATABASE: shopware
      MYSQL_USER: shopware
      MYSQL_PASSWORD: ${DB_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    restart: unless-stopped

  valkey:
    image: valkey/valkey:alpine
    restart: unless-stopped

  opensearch:
    image: opensearchproject/opensearch:2
    environment:
      - discovery.type=single-node
      - bootstrap.memory_lock=true
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m"
      - "DISABLE_INSTALL_DEMO_CONFIG=true"
      - "DISABLE_SECURITY_PLUGIN=true"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - opensearch_data:/usr/share/opensearch/data
    restart: unless-stopped

volumes:
  db_data:
  opensearch_data:
  caddy_data:
  caddy_config:
EOF

# Deploy
docker-compose -f docker-compose.prod.yml up -d

# Wait for services
sleep 30

# Install dependencies and setup Shopware
docker-compose -f docker-compose.prod.yml exec -T web composer install --no-dev --optimize-autoloader
docker-compose -f docker-compose.prod.yml exec -T web npm install --prefix=/var/www/html/src/Administration/Resources/app/administration
docker-compose -f docker-compose.prod.yml exec -T web npm install --prefix=/var/www/html/src/Storefront/Resources/app/storefront
docker-compose -f docker-compose.prod.yml exec -T web bin/console system:install --create-database --basic-setup --force

# Setup SSL and domain
echo "🎉 MORA4ME deployed successfully!"
echo "Domain: https://${DOMAIN}"
echo "Admin: https://${DOMAIN}/admin"
echo "Database Password: ${DB_PASSWORD}"
