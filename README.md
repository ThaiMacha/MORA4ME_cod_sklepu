# 🛍️ MORA4ME - Shopware E-commerce Platform

> **Nowoczesny sklep internetowy oparty na Shopware 6 z pełną integracją GitHub Copilot i VSCode**

[![Shopware Version](https://img.shields.io/badge/Shopware-6.7-blue.svg)](https://www.shopware.com)
[![PHP Version](https://img.shields.io/badge/PHP-8.2+-purple.svg)](https://php.net)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![VSCode](https://img.shields.io/badge/VSCode-Optimized-blue.svg)](https://code.visualstudio.com)
[![GitHub Copilot](https://img.shields.io/badge/GitHub%20Copilot-Enabled-green.svg)](https://github.com/features/copilot)

## 🎯 Opis Projektu

MORA4ME to zaawansowany projekt sklepu internetowego zbudowany na platformie **Shopware 6** z wykorzystaniem najnowszych technologii i najlepszych praktyk developmentu. Projekt został specjalnie skonfigurowany do pracy z **GitHub Copilot** i **Visual Studio Code** dla maksymalnej produktywności podczas rozwoju.

### ✨ Kluczowe Cechy

- 🚀 **Shopware 6.7** - najnowsza wersja platformy e-commerce
- 🤖 **GitHub Copilot Integration** - AI-powered development assistance
- 🐳 **Docker Environment** - komplętne środowisko developerskie
- 🔧 **VSCode Optimized** - pre-configured workspace z extensions
- 🧪 **Testing Ready** - PHPUnit, Jest, Playwright setup
- 📊 **Code Quality** - PHP CS Fixer, PHPStan, ESLint
- 🔍 **Full Debug Support** - Xdebug, Chrome DevTools integration

## 🏗️ Architektura

```
MORA4ME/
├── 📁 src/
│   ├── 🏛️ Core/              # Business logic & framework
│   ├── 🎨 Administration/     # Admin UI (Vue.js 3 + TypeScript)
│   ├── 🌐 Storefront/         # Frontend (Twig + Bootstrap 5)
│   └── 🔍 Elasticsearch/      # Search integration
├── 🐳 docker/                 # Docker configuration
├── ⚙️ .vscode/                # VSCode settings & tasks
├── 🧪 tests/                  # Test suites
└── 📚 docs/                   # Documentation
```

## 🛠️ Stack Technologiczny

### Backend
- **PHP 8.2+** with modern extensions
- **Symfony 7.3** framework
- **Doctrine DBAL 4** (custom DAL, no ORM)
- **MySQL 8.0** / **MariaDB 10.11+**
- **Redis** caching
- **OpenSearch 2** / **Elasticsearch 8**

### Frontend
- **Administration**: Vue.js 3, TypeScript, Vite, Pinia
- **Storefront**: Twig, Bootstrap 5, SCSS, Webpack 5
- **Icons**: Custom SVG icon system

### Development
- **Docker** & **Docker Compose**
- **VSCode** with optimized configuration
- **GitHub Copilot** AI assistance
- **Xdebug** for PHP debugging
- **Hot Module Replacement** for fast development

## 🚀 Quick Start

### Wymagania
- **Docker Desktop** 4.0+
- **Git** 2.30+
- **VSCode** 1.80+
- **GitHub Copilot** (opcjonalnie)

### Automatyczna Instalacja

#### Windows (PowerShell)
```powershell
# Clone repository
git clone https://github.com/ThaiMacha/MORA4ME_cod_sklepu.git
cd MORA4ME_cod_sklepu

# Run setup script
.\setup.ps1
```

#### Linux/Mac (Bash)
```bash
# Clone repository
git clone https://github.com/ThaiMacha/MORA4ME_cod_sklepu.git
cd MORA4ME_cod_sklepu

# Make script executable and run
chmod +x setup.sh
./setup.sh
```

### Ręczna Instalacja
Zobacz szczegółowe instrukcje w [DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md)

## 🌐 Dostęp do Aplikacji

Po uruchomieniu środowiska:

| Service | URL | Credentials |
|---------|-----|-------------|
| **Storefront** | http://localhost | - |
| **Admin Panel** | http://localhost/admin | admin / shopware |
| **PhpMyAdmin** | http://localhost:8080 | root / root |
| **MailHog** | http://localhost:8025 | - |
| **OpenSearch** | http://localhost:5601 | - |

## 💻 Development Workflow

### 1. Uruchom środowisko
```bash
docker-compose up -d
```

### 2. Start development servers

**Administration (Hot Reload)**
```bash
cd src/Administration/Resources/app/administration
npm run dev
```

**Storefront (Watch Mode)**
```bash
cd src/Storefront/Resources/app/storefront
npm run watch
```

### 3. VSCode Setup
```bash
# Otwórz projekt w VSCode
code .

# Zainstaluj zalecane rozszerzenia (automatycznie)
# GitHub Copilot będzie gotowy do użycia
```

## 🔧 Najważniejsze Komendy

### Shopware Console
```bash
# Clear cache
docker-compose exec php bin/console cache:clear

# Database migration
docker-compose exec php bin/console database:migrate --all

# Plugin management
docker-compose exec php bin/console plugin:install --activate PluginName

# Theme compilation
docker-compose exec php bin/console theme:compile
```

### Code Quality
```bash
# PHP CS Fixer
docker-compose exec php vendor/bin/php-cs-fixer fix

# PHPStan analysis
docker-compose exec php vendor/bin/phpstan analyse

# ESLint
npm run lint:fix
```

### Testing
```bash
# PHP Tests
docker-compose exec php vendor/bin/phpunit

# JavaScript Tests
npm run test

# E2E Tests
npm run test:e2e
```

## 🤖 GitHub Copilot Integration

Projekt jest w pełni zoptymalizowany pod GitHub Copilot:

- ✅ **Intelligent code completion** dla PHP, JavaScript, Vue.js
- ✅ **Context-aware suggestions** dla Shopware API
- ✅ **Chat integration** w VSCode (`Ctrl+Shift+I`)
- ✅ **Inline suggestions** podczas pisania kodu
- ✅ **Test generation** assistance
- ✅ **Documentation generation**

### Copilot Tips
1. Pisz **descriptive comments** przed kodem
2. Używaj **meaningful variable names**
3. **Break down complex functions** na mniejsze części
4. Wykorzystuj **Copilot Chat** do wyjaśnień i pomocy

## 📚 Dokumentacja

- 📖 [Development Setup Guide](./DEVELOPMENT_SETUP.md)
- 📖 [Project Architecture](./PROJECT_SETUP.md)
- 📖 [Shopware Developer Docs](https://developer.shopware.com)
- 📖 [Vue.js 3 Guide](https://vuejs.org/guide/)
- 📖 [Docker Documentation](https://docs.docker.com)

## 🧪 Testing Strategy

### Unit Tests (PHP)
```bash
# Run all tests
docker-compose exec php vendor/bin/phpunit

# Run with coverage
docker-compose exec php vendor/bin/phpunit --coverage-html coverage/
```

### Unit Tests (JavaScript)
```bash
# Administration tests
cd src/Administration/Resources/app/administration
npm run test

# Coverage report
npm run test:coverage
```

### E2E Tests
```bash
# Playwright tests
npm run test:e2e
```

## 🔍 Debugging

### PHP Debugging (Xdebug)
1. Set breakpoint in PHP code
2. In VSCode: `F5` → "Listen for Xdebug (PHP)"
3. Refresh browser page
4. Debug! 🐛

### JavaScript Debugging
1. Set breakpoint in JS/Vue code
2. Open Chrome DevTools
3. Or use VSCode debugger
4. Debug! 🔧

## 🚨 Troubleshooting

### Common Issues

**Port conflicts:**
```bash
# Change ports in docker-compose.yml
ports:
  - "8000:80"  # Change from 80 to 8000
```

**Permission issues:**
```bash
# Linux/Mac
sudo chown -R $USER:$USER .

# Windows
# Run Docker Desktop as Administrator
```

**Docker issues:**
```bash
# Reset everything
docker-compose down -v
docker-compose up -d --build
```

### Getting Help

1. 📖 Check [DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md)
2. 🔍 Review Docker logs: `docker-compose logs`
3. 💬 Use GitHub Copilot Chat in VSCode
4. 🐛 Create issue in repository
5. 📧 Contact team

## 🤝 Contributing

1. **Fork** the repository
2. **Create** feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** changes (`git commit -m 'Add amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Open** Pull Request

### Code Standards
- **PHP**: PSR-12, Symfony standards
- **JavaScript**: ESLint + Prettier
- **Vue.js**: Vue 3 Composition API
- **CSS**: BEM methodology
- **Git**: Conventional Commits

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Lead Developer**: [ThaiMacha](https://github.com/ThaiMacha)
- **AI Assistant**: GitHub Copilot 🤖

## 🙏 Acknowledgments

- [Shopware AG](https://www.shopware.com) - Amazing e-commerce platform
- [GitHub Copilot](https://github.com/features/copilot) - AI pair programming
- [Docker](https://docker.com) - Containerization platform
- [VSCode](https://code.visualstudio.com) - Best code editor

---

**Happy Coding with AI! 🚀🤖**