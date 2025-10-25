# 🎯 Szybka Instalacja Rozszerzeń - MORA4ME

## ⚡ Jedną komendą - zainstaluj wszystkie rozszerzenia

Uruchom w terminalu VSCode:

```bash
# Core Extensions
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension xdebug.php-debug

# Frontend Development
code --install-extension Vue.volar
code --install-extension Vue.vscode-typescript-vue-plugin
code --install-extension mblode.twig-language-2
code --install-extension bradlc.vscode-tailwindcss

# Code Quality
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension EditorConfig.EditorConfig
code --install-extension usernamehw.errorlens

# Docker & DevOps
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.remote-containers

# Git & Version Control
code --install-extension eamodio.gitlens
code --install-extension GitHub.vscode-pull-request-github
code --install-extension mhutchie.git-graph

# Testing & Debugging
code --install-extension Orta.vscode-jest
code --install-extension ms-vscode.test-adapter-converter

# Productivity
code --install-extension PKief.material-icon-theme
code --install-extension alefragnani.Bookmarks
code --install-extension formulahendry.auto-rename-tag

# Documentation
code --install-extension yzhang.markdown-all-in-one
code --install-extension DavidAnson.vscode-markdownlint

# API & HTTP
code --install-extension humao.rest-client

# Database
code --install-extension mtxr.sqltools
```

## 🚀 Lub użyj PowerShell script

```powershell
# Zapisz jako install-extensions.ps1 i uruchom
$extensions = @(
    "GitHub.copilot",
    "GitHub.copilot-chat", 
    "bmewburn.vscode-intelephense-client",
    "xdebug.php-debug",
    "Vue.volar",
    "Vue.vscode-typescript-vue-plugin",
    "mblode.twig-language-2",
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "EditorConfig.EditorConfig",
    "usernamehw.errorlens",
    "ms-azuretools.vscode-docker",
    "ms-vscode-remote.remote-containers",
    "eamodio.gitlens",
    "GitHub.vscode-pull-request-github",
    "mhutchie.git-graph",
    "Orta.vscode-jest",
    "PKief.material-icon-theme",
    "alefragnani.Bookmarks",
    "formulahendry.auto-rename-tag",
    "yzhang.markdown-all-in-one",
    "DavidAnson.vscode-markdownlint",
    "humao.rest-client",
    "mtxr.sqltools"
)

foreach ($extension in $extensions) {
    Write-Host "Installing $extension..." -ForegroundColor Green
    code --install-extension $extension
}

Write-Host "All extensions installed!" -ForegroundColor Cyan
```

## ✅ Sprawdź instalację

Po instalacji, sprawdź czy wszystko działa:

1. **Restart VSCode** (Ctrl+Shift+P → "Developer: Reload Window")
2. **Sprawdź Copilot** (Ctrl+Shift+P → "GitHub Copilot: Check Status")
3. **Test PHP IntelliSense** - otwórz plik .php
4. **Test Vue support** - otwórz plik .vue
5. **Test Twig highlighting** - otwórz plik .twig

## 🔧 Troubleshooting

**Problem**: Rozszerzenia nie działają
```bash
# Sprawdź zainstalowane rozszerzenia
code --list-extensions

# Wymuś przeładowanie okna
Ctrl+Shift+P → "Developer: Reload Window"
```

**Problem**: Copilot nie pokazuje sugestii
```bash
# Sprawdź status
Ctrl+Shift+P → "GitHub Copilot: Check Status"

# Zaloguj się ponownie
Ctrl+Shift+P → "GitHub Copilot: Sign Out"
Ctrl+Shift+P → "GitHub Copilot: Sign In"
```

## 🎨 Optional Extensions (zaawansowane)

```bash
# Code Quality & Analysis
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension oderwat.indent-rainbow
code --install-extension CoenraadS.bracket-pair-colorizer-2

# Advanced Git
code --install-extension donjayamanne.githistory
code --install-extension ms-vscode.vscode-github-actions

# Documentation & Comments
code --install-extension bierner.markdown-emoji
code --install-extension shd101wyy.markdown-preview-enhanced

# Performance Monitoring
code --install-extension WakaTime.vscode-wakatime
```

---

**Po instalacji wszystkich rozszerzeń, będziesz miał kompletne środowisko deweloperskie dla MORA4ME Shopware!** 🚀