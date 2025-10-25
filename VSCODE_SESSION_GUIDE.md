# 🔄 VS Code Session Persistence Guide

## Problem

VS Code nie zachowuje ustawień workspace'a i konfiguracji GitHub Copilot po ponownym otwarciu.

## Rozwiązanie

Zostały wprowadzone następujące usprawnienia:

### 1. Zaktualizowane Ustawienia VS Code

**`.vscode/settings.json`** - Dodane kluczowe ustawienia dla trwałości sesji:

```json
{
  "window.restoreWindows": "all",
  "window.restoreFullscreen": true,
  "workbench.editor.restoreViewState": true,
  "workbench.editor.enablePreview": false,
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.hotExit": "onExitAndWindowClose",
  "files.restoreUndoStack": true,
  "terminal.integrated.persistentSessionReviveProcess": "onExitAndWindowClose",
  "terminal.integrated.enablePersistentSessions": true,
  "explorer.autoReveal": true,
  "task.autoDetect": "on",
  "debug.saveBeforeStart": "allEditorsInActiveGroup"
}
```

### 2. Rozszerzony Workspace File

**`MORA4ME.code-workspace`** - Aktualizacja z dodatkowymi ustawieniami sesji.

### 3. Skrypt Przywracania

**`restore-vscode.ps1`** - Automatyczny skrypt do przywracania konfiguracji:

```powershell
# Podstawowe użycie
.\restore-vscode.ps1

# Z dodatkowymi opcjami
.\restore-vscode.ps1 -Force -Verbose
```

## Instrukcje Użycia

### Metoda 1: Automatyczne Przywracanie

1. Zamknij VS Code
2. Uruchom PowerShell w folderze projektu
3. Wykonaj: `.\restore-vscode.ps1`
4. Skrypt automatycznie:
   - Sprawdzi konfigurację
   - Zainstaluje brakujące rozszerzenia
   - Skonfiguruje Docker
   - Uruchomi VS Code z poprawną konfiguracją

### Metoda 2: Manualne Otwarcie

1. **Zawsze używaj pliku workspace:**
   ```
   File → Open Workspace from File → MORA4ME.code-workspace
   ```

2. **LUB kliknij dwukrotnie na:**
   ```
   MORA4ME.code-workspace
   ```

### Metoda 3: Przez Terminal

```powershell
# Z folderu projektu
code MORA4ME.code-workspace
```

## Weryfikacja Konfiguracji

Po otwarciu VS Code sprawdź:

### ✅ GitHub Copilot
- Chat Copilot jest aktywny
- Autocompletions działają
- Status bar pokazuje Copilot jako aktywny

### ✅ Workspace
- Wszystkie foldery są widoczne w Explorer
- Terminal ma poprawną konfigurację PowerShell
- Zadania (Tasks) są dostępne

### ✅ Rozszerzenia
- GitHub Copilot ✅
- GitHub Copilot Chat ✅
- PHP Intelephense ✅
- Vue Language Features ✅
- Docker ✅

## Rozwiązywanie Problemów

### Problem: Copilot nie działa
```
1. Ctrl+Shift+P → "GitHub Copilot: Sign In"
2. Sprawdź status w statusbar
3. Uruchom: .\restore-vscode.ps1 -Force
```

### Problem: Ustawienia się resetują
```
1. Zawsze otwieraj przez MORA4ME.code-workspace
2. Nie używaj "Open Folder" - tylko "Open Workspace"
3. Sprawdź czy .vscode/settings.json istnieje
```

### Problem: Terminal nie działa
```
1. Sprawdź czy PowerShell jest domyślny w ustawieniach
2. Uruchom restore-vscode.ps1
3. Restart VS Code
```

## Pliki Konfiguracyjne

```
MORA4ME_cod_sklepu/
├── .vscode/
│   ├── settings.json          # Główne ustawienia workspace
│   ├── launch.json           # Konfiguracja debugowania
│   ├── tasks.json            # Zadania automatyzacji
│   ├── extensions.json       # Rekomendowane rozszerzenia
│   └── workspace-state.json  # Backup ustawień sesji
├── MORA4ME.code-workspace    # Plik workspace VS Code
└── restore-vscode.ps1        # Skrypt przywracania
```

## Dodatkowe Wskazówki

### 🎯 Najlepsze Praktyki
1. **Zawsze** używaj pliku `.code-workspace`
2. **Nigdy** nie otwieraj jako zwykły folder
3. Używaj skryptu `restore-vscode.ps1` przy problemach
4. Sprawdzaj status Copilot w status bar
5. Regularnie commituj zmiany w `.vscode/`

### 🔧 Backup & Restore
```powershell
# Backup konfiguracji
cp .vscode/settings.json .vscode/settings.backup.json

# Restore konfiguracji
cp .vscode/settings.backup.json .vscode/settings.json
```

### 📊 Monitoring
- Status Copilot: dolny pasek VS Code
- Rozszerzenia: `Ctrl+Shift+X`
- Ustawienia: `Ctrl+,`
- Tasks: `Ctrl+Shift+P` → "Tasks"

---

**💡 Pamiętaj:** Jeśli VS Code nadal nie zachowuje ustawień, zawsze możesz uruchomić `.\restore-vscode.ps1` aby przywrócić pełną konfigurację!
