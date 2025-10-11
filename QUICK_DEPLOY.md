# 🚀 MORA4ME - Quick Deployment Guide

> **5-Step deployment guide for MORA4ME shop to cloud**

## ✅ Prerequisites

- VPS/Cloud server (Ubuntu 22.04)
- Domain: mora4me.com pointed to your VPS
- SSH access to server

## 🚀 Step 1: VPS Setup (5 minutes)

```bash
# Connect to your VPS
ssh root@YOUR_VPS_IP

# Create user
adduser mora4me
usermod -aG sudo mora4me
su - mora4me

# Run automated setup
wget https://raw.githubusercontent.com/ThaiMacha/MORA4ME_cod_sklepu/main/setup-vps.sh
chmod +x setup-vps.sh
./setup-vps.sh
```

## 🌐 Step 2: Domain Configuration (2 minutes)

Set DNS records for mora4me.com:
```
A       @       YOUR_VPS_IP
A       www     YOUR_VPS_IP
```

## 🔐 Step 3: SSL Certificate (2 minutes)

```bash
sudo certbot --nginx -d mora4me.com -d www.mora4me.com
```

## ⚙️ Step 4: Shop Configuration (3 minutes)

```bash
cd /home/mora4me/shop
cp .env.prod.template .env.prod
nano .env.prod  # Configure your settings
```

Required settings:
- `APP_SECRET` - Generate 32-character random string
- `DB_PASSWORD` - Strong database password
- `MYSQL_ROOT_PASSWORD` - Strong root password
- `MAILER_URL` - Your SMTP settings

## 🚢 Step 5: Deploy Shop (5 minutes)

```bash
# Start containers
docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d

# Wait 2-3 minutes, then initialize
docker-compose -f docker-compose.prod.yml exec php bin/console system:install --create-database --basic-setup --force
docker-compose -f docker-compose.prod.yml exec php bin/console database:migrate --all
docker-compose -f docker-compose.prod.yml exec php bin/console user:create admin --admin --email=admin@mora4me.com --password=ChangeMe123!
docker-compose -f docker-compose.prod.yml exec php bin/console cache:clear --env=prod
```

## ✅ Verification

Visit your shop:
- **Storefront**: https://mora4me.com
- **Admin**: https://mora4me.com/admin (admin / ChangeMe123!)

## 🔄 Automatic Updates (Optional)

Configure GitHub Actions for auto-deployment:

1. Fork this repository
2. Add secrets in GitHub Settings:
   - `VPS_HOST` - Your VPS IP
   - `VPS_USER` - mora4me
   - `VPS_SSH_KEY` - Your private SSH key
   - Other environment variables

3. Push changes → Auto-deploy! 🎉

## 🆘 Need Help?

- **Full Guide**: [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- **Troubleshooting**: Check container logs
- **Support**: GitHub Issues

---

**Total time: ~15 minutes** ⏱️  
**Your shop is ready!** 🛍️