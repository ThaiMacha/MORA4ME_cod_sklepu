# GitHub Secrets Configuration for VPS Deployment

## Required Secrets

Add these secrets in your GitHub repository:
Settings → Secrets and variables → Actions → New repository secret

### SSH Configuration

- `SSH_PRIVATE_KEY`: Your private SSH key content (id_ed25519)
- `VPS_HOST`: 57.128.225.66
- `VPS_PORT`: 2233
- `VPS_USERNAME`: ubuntu

### Database Configuration (Optional)

- `DB_HOST`: localhost or nextcloud_db_1
- `DB_NAME`: twoj_projekt
- `DB_USER`: twoj_user
- `DB_PASSWORD`: twoje_haslo

## Setup Instructions

### 1. Generate SSH Key (if not exists)

```bash
ssh-keygen -t ed25519 -C "github-actions@yourdomain.com"
```

### 2. Copy public key to server

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub -p 2233 ubuntu@57.128.225.66
```

### 3. Add private key to GitHub Secrets

- Copy content of `~/.ssh/id_ed25519` (private key)
- Add as `SSH_PRIVATE_KEY` secret in GitHub

### 4. Test SSH connection

```bash
ssh -i ~/.ssh/id_ed25519 -p 2233 ubuntu@57.128.225.66
```

### 5. Initialize Git repository on server

```bash
cd /var/www/twoj-projekt
git init
git remote add origin https://github.com/username/repository.git
git fetch origin
git checkout main
```

## Workflow Features

### Basic Deployment (deploy.yml)

- Triggers on push to main branch
- Simple git pull and dependency installation
- Basic permission fixes

### Advanced Deployment (deploy-advanced.yml)

- Triggers on push to main/trunk or manual dispatch
- PHP and dependency validation
- Automatic testing
- Backup and rollback capability
- Health checks
- Support for Laravel/Symfony applications
- Comprehensive error handling

## Environment Variables

Create `.env.production` file on server with production settings:

```env
APP_ENV=production
APP_DEBUG=false
DB_HOST=nextcloud_db_1
DB_NAME=twoj_projekt
DB_USER=twoj_user
DB_PASSWORD=twoje_haslo
```

## Troubleshooting

### Common Issues

1. **Permission denied**: Check SSH key format and server access
2. **Git pull fails**: Ensure repository is initialized on server
3. **Composer fails**: Check PHP version and memory limits
4. **Apache reload fails**: Check sudo permissions for ubuntu user

### Logs

- GitHub Actions: Repository → Actions tab
- Server logs: `/var/log/apache2/error.log`
- Application logs: Check your app's log directory

## Security Notes

- Never commit sensitive data to repository
- Use environment-specific configuration files
- Regularly rotate SSH keys
- Monitor deployment logs for security issues
