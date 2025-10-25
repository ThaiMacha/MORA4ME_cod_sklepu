# MORA4ME Infrastructure Configuration
# Updated configuration for existing infrastructure

## 🏗️ Infrastructure Overview

### Main Services:
- **Nextcloud**: https://mora4me.com/
- **Shopware**: https://sklep.mora4me.com/
- **Admin Panel**: https://sklep.mora4me.com/admin

### Internal Ports:
- **Apache**: 8080 (existing)
- **MySQL/MariaDB**: 3306 (existing)
- **SSH**: 2233
- **HTTP**: 80 (Caddy - existing)
- **HTTPS**: 443 (Caddy - existing)

### New Shopware Ports:
- **Shopware Web**: 8080 (internal Docker)
- **Shopware DB**: 3307 (external access)
- **Shopware HTTPS**: 8443 (alternative)

## 🔄 Reverse Proxy Configuration

Since you already have Caddy running on ports 80/443 for Nextcloud, you'll need to add Shopware configuration to your existing Caddyfile:

### Add to existing Caddyfile:
```caddy
# Shopware subdomain
sklep.mora4me.com {
    reverse_proxy localhost:8080

    # Enable compression
    encode gzip

    # Security headers
    header {
        # Hide server info
        -Server

        # Security headers
        X-Content-Type-Options nosniff
        X-Frame-Options DENY
        X-XSS-Protection "1; mode=block"
        Referrer-Policy strict-origin-when-cross-origin

        # Cache control for static assets
        Cache-Control "public, max-age=31536000" {
            path *.css
            path *.js
            path *.png
            path *.jpg
            path *.jpeg
            path *.gif
            path *.svg
            path *.woff
            path *.woff2
        }
    }

    # Shopware specific rules
    @shopware {
        path /api/*
        path /admin/*
        path /recovery/*
        path /installer/*
    }

    # Longer timeout for admin operations
    reverse_proxy @shopware localhost:8080 {
        timeout 300s
    }

    # Handle PHP files
    @php {
        path *.php
    }

    reverse_proxy @php localhost:8080 {
        timeout 180s
    }

    # Logs
    log {
        output file /var/log/caddy/shopware.log {
            roll_size 100mb
            roll_keep 10
        }
    }
}
```

## 🗄️ Database Configuration

### Production Database (Shopware):
```env
Host: 57.128.225.66
Port: 3307 (external)
Database: shopware
Username: shopware
Password: shopwarepass
```

### SSH Tunnel (for development):
```bash
# New tunnel command for port 3307
ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 -L 3306:localhost:3307 ubuntu@57.128.225.66
```

## 🚀 Deployment Commands

### Updated deployment with correct domain:
```powershell
# Deploy Shopware to sklep.mora4me.com
.\deploy-windows.ps1 -Domain "sklep.mora4me.com" -Email "admin@mora4me.com"
```

### Database tunnel with new port:
```powershell
# Create tunnel to Shopware database (port 3307)
.\db-tunnel.ps1 -Action start -LocalPort 3306
```

## 🌐 DNS Configuration

### Required DNS records:
```dns
# A Records
mora4me.com.        A    57.128.225.66
sklep.mora4me.com.  A    57.128.225.66

# CNAME Records (optional)
www.mora4me.com.        CNAME    mora4me.com.
www.sklep.mora4me.com.  CNAME    sklep.mora4me.com.
```

## 🔒 Firewall Configuration

### Required open ports:
```bash
# Web traffic (existing)
80/tcp   # HTTP
443/tcp  # HTTPS

# SSH (existing)
2233/tcp # SSH

# New for Shopware
8080/tcp # Shopware container (internal only)
3307/tcp # MySQL external access (optional, for remote management)
```

## 📋 Service Integration Checklist

### Before deployment:
- [ ] Verify Caddy configuration includes Shopware rules
- [ ] Ensure DNS points sklep.mora4me.com to server
- [ ] Confirm port 8080 is available for Shopware
- [ ] Check that port 3307 is free for Shopware database

### After deployment:
- [ ] Test https://sklep.mora4me.com/ loads
- [ ] Verify https://sklep.mora4me.com/admin works
- [ ] Confirm SSL certificate generated correctly
- [ ] Test database connectivity via tunnel
- [ ] Verify logs in /var/log/caddy/shopware.log

## 🛠️ Monitoring & Maintenance

### Check all services:
```bash
# SSH to server
ssh production-server

# Check Caddy (existing)
systemctl status caddy

# Check Shopware containers
cd /var/www/mora4me
docker-compose -f docker-compose.prod.yml ps

# Check logs
docker-compose -f docker-compose.prod.yml logs -f web
```

### Restart services:
```bash
# Restart Caddy (if needed)
sudo systemctl restart caddy

# Restart Shopware
docker-compose -f docker-compose.prod.yml restart

# Restart specific service
docker-compose -f docker-compose.prod.yml restart web
```
