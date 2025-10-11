# MORA4ME - Projekt Sklepu Internetowego

## 📋 Założenia Projektu

### Cel Projektu
Budowa nowoczesnego sklepu internetowego opartego na platformie **Shopware 6** z wykorzystaniem najlepszych praktyk developmentu i narzędzi AI (GitHub Copilot).

### Technologie Główne
- **Backend**: Shopware 6 (PHP 8.2+, Symfony 7)
- **Frontend Admin**: Vue.js 3, TypeScript, Vite
- **Frontend Storefront**: Twig, Bootstrap 5, SCSS
- **Baza danych**: MySQL 8.0+ / MariaDB 10.11+
- **Search**: OpenSearch 2+ / Elasticsearch 8+
- **Cache**: Redis
- **Development**: Docker, VSCode, GitHub Copilot

### Struktura Projektu
```
MORA4ME_cod_sklepu/
├── docker/                      # Konfiguracja Docker
├── config/                      # Konfiguracja środowiska
├── .vscode/                     # Ustawienia VSCode
├── src/                         # Kod źródłowy Shopware
├── custom/                      # Niestandardowe pluginy/themes
├── var/                         # Cache, logs
├── public/                      # Pliki publiczne
├── vendor/                      # Dependencies
├── .env                         # Zmienne środowiskowe
└── composer.json                # PHP dependencies
```

### Wymagania Środowiskowe
- **PHP**: 8.2+ (z extensionami: curl, dom, fileinfo, gd, intl, json, mbstring, openssl, pdo_mysql, session, simplexml, sodium, xml, zip, zlib)
- **Node.js**: 18+ LTS
- **Composer**: 2.8+
- **Docker**: Latest
- **MySQL**: 8.0+ lub MariaDB 10.11+
- **Redis**: 6+
- **OpenSearch/Elasticsearch**: 8+

## 🛠️ Konfiguracja Środowiska Developerskiego

### Narzędzia Quality Assurance
- **PHP**: PHPStan, PHP CS Fixer, PHPUnit
- **JavaScript**: ESLint, Prettier, Jest
- **E2E Testing**: Playwright
- **Git Hooks**: Pre-commit validation

### Integracje VSCode
- Intelligent code completion z GitHub Copilot
- Debugging PHP z Xdebug
- Live reload dla Storefront
- Hot Module Replacement dla Administration
- Integrated terminal z Docker containers

### Workflow Developmentu
1. **Feature Development**: Feature branches z konwencją `feature/MORA-XXX-description`
2. **Code Review**: Pull Requests z required reviewers
3. **Testing**: Automatyczne testy przed merge
4. **Deployment**: CI/CD pipeline z GitHub Actions

### Bezpieczeństwo
- Environment variables dla sensitywnych danych
- HTTPS w development
- Security headers configuration
- Rate limiting setup

## 📚 Dokumentacja Development
- [Shopware Developer Documentation](https://developer.shopware.com)
- [VSCode Shopware Extension Guide](./docs/vscode-setup.md)
- [Docker Setup Guide](./docs/docker-setup.md)
- [Debugging Guide](./docs/debugging.md)

## 🚀 Quick Start
```bash
# 1. Clone repository
git clone https://github.com/ThaiMacha/MORA4ME_cod_sklepu.git

# 2. Start Docker environment
cd MORA4ME_cod_sklepu
docker-compose up -d

# 3. Install dependencies
composer install
npm install

# 4. Setup database
bin/console system:install --create-database --basic-setup

# 5. Start development servers
npm run dev  # For Administration (Hot reload)
npm run watch  # For Storefront (Live reload)
```

---
**Ostatnia aktualizacja**: 11 października 2025
**Team**: MORA4ME Development Team