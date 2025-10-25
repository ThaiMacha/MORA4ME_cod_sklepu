# 🚀 MORA4ME Shopware Development Quick Reference

## 🏃‍♂️ Szybki Start

```bash
# 1. Uruchom środowisko Docker
docker-compose up -d

# 2. Zainstaluj zależności PHP
docker-compose exec php composer install

# 3. Uruchom migracje bazy danych
docker-compose exec php bin/console database:migrate --all

# 4. Skompiluj theme
docker-compose exec php bin/console theme:compile

# 5. Zainstaluj zależności JS (Administration)
cd src/Administration/Resources/app/administration
npm install
npm run build
```

## 🔗 Lokalne URLe

- **Shopware Frontend**: http://localhost:8000
- **Shopware Admin**: http://localhost:8000/admin
- **Adminer (DB Manager)**: http://localhost:8080
- **Redis Commander**: http://localhost:8081
- **OpenSearch**: http://localhost:9200

## 🎯 VSCode Tasks (Ctrl+Shift+P → "Tasks: Run Task")

- 🚀 **Start Shopware Development** - Uruchom wszystkie kontenery
- 🛑 **Stop Shopware Development** - Zatrzymaj kontenery
- 🧹 **Clear Shopware Cache** - Wyczyść cache
- 🧪 **Run PHP Tests** - Uruchom testy PHPUnit
- 🔍 **PHP Code Analysis** - Analiza PHPStan
- 🎯 **Fix PHP Code Style** - Naprawa stylu kodu

## 🐛 Debug Configuration

### PHP (Xdebug)
- Port: **9003**
- Path Mapping: `/var/www/html` → `${workspaceFolder}`

### JavaScript (Chrome DevTools)
- URL: **http://localhost:8000**
- Port: **9222**

## 🤖 GitHub Copilot Tips

### 💬 Chat Commands
```
@workspace What is the structure of this Shopware project?
/explain How does this PHP class work?
/fix Fix this PHP syntax error
/tests Generate PHPUnit tests for this class
/doc Generate documentation for this method
```

### 🎯 Code Generation Prompts
```php
// Create a Shopware plugin for product reviews
// Generate a Vue.js component for shopping cart
// Write a custom Twig extension for formatting prices
// Implement Redis caching for product search
// Create a custom field for products with validation
```

## 📊 Przydatne Komendy

### 🔧 Shopware Console
```bash
# Lista wszystkich komend
bin/console list

# Informacje o systemie
bin/console system:info

# Zarządzanie pluginami
bin/console plugin:list
bin/console plugin:install --activate PluginName
bin/console plugin:deactivate PluginName

# Cache management
bin/console cache:clear
bin/console cache:warmup

# Database
bin/console database:create
bin/console database:migrate --all
bin/console database:create-migration

# Themes
bin/console theme:list
bin/console theme:compile
bin/console theme:create

# Sales channels
bin/console sales-channel:list
bin/console sales-channel:create:storefront

# User management
bin/console user:create admin
bin/console user:change-password admin
```

### 🧪 Testing
```bash
# PHPUnit tests
vendor/bin/phpunit
vendor/bin/phpunit --group=unit
vendor/bin/phpunit --coverage-html coverage/

# PHPStan analysis
vendor/bin/phpstan analyse
vendor/bin/phpstan analyse --level=8 src/

# PHP CS Fixer
vendor/bin/php-cs-fixer fix
vendor/bin/php-cs-fixer fix --dry-run --diff

# Jest tests (Administration)
cd src/Administration/Resources/app/administration
npm run test
npm run test:coverage
```

### 🐳 Docker Shortcuts
```bash
# Logs
docker-compose logs -f php
docker-compose logs -f mysql

# Shell access
docker-compose exec php bash
docker-compose exec mysql mysql -u root -p

# Restart services
docker-compose restart php
docker-compose restart mysql
```

## 🚨 Troubleshooting

### ❌ Common Issues

**Problem**: Xdebug nie działa
```bash
# Sprawdź konfigurację Xdebug
docker-compose exec php php -m | grep xdebug
docker-compose exec php php -i | grep xdebug
```

**Problem**: Brak uprawnień do plików
```bash
# Napraw uprawnienia
sudo chown -R $(whoami):$(whoami) .
sudo chmod -R 755 var/
```

**Problem**: Cache nie działa
```bash
# Wyczyść wszystkie cache
rm -rf var/cache/*
bin/console cache:clear
```

**Problem**: Problemy z npm/node
```bash
# Wyczyść node_modules i reinstaluj
cd src/Administration/Resources/app/administration
rm -rf node_modules package-lock.json
npm install
```

### 🔍 Debug Tools

**PHP**:
- `dd($variable)` - Dump and die
- `dump($variable)` - Dump variable
- `$this->logger->info('message')` - Logging

**JavaScript**:
- `console.log()` - Console logging
- `debugger;` - Breakpoint
- Vue DevTools Chrome Extension

## 📱 Mobile Development

```bash
# Ngrok tunnel dla testów mobile
npx ngrok http 8000

# Test responsive design
# Chrome DevTools → Toggle Device Toolbar (Ctrl+Shift+M)
```

## 🔐 Environment Variables

Kopiuj `.env.example` do `.env` i skonfiguruj:

```bash
# Database
DATABASE_URL=mysql://shopware:shopware@mysql:3306/shopware

# App
APP_ENV=dev
APP_SECRET=your-secret-key

# Mailer
MAILER_DSN=null://localhost

# Redis
REDIS_URL=redis://redis:6379

# OpenSearch
OPENSEARCH_URL=http://opensearch:9200
```

---

*Quick Reference wygenerowany przez GitHub Copilot* 🤖