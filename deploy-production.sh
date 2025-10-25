#!/bin/bash
# MORA4ME Production Server Deployment Script
# Server: 57.128.225.66:2233

set -e

echo "🚀 MORA4ME Production Deployment Starting..."
echo "Server: 57.128.225.66:2233"
echo "Time: $(date)"

# Configuration
DOMAIN=${DOMAIN:-"sklep.mora4me.com"}
EMAIL=${EMAIL:-"admin@mora4me.com"}
DB_PASSWORD=${DB_PASSWORD:-"shopwarepass"}

echo "📋 Configuration:"
echo "Domain: $DOMAIN"
echo "Email: $EMAIL"
echo "DB Password: [GENERATED]"

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "📦 Installing required packages..."
sudo apt install -y curl wget git unzip software-properties-common

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ubuntu
    echo "Docker installed successfully"
else
    echo "Docker already installed"
fi

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully"
else
    echo "Docker Compose already installed"
fi

# Create application directory
echo "📁 Setting up application directory..."
sudo mkdir -p /var/www/mora4me
sudo chown ubuntu:ubuntu /var/www/mora4me
cd /var/www/mora4me

# Clone repository if not exists
if [ ! -d ".git" ]; then
    echo "📥 Cloning MORA4ME repository..."
    git clone https://github.com/ThaiMacha/MORA4ME_cod_sklepu.git .
else
    echo "📥 Updating repository..."
    git pull origin trunk
fi

# Setup production environment
echo "⚙️  Setting up production environment..."
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
TRUSTED_PROXIES=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
COMPOSER_HOME=/tmp/composer
SHOPWARE_ES_ENABLED=1
SHOPWARE_ES_INDEXING_ENABLED=1
SHOPWARE_ES_INDEX_PREFIX=mora4me
SHOPWARE_HTTP_CACHE_ENABLED=1
SHOPWARE_HTTP_DEFAULT_TTL=7200
EOF

# Setup production docker-compose
echo "🐳 Setting up production Docker configuration..."
cat > docker-compose.prod.yml << EOF
version: '3.8'

services:
  web:
    image: ghcr.io/shopware/docker-dev:php8.4-node24-caddy
    ports:
      - "8080:8000"  # Apache już używa portu 80/443
      - "8443:443"   # Alternatywny port HTTPS
    volumes:
      - .:/var/www/html:cached
      - caddy_data:/data
      - caddy_config:/config
      - composer_cache:/tmp/composer
    environment:
      - CADDY_DOMAIN=${DOMAIN}
      - CADDY_EMAIL=${EMAIL}
      - COMPOSER_HOME=/tmp/composer
    env_file:
      - .env.prod
    depends_on:
      database:
        condition: service_healthy
      valkey:
        condition: service_started
      opensearch:
        condition: service_started
    restart: unless-stopped
    networks:
      - mora4me_network

  database:
    image: mariadb:10.11
    ports:
      - "3307:3306"  # Port 3306 może być zajęty przez inne usługi
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_DATABASE: shopware
      MYSQL_USER: shopware
      MYSQL_PASSWORD: ${DB_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
      - ./docker/mysql/custom.cnf:/etc/mysql/conf.d/custom.cnf
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10
    restart: unless-stopped
    networks:
      - mora4me_network

  valkey:
    image: valkey/valkey:alpine
    command: valkey-server --maxmemory 256mb --maxmemory-policy allkeys-lru
    volumes:
      - valkey_data:/data
    restart: unless-stopped
    networks:
      - mora4me_network

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
    networks:
      - mora4me_network

  mailer:
    image: axllent/mailpit
    ports:
      - "8025:8025"
    environment:
      - MP_SMTP_AUTH_ACCEPT_ANY=1
      - MP_SMTP_AUTH_ALLOW_INSECURE=1
    restart: unless-stopped
    networks:
      - mora4me_network

volumes:
  db_data:
    driver: local
  opensearch_data:
    driver: local
  valkey_data:
    driver: local
  caddy_data:
    driver: local
  caddy_config:
    driver: local
  composer_cache:
    driver: local

networks:
  mora4me_network:
    driver: bridge
EOF

# Create MySQL configuration
echo "🗄️  Setting up database configuration..."
mkdir -p docker/mysql
cat > docker/mysql/custom.cnf << EOF
[mysql]
default-character-set = utf8mb4

[mysqld]
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
sql_mode = ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
max_allowed_packet = 128M
innodb_buffer_pool_size = 1G
innodb_log_file_size = 512M
innodb_flush_method = O_DIRECT
EOF

# Start services
echo "🚀 Starting production services..."
docker-compose -f docker-compose.prod.yml down || true
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 60

# Install PHP dependencies
echo "📦 Installing PHP dependencies..."
docker-compose -f docker-compose.prod.yml exec -T web composer install --no-dev --optimize-autoloader --no-interaction

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
docker-compose -f docker-compose.prod.yml exec -T web npm install --prefix=/var/www/html/src/Administration/Resources/app/administration --production
docker-compose -f docker-compose.prod.yml exec -T web npm install --prefix=/var/www/html/src/Storefront/Resources/app/storefront --production

# Setup Shopware
echo "🛍️  Setting up Shopware..."
docker-compose -f docker-compose.prod.yml exec -T web bin/console system:install --create-database --basic-setup --force --no-interaction

# Build assets
echo "🎨 Building frontend assets..."
docker-compose -f docker-compose.prod.yml exec -T web npm run build --prefix=/var/www/html/src/Administration/Resources/app/administration
docker-compose -f docker-compose.prod.yml exec -T web npm run build --prefix=/var/www/html/src/Storefront/Resources/app/storefront

# Clear cache
echo "🧹 Clearing cache..."
docker-compose -f docker-compose.prod.yml exec -T web bin/console cache:clear --env=prod

# Set proper permissions
echo "🔒 Setting permissions..."
docker-compose -f docker-compose.prod.yml exec -T web chown -R www-data:www-data /var/www/html/var
docker-compose -f docker-compose.prod.yml exec -T web chown -R www-data:www-data /var/www/html/public
docker-compose -f docker-compose.prod.yml exec -T web chown -R www-data:www-data /var/www/html/files

# Save deployment info
echo "📝 Saving deployment information..."
cat > deployment-info.txt << EOF
MORA4ME Production Deployment
=============================
Date: $(date)
Server: 57.128.225.66:2233
Domain: ${DOMAIN}
Database Password: ${DB_PASSWORD}

Access URLs:
- Storefront: https://${DOMAIN}
- Admin Panel: https://${DOMAIN}/admin
- Mail Testing: http://${DOMAIN}:8025

Default Login:
- Username: admin
- Password: shopware

Docker Commands:
- Status: docker-compose -f docker-compose.prod.yml ps
- Logs: docker-compose -f docker-compose.prod.yml logs -f
- Restart: docker-compose -f docker-compose.prod.yml restart
- Stop: docker-compose -f docker-compose.prod.yml down
- Start: docker-compose -f docker-compose.prod.yml up -d

Backup Commands:
- Database: docker-compose -f docker-compose.prod.yml exec database mysqladump -u shopware -p${DB_PASSWORD} shopware > backup-\$(date +%Y%m%d).sql
- Files: tar -czf backup-files-\$(date +%Y%m%d).tar.gz var/ public/media/ public/thumbnail/
EOF

echo ""
echo "🎉 MORA4ME Production Deployment Completed Successfully!"
echo "========================================================="
echo "🌐 Storefront: https://${DOMAIN}"
echo "🔧 Admin Panel: https://${DOMAIN}/admin"
echo "📧 Mail Testing: http://${DOMAIN}:8025"
echo ""
echo "🔑 Default Admin Login:"
echo "   Username: admin"
echo "   Password: shopware"
echo ""
echo "📊 Server Status:"
docker-compose -f docker-compose.prod.yml ps
echo ""
echo "💾 Deployment info saved to: deployment-info.txt"
echo "🔒 Database password saved in deployment-info.txt"
echo ""
echo "✅ Deployment completed at: $(date)"
