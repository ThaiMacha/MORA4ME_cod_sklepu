# 📋 MORA4ME - Założenia Projektu & Dane Dostępowe

## 🎯 Założenia Projektu

### 🛍️ Opis Projektu
**MORA4ME** to nowoczesny sklep internetowy oparty na **Shopware 6.7** z pełną integracją **GitHub Copilot** i optymalizacją pod **Visual Studio Code**.

### 🏗️ Stack Technologiczny

#### Backend
- **PHP**: 8.2+ / 8.3+ / 8.4+
- **Framework**: Shopware 6.7 (Symfony 7)
- **Database**: MySQL 8.0 / MariaDB
- **Cache**: Redis 7
- **Search**: OpenSearch 2

#### Frontend  
- **JavaScript**: ES6+, Vue.js 3
- **CSS**: SCSS, Tailwind CSS
- **Templates**: Twig
- **Build Tools**: Vite, Webpack

#### DevOps & Infrastructure
- **Containers**: Docker + Docker Compose
- **Proxy**: Caddy Server
- **Storage**: Nextcloud
- **Git**: GitHub + GitHub Actions

### 🎨 Architektura Aplikacji

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Caddy Proxy   │────│   Shopware App   │────│   MySQL/Redis   │
│   (Port 80/443) │    │   (Port 8000)    │    │   (Port 3306)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Nextcloud     │    │   Administration │    │   OpenSearch    │
│   (Files)       │    │   (Vue.js)       │    │   (Search)      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 🚀 Środowisko Developerskie

#### Wymagania
- ✅ **Docker Desktop** - konteneryzacja środowiska
- ✅ **Visual Studio Code** - IDE z GitHub Copilot
- ✅ **Git** - kontrola wersji
- ✅ **SSH Client** - dostęp do serwera produkcyjnego

#### Konfiguracja VSCode
- 🤖 **GitHub Copilot** - AI assistance
- 🐘 **PHP Intelephense** - PHP language server
- 🌟 **Vue Language Features** - Vue.js support
- 🐳 **Docker Extension** - container management
- 🎨 **Twig Language** - template support

---

## 🔐 Dane Dostępowe

### 📁 Nextcloud (Chmura plików)
```
URL: https://mora4me.com/
Alt URL: https://cloud.playlove4u.pl/
Login: admin
Hasło: TwojeHasloAdmin
```

### 🛒 Shopware (Sklep internetowy)
```
Admin Panel: https://sklep.mora4me.com/admin
Login: admin
Hasło: admin123

Login alternatywny: admin2  
Hasło alternatywne: shopware
```

### 🖥️ SSH (Dostęp do serwera)
```
Adres: 57.128.225.66
Port: 2233
Użytkownik: ubuntu
Klucz SSH: id_ed25519
Komenda: ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 ubuntu@57.128.225.66
```

### 📂 Lokalizacja kodu na serwerze
```
Ścieżka: /var/www/shopware/
Właściciel: www-data:www-data
Uprawnienia: sudo wymagane do edycji
```

### 🗄️ Baza danych MariaDB
```
Host: 172.18.0.3 (z serwera)
Kontener: nextcloud_db_1
Port: 3306
Użytkownik: shopware
Hasło: shopwarepass
Baza danych: shopware

Dostęp: sudo docker exec -it nextcloud_db_1 mariadb -u shopware -pshopwarepass shopware
```

### 🌐 Caddy Proxy (Reverse Proxy)
```
Konfiguracja: /home/ubuntu/nextcloud/Caddyfile
Docker Compose: /home/ubuntu/nextcloud/docker-compose.yml
Restart: sudo docker-compose restart caddy
```

---

## 🛠️ Komendy Developerskie

### 🚀 Lokalne środowisko (Docker)
```bash
# Start środowiska
docker-compose up -d

# Stop środowiska  
docker-compose down

# Czyszczenie cache
docker-compose exec php bin/console cache:clear

# Migracje bazy danych
docker-compose exec php bin/console database:migrate --all

# Kompilacja theme
docker-compose exec php bin/console theme:compile
```

### 🧪 Testowanie i jakość kodu
```bash
# PHP Tests
docker-compose exec php vendor/bin/phpunit

# PHP Static Analysis
docker-compose exec php vendor/bin/phpstan analyse

# PHP Code Style Fix
docker-compose exec php vendor/bin/php-cs-fixer fix

# JavaScript Tests
cd src/Administration/Resources/app/administration
npm run test

# ESLint Fix
npm run lint:fix
```

### 🌐 Serwer produkcyjny
```bash
# Połączenie SSH
ssh -i "C:\Users\PC\.ssh\id_ed25519" -p 2233 ubuntu@57.128.225.66

# Przejście do katalogu Shopware
cd /var/www/shopware

# Sprawdzenie logów
sudo tail -f /var/www/shopware/var/log/prod-*.log

# Czyszczenie cache produkcyjnego
sudo rm -rf var/cache/* && sudo chown -R www-data:www-data var/

# Dostęp do bazy danych
sudo docker exec -it nextcloud_db_1 mariadb -u shopware -pshopwarepass shopware
```

---

## 🤖 GitHub Copilot Integration

### ✨ Możliwości
- 🧠 **Inteligentne uzupełnianie kodu** dla PHP, JavaScript, Vue.js
- 💬 **Copilot Chat** - asystent konwersacyjny (`Ctrl+Shift+I`)
- 🔍 **Context-aware suggestions** - sugestie na podstawie kontekstu Shopware
- 🧪 **Test generation** - automatyczne generowanie testów
- 📚 **Documentation assistance** - pomoc w dokumentacji

### 🎯 Best Practices dla Copilot
1. **Pisz opisowe komentarze** przed kodem
2. **Używaj znaczących nazw** zmiennych i funkcji
3. **Dziel złożone funkcje** na mniejsze części
4. **Wykorzystuj Copilot Chat** do wyjaśnień
5. **Przeglądaj sugestie** przed akceptacją

### 📝 Przykładowe prompty
```php
// Generate a Shopware plugin for product recommendations
// Create a Vue.js component for shopping cart
// Write PHPUnit test for user authentication
// Implement Redis caching for product search
```

---

## 📊 Struktura Projektu

```
MORA4ME_cod_sklepu/
├── .vscode/                     # 🔧 Konfiguracja VSCode
│   ├── settings.json           # Ustawienia edytora
│   ├── extensions.json         # Zalecane rozszerzenia
│   ├── tasks.json              # Zadania automatyzacji
│   └── launch.json             # Konfiguracja debugowania
├── docker/                      # 🐳 Konfiguracja Docker
├── config/                      # ⚙️ Konfiguracja Shopware
├── src/                         # 📁 Kod źródłowy
│   ├── Core/                   # Jądro Shopware
│   ├── Administration/         # Panel administracyjny (Vue.js)
│   ├── Storefront/            # Frontend sklepu (Twig/JS)
│   └── Elasticsearch/         # Integracja wyszukiwania
├── custom/                      # 🔌 Niestandardowe pluginy
├── public/                      # 🌐 Pliki publiczne
├── var/                         # 📊 Cache, logi, dane tymczasowe
├── vendor/                      # 📦 Dependencies PHP
├── tests/                       # 🧪 Testy automatyczne
├── .env                        # 🔐 Zmienne środowiskowe
├── composer.json               # 📦 Zależności PHP
├── docker-compose.yml          # 🐳 Orchestracja kontenerów
└── README.md                   # 📖 Dokumentacja projektu
```

---

## 🔗 Przydatne Linki

- 📖 [Shopware Developer Guide](https://developer.shopware.com)
- 🌟 [Vue.js 3 Documentation](https://vuejs.org/guide/)
- 🐳 [Docker Documentation](https://docs.docker.com)
- 🤖 [GitHub Copilot Tips](https://github.com/features/copilot)
- 💼 [Symfony Framework](https://symfony.com/doc/current/index.html)

---

## 📞 Kontakt & Support

- **Lead Developer**: ThaiMacha
- **AI Assistant**: GitHub Copilot 🤖
- **Repository**: [MORA4ME_cod_sklepu](https://github.com/ThaiMacha/MORA4ME_cod_sklepu)

---

*Dokument wygenerowany automatycznie przez GitHub Copilot* 🤖