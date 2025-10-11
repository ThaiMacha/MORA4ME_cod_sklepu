# 🚀 MORA4ME Shopware Development Setup

## 📋 Wymagania Wstępne

Przed rozpoczęciem upewnij się, że masz zainstalowane:

- **Docker Desktop** - [Download](https://www.docker.com/products/docker-desktop)
- **Git** - [Download](https://git-scm.com/downloads)
- **Visual Studio Code** - [Download](https://code.visualstudio.com/)
- **GitHub Copilot** (opcjonalnie) - [Subscribe](https://github.com/features/copilot)

## 🛠️ Konfiguracja Środowiska

### 1. Sklonuj Repozytorium
```bash
git clone https://github.com/ThaiMacha/MORA4ME_cod_sklepu.git
cd MORA4ME_cod_sklepu
```

### 2. Otwórz w VSCode
```bash
code .
```

### 3. Zainstaluj Zalecane Rozszerzenia VSCode

Po otwarciu projektu, VSCode automatycznie zaproponuje instalację rozszerzeń z pliku `.vscode/extensions.json`:

**Kluczowe rozszerzenia:**
- GitHub Copilot (ai assistance)
- PHP Intelephense (PHP IntelliSense)
- PHP Debug (Xdebug support)
- Vue Language Features (Volar)
- ESLint & Prettier
- Docker
- GitLens

### 4. Uruchom Środowisko Docker

#### Opcja A: Przez VSCode Task
1. Otwórz Command Palette (`Ctrl+Shift+P`)
2. Wpisz "Tasks: Run Task"
3. Wybierz "Setup: Complete Development Environment"

#### Opcja B: Ręcznie
```bash
# Start Docker containers
docker-compose up -d

# Install PHP dependencies
docker-compose exec php composer install

# Install Node.js dependencies (Administration)
cd src/Administration/Resources/app/administration
docker-compose exec node npm install

# Install Node.js dependencies (Storefront)
cd src/Storefront/Resources/app/storefront
docker-compose exec node npm install

# Setup Shopware database
docker-compose exec php bin/console system:install --create-database --basic-setup
```

## 🎯 Development Workflow

### Codzienne Uruchamianie

1. **Start Docker Environment:**
   ```bash
   docker-compose up -d
   ```

2. **Start Development Servers:**
   
   **Administration (Vue.js Hot Reload):**
   ```bash
   # W nowym terminalu
   cd src/Administration/Resources/app/administration
   npm run dev
   ```
   
   **Storefront (Webpack Watch):**
   ```bash
   # W nowym terminalu  
   cd src/Storefront/Resources/app/storefront
   npm run watch
   ```

### Adresy Środowiska

- **Frontend (Storefront):** http://localhost
- **Admin Panel:** http://localhost/admin
- **PhpMyAdmin:** http://localhost:8080
- **MailHog:** http://localhost:8025
- **OpenSearch Dashboards:** http://localhost:5601

### Debugowanie

#### PHP Debugging z Xdebug
1. Ustaw breakpoint w kodzie PHP
2. W VSCode, przejdź do Debug panel (`Ctrl+Shift+D`)
3. Wybierz "Listen for Xdebug (PHP)"
4. Kliknij Start Debugging (`F5`)
5. Odśwież stronę w przeglądarce

#### JavaScript Debugging
1. Ustaw breakpoint w Vue.js/JS kodzie
2. Użyj Chrome DevTools lub VSCode debugger
3. Skonfiguruj "Debug Jest Tests" dla testów

### Najczęstsze Komendy

#### Shopware Console
```bash
# Clear cache
docker-compose exec php bin/console cache:clear

# Database migration
docker-compose exec php bin/console database:migrate --all

# Plugin install
docker-compose exec php bin/console plugin:install --activate PluginName

# Theme compile
docker-compose exec php bin/console theme:compile
```

#### Code Quality
```bash
# PHP CS Fixer
docker-compose exec php vendor/bin/php-cs-fixer fix

# PHPStan analysis
docker-compose exec php vendor/bin/phpstan analyse

# ESLint (Administration)
cd src/Administration/Resources/app/administration
npm run lint:fix

# Run tests
docker-compose exec php vendor/bin/phpunit
```

## 🔧 VSCode Configuration

### GitHub Copilot Tips
1. **Włącz Copilot** w ustawieniach VSCode
2. **Użyj `Ctrl+Space`** dla sugestii
3. **Napisz komentarze** opisujące co chcesz zrobić
4. **Copilot Chat** (`Ctrl+Shift+I`) dla interaktywnej pomocy

### Skróty Klawiszowe
- `F5` - Start debugging
- `Ctrl+Shift+P` - Command Palette
- `Ctrl+Shift+D` - Debug panel
- `Ctrl+`` (backtick) - Toggle terminal
- `Ctrl+Shift+E` - Explorer panel

### Przydatne Snippety
VSCode automatycznie rozpozna struktur Shopware i zaproponuje snippety dla:
- Shopware Entity Definitions
- Vue.js Components
- Twig Templates
- Symfony Services

## 🧪 Testing

### PHP Tests
```bash
# Run all tests
docker-compose exec php vendor/bin/phpunit

# Run specific test
docker-compose exec php vendor/bin/phpunit tests/unit/Core/Framework/ExampleTest.php

# Run with coverage
docker-compose exec php vendor/bin/phpunit --coverage-html coverage/
```

### JavaScript Tests
```bash
# Administration tests
cd src/Administration/Resources/app/administration
npm run test

# Watch mode
npm run test:watch

# Coverage
npm run test:coverage
```

## 🚨 Troubleshooting

### Port Conflicts
Jeśli porty są zajęte, zmień je w `docker-compose.yml`:
```yaml
ports:
  - "8000:80"  # Change from 80 to 8000
```

### Permission Issues (Linux/Mac)
```bash
sudo chown -R $USER:$USER .
```

### Docker Issues
```bash
# Reset everything
docker-compose down -v
docker-compose up -d --build

# View logs
docker-compose logs -f php
```

### Cache Issues
```bash
# Clear all caches
docker-compose exec php bin/console cache:clear
docker-compose exec php bin/console cache:pool:clear cache.global_clearer
```

## 📚 Dokumentacja

- [Shopware Developer Docs](https://developer.shopware.com)
- [Vue.js 3 Guide](https://vuejs.org/guide/)
- [Symfony Documentation](https://symfony.com/doc)
- [Docker Compose Reference](https://docs.docker.com/compose/)

## 🆘 Pomoc

W przypadku problemów:
1. Sprawdź Docker logs: `docker-compose logs`
2. Sprawdź VSCode Output panel
3. Sprawdź GitHub Issues w repozytorium
4. Użyj GitHub Copilot Chat do pomocy z kodem

---
**Happy Coding! 🎉**