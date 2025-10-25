# 🏗️ MORA4ME Shopware Infrastructure Deploy

## 📋 Current Infrastructure
- **Nextcloud**: https://mora4me.com (existing on ports 80/443)
- **Shopware**: https://sklep.mora4me.com (new deployment)
- **Server**: 57.128.225.66:2233
- **Database**: Shopware will use port 3307 (separate from existing)

## ⚡ Quick Deploy Command

```powershell
# Deploy Shopware to your existing infrastructure
.\deploy-windows.ps1 -Domain "sklep.mora4me.com" -Email "admin@mora4me.com"
```

## 🔧 Post-Deploy: Update Caddy

Add to your existing Caddyfile:
```caddy
sklep.mora4me.com {
    reverse_proxy localhost:8080
    encode gzip

    header {
        -Server
        X-Content-Type-Options nosniff
        X-Frame-Options DENY
        X-XSS-Protection "1; mode=block"
    }
}
```

Restart Caddy:
```bash
sudo systemctl restart caddy
```

## 🗄️ Database Access

```powershell
# Start tunnel to Shopware database
.\shopware-tunnel.ps1 -Action start

# Connection details:
# Host: 127.0.0.1
# Port: 3306
# Database: shopware
# Username: shopware
# Password: shopwarepass
```

## 🌐 Final Access URLs

- **Nextcloud**: https://mora4me.com (unchanged)
- **Shopware Store**: https://sklep.mora4me.com
- **Shopware Admin**: https://sklep.mora4me.com/admin
- **Default Login**: admin / shopware

Ready to deploy? Run the command above! 🚀
