#!/bin/bash

# MORA4ME VPS Setup Script
# Prepares Ubuntu VPS for Shopware deployment
# Usage: bash setup-vps.sh

set -e

echo "🚀 MORA4ME VPS Setup - Preparing server for mora4me.com"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root"
    exit 1
fi

# Update system
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
print_status "Installing required packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    fail2ban \
    ufw \
    htop \
    nginx \
    certbot \
    python3-certbot-nginx

# Install Docker
print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    print_success "Docker installed successfully"
else
    print_success "Docker already installed"
fi

# Install Docker Compose (standalone)
print_status "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose installed successfully"
else
    print_success "Docker Compose already installed"
fi

# Configure firewall
print_status "Configuring firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
print_success "Firewall configured"

# Configure fail2ban
print_status "Configuring fail2ban..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
print_success "Fail2ban configured"

# Create application user and directory
print_status "Creating application structure..."
sudo mkdir -p /home/mora4me
sudo chown $USER:$USER /home/mora4me

# Create shop directory
mkdir -p /home/mora4me/shop
cd /home/mora4me/shop

# Clone repository (you'll need to update this URL)
print_status "Cloning MORA4ME repository..."
if [ ! -d ".git" ]; then
    git clone https://github.com/ThaiMacha/MORA4ME_cod_sklepu.git .
    git checkout main
else
    git pull origin main
fi

# Create required directories
mkdir -p {media,logs,backups/mysql,backups/media,docker/nginx/ssl}

# Set proper permissions
sudo chown -R $USER:www-data /home/mora4me/shop
sudo chmod -R 755 /home/mora4me/shop

# Create backup script
print_status "Creating backup script..."
cat > /home/mora4me/backup.sh << 'EOF'
#!/bin/bash
# MORA4ME Backup Script

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/mora4me/backups"

# Database backup
docker-compose -f /home/mora4me/shop/docker-compose.prod.yml exec -T mysql mysqldump -u root -p$MYSQL_ROOT_PASSWORD shopware > $BACKUP_DIR/mysql/mora4me_$DATE.sql

# Media backup
rsync -av /home/mora4me/shop/media/ $BACKUP_DIR/media/

# Keep only last 7 days of backups
find $BACKUP_DIR/mysql -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR/media -mtime +7 -delete

echo "Backup completed: $DATE"
EOF

chmod +x /home/mora4me/backup.sh

# Setup daily backup cron job
print_status "Setting up daily backups..."
(crontab -l 2>/dev/null; echo "0 2 * * * /home/mora4me/backup.sh >> /home/mora4me/logs/backup.log 2>&1") | crontab -

# Create SSL certificate renewal cron job
print_status "Setting up SSL certificate renewal..."
(crontab -l 2>/dev/null; echo "0 0,12 * * * python3 -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q") | crontab -

# Initial SSL certificate setup (Let's Encrypt)
print_status "Setting up initial SSL certificate..."
read -p "Enter your domain (e.g., mora4me.com): " DOMAIN
read -p "Enter your email for SSL certificate: " EMAIL

if [ ! -z "$DOMAIN" ] && [ ! -z "$EMAIL" ]; then
    # Stop nginx if running
    sudo systemctl stop nginx 2>/dev/null || true
    
    # Get SSL certificate
    sudo certbot certonly --standalone --agree-tos --no-eff-email -m $EMAIL -d $DOMAIN -d www.$DOMAIN
    
    print_success "SSL certificate obtained for $DOMAIN"
else
    print_warning "Skipping SSL certificate setup. You can run it later with: sudo certbot --nginx"
fi

# Create environment file template
print_status "Creating environment template..."
cat > /home/mora4me/shop/.env.prod.template << 'EOF'
# MORA4ME Production Environment Variables
# Copy this file to .env.prod and fill in your values

APP_SECRET=your-32-character-secret-key-here
DB_PASSWORD=your-strong-database-password
MYSQL_ROOT_PASSWORD=your-strong-root-password
MAILER_URL=smtp://user:pass@smtp.example.com:587
APP_URL=https://mora4me.com

# Optional: Slack notifications
SLACK_WEBHOOK_URL=https://hooks.slack.com/your/webhook/url
EOF

# Setup log rotation
print_status "Setting up log rotation..."
sudo cat > /etc/logrotate.d/mora4me << 'EOF'
/home/mora4me/logs/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 mora4me mora4me
}
EOF

print_success "VPS setup completed successfully!"
echo ""
echo "🎉 Next Steps:"
echo "1. Copy .env.prod.template to .env.prod and fill in your values"
echo "2. Configure your domain DNS to point to this server"
echo "3. Run: docker-compose -f docker-compose.prod.yml up -d"
echo "4. Setup GitHub Actions secrets for automatic deployment"
echo ""
echo "📚 Important files:"
echo "- Application: /home/mora4me/shop"
echo "- Backups: /home/mora4me/backups"
echo "- Logs: /home/mora4me/logs"
echo ""
echo "🔧 Useful commands:"
echo "- View logs: docker-compose -f /home/mora4me/shop/docker-compose.prod.yml logs -f"
echo "- Restart: docker-compose -f /home/mora4me/shop/docker-compose.prod.yml restart"
echo "- Backup: /home/mora4me/backup.sh"
echo ""

# Reminder about Docker group
print_warning "Please log out and log back in for Docker group changes to take effect"
print_warning "Or run: newgrp docker"