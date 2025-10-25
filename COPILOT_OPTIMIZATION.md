# 🚀 Advanced VSCode + GitHub Copilot Configuration

## 🎯 Dodatkowe ustawienia dla wysokiej wydajności

### 1. Keyboard Shortcuts dla Copilot
Stwórz plik `.vscode/keybindings.json`:

```json
[
    {
        "key": "ctrl+shift+space",
        "command": "github.copilot.generate",
        "when": "editorTextFocus"
    },
    {
        "key": "ctrl+alt+i",
        "command": "github.copilot.acceptCursorPanelSolution",
        "when": "github.copilot.panelVisible"
    },
    {
        "key": "ctrl+alt+j",
        "command": "github.copilot.previousPanelSolution",
        "when": "github.copilot.panelVisible"
    },
    {
        "key": "ctrl+alt+k",
        "command": "github.copilot.nextPanelSolution",
        "when": "github.copilot.panelVisible"
    },
    {
        "key": "ctrl+alt+enter",
        "command": "github.copilot.acceptPanelSolution",
        "when": "github.copilot.panelVisible"
    }
]
```

### 2. Snippets dla Shopware Development
Stwórz folder `.vscode/snippets/` z plikami:

#### PHP Snippets (`.vscode/snippets/php.json`):
```json
{
    "Shopware Plugin Class": {
        "prefix": "swplugin",
        "body": [
            "<?php declare(strict_types=1);",
            "",
            "namespace ${1:YourNamespace}\\${2:PluginName};",
            "",
            "use Shopware\\Core\\Framework\\Plugin;",
            "",
            "/**",
            " * @package ${3:package-name}",
            " */",
            "class ${2:PluginName} extends Plugin",
            "{",
            "    $0",
            "}"
        ],
        "description": "Create a Shopware plugin class"
    },
    "Shopware Service": {
        "prefix": "swservice",
        "body": [
            "<?php declare(strict_types=1);",
            "",
            "namespace ${1:YourNamespace}\\${2:ServiceName};",
            "",
            "use Shopware\\Core\\Framework\\Log\\Package;",
            "",
            "/**",
            " * @package ${3:package-name}",
            " */",
            "#[Package('${3:package-name}')]",
            "class ${2:ServiceName}",
            "{",
            "    public function __construct(",
            "        $4",
            "    ) {",
            "    }",
            "",
            "    $0",
            "}"
        ],
        "description": "Create a Shopware service class"
    }
}
```

#### Vue Snippets (`.vscode/snippets/vue.json`):
```json
{
    "Shopware Vue Component": {
        "prefix": "swvue",
        "body": [
            "<template>",
            "    <div class=\"${1:component-name}\">",
            "        $0",
            "    </div>",
            "</template>",
            "",
            "<script>",
            "import template from './${1:component-name}.html.twig';",
            "",
            "const { Component } = Shopware;",
            "",
            "Component.register('${1:component-name}', {",
            "    template,",
            "",
            "    data() {",
            "        return {",
            "            $2",
            "        };",
            "    },",
            "",
            "    methods: {",
            "        $3",
            "    }",
            "});",
            "</script>"
        ],
        "description": "Create a Shopware Vue component"
    }
}
```

### 3. Code Actions & Quick Fixes
Dodaj do `settings.json`:

```json
{
    "editor.codeActionsOnSave": {
        "source.addMissingImports": "explicit",
        "source.fixAll": "explicit",
        "source.organizeImports": "explicit",
        "source.sortImports": "explicit"
    },
    "editor.quickSuggestions": {
        "strings": "on",
        "comments": "on",
        "other": "on"
    },
    "editor.suggestOnTriggerCharacters": true,
    "editor.acceptSuggestionOnEnter": "smart",
    "editor.tabCompletion": "on"
}
```

### 4. GitHub Copilot Labs Extensions
Zainstaluj dodatkowe rozszerzenia:

```bash
# W terminalu VSCode
code --install-extension GitHub.copilot-labs
code --install-extension GitHub.copilot-nightly  # Jeśli masz dostęp
```

### 5. Workspace Trust Configuration
```json
{
    "security.workspace.trust.enabled": true,
    "security.workspace.trust.startupPrompt": "once",
    "security.workspace.trust.banner": "always"
}
```

## 🧠 Techniki maksymalizacji wydajności Copilot

### 1. Context Optimization
- **Otwieraj related pliki** przed generowaniem kodu
- **Używaj descriptive file names** i folder structure
- **Dodawaj meaningful comments** przed kodem

### 2. Prompt Engineering
```php
// Zamiast: "create function"
// Użyj: "Create a Shopware service method that calculates shipping costs based on weight and distance with caching"

/**
 * Calculate shipping costs for MORA4ME e-commerce
 * - Weight-based calculation (kg)
 * - Distance zones (local, national, international)
 * - Redis caching for 1 hour
 * - Return formatted price with currency
 */
public function calculateShippingCost(float $weight, string $zone): array
{
    // Copilot will generate much better code with this context
}
```

### 3. Multi-file Context
- Otwórz **3-5 related files** jednocześnie
- Użyj **split editor** (Ctrl+\\)
- **Reference podobne klasy** w komentarzach

### 4. Progressive Enhancement
```php
// Step 1: Basic structure with comment
/**
 * Product recommendation service for MORA4ME
 * Uses collaborative filtering algorithm
 */
class ProductRecommendationService
{
    // Copilot will suggest constructor and dependencies
}

// Step 2: Add method signatures
public function getRecommendations(string $customerId, int $limit = 5): array
{
    // Copilot will implement the logic
}
```

## ⚡ Performance Tips

### 1. VSCode Performance
```json
{
    "editor.semanticHighlighting.enabled": true,
    "editor.bracketPairColorization.enabled": true,
    "editor.guides.bracketPairs": true,
    "editor.inlayHints.enabled": "on",
    "typescript.suggest.autoImports": true,
    "php.suggest.basic": false
}
```

### 2. Memory Optimization
```json
{
    "files.watcherExclude": {
        "**/var/**": true,
        "**/vendor/**": true,
        "**/node_modules/**": true,
        "**/.git/**": true,
        "**/public/bundles/**": true
    },
    "search.followSymlinks": false,
    "typescript.tsc.autoDetect": "off"
}
```

### 3. Copilot Response Speed
```json
{
    "github.copilot.advanced": {
        "listCount": 10,
        "inlineSuggestCount": 5,
        "debug.overrideEngine": "codex",
        "debug.filterLogCategories": []
    }
}
```

## 🎨 UI/UX Enhancements

### 1. Better Copilot Visibility
```json
{
    "github.copilot.editor.enableAutoCompletions": true,
    "editor.inlineSuggest.enabled": true,
    "editor.inlineSuggest.showToolbar": "always",
    "workbench.colorCustomizations": {
        "editorGhostText.foreground": "#888888",
        "editorSuggestWidget.background": "#252526",
        "editorSuggestWidget.border": "#454545"
    }
}
```

### 2. Custom CSS for Better Copilot UX
Dodaj rozszerzenie `Custom CSS and JS Loader` i stwórz:

```css
/* .vscode/copilot-custom.css */
.suggest-widget {
    backdrop-filter: blur(8px);
    border-radius: 8px !important;
}

.ghost-text {
    opacity: 0.7 !important;
    font-style: italic !important;
}
```

## 🔧 Debugging & Diagnostics

### 1. Copilot Diagnostics
```json
{
    "github.copilot.advanced": {
        "debug.testOverrideProxyUrl": "",
        "debug.showScores": true,
        "debug.overrideProxyUrl": ""
    }
}
```

### 2. Output Channels
- Otwórz `Output` panel (Ctrl+Shift+U)
- Wybierz `GitHub Copilot` z dropdown
- Monitoruj sugestie i błędy

## 📊 Productivity Metrics

### 1. Copilot Usage Analytics
```json
{
    "telemetry.telemetryLevel": "all",
    "github.copilot.advanced": {
        "debug.showScores": true
    }
}
```

### 2. Time Tracking Integration
Zainstaluj rozszerzenia:
- `WakaTime` - time tracking
- `Code Time` - productivity metrics

## 🎯 Advanced Workflows

### 1. Multi-cursor + Copilot
- `Ctrl+Alt+Down` - add cursor below
- `Alt+Click` - add cursor at position
- Copilot suggestions for multiple locations

### 2. Refactoring with Copilot
```
1. Select code block
2. Ctrl+Shift+P → "Refactor..."
3. Use Copilot Chat for complex refactoring
```

### 3. Test-Driven Development
```php
// 1. Write test first
public function testCalculateShippingCost(): void
{
    // Copilot will suggest test implementation
}

// 2. Generate implementation
// Copilot will create the actual method based on test
```

---

## ✅ Quick Setup Checklist

- [ ] Install GitHub Copilot Labs
- [ ] Configure keyboard shortcuts
- [ ] Add PHP/Vue snippets
- [ ] Optimize performance settings
- [ ] Configure workspace trust
- [ ] Setup diagnostics monitoring
- [ ] Test multi-file context awareness
- [ ] Practice prompt engineering techniques

## 🎯 Daily Workflow Optimization

1. **Morning Setup**: Open 3-5 related files for context
2. **Code Session**: Use descriptive comments before coding
3. **Refactoring**: Leverage Copilot for code improvements
4. **Testing**: Generate comprehensive test suites
5. **Documentation**: Auto-generate docs with Copilot

To da Ci **maksymalną wydajność** i **jakość** pracy z GitHub Copilot! 🚀