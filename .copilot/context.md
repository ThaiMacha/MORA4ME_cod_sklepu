# 🤖 GitHub Copilot - MORA4ME Shopware Project Configuration

## Project Context
This is a **Shopware 6** e-commerce project with the following tech stack:

### Backend
- **PHP 8.2+** with Symfony 7
- **Shopware 6** framework
- **MySQL/MariaDB** database
- **Redis** for caching
- **OpenSearch/Elasticsearch** for search

### Frontend
- **Vue.js 3** + TypeScript (Admin)
- **Twig** templating (Storefront)
- **SCSS** + Bootstrap 5
- **Webpack/Vite** build tools

### Development Environment
- **Docker** containerization
- **VS Code** with extensions
- **GitHub Copilot** AI assistance

## Copilot Usage Guidelines

### 🎯 Best Prompts for this Project

#### Plugin Development
```
// Generate a Shopware 6 plugin structure for [feature_name]
// Create a custom field for product entity in Shopware 6
// Implement a subscriber for order state changes
```

#### Frontend Development
```
// Create a Vue.js component for Shopware admin with TypeScript
// Generate Twig template for storefront product listing
// Create SCSS mixins for responsive design
```

#### Database & Entities
```
// Create a Shopware entity with custom fields
// Generate migration for new table in Shopware 6
// Create custom repository methods for entity
```

#### Testing
```
// Write PHPUnit tests for Shopware plugin
// Create Jest tests for Vue.js admin component
// Generate integration tests for API endpoints
```

### 📁 Project Structure Context

```
MORA4ME_cod_sklepu/
├── custom/                  # Custom plugins and themes
│   ├── plugins/            # Custom Shopware plugins
│   └── themes/             # Custom storefront themes
├── src/                    # Shopware core (don't modify)
├── config/                 # Configuration files
├── var/                    # Cache, logs, generated files
├── public/                 # Web root, assets
├── docker/                 # Docker configuration
└── .vscode/               # VS Code settings
```

### 🚀 Quick Commands

Use these with Copilot Chat:

- `@workspace explain the project structure`
- `@workspace how to create a new plugin?`
- `@workspace show me database entities`
- `@workspace how to debug this code?`

### 🔧 Code Patterns

#### Shopware Plugin Structure
```php
namespace Mora4me\PluginName;

use Shopware\Core\Framework\Plugin;
use Shopware\Core\Framework\Plugin\Context\InstallContext;

class PluginName extends Plugin
{
    public function install(InstallContext $installContext): void
    {
        // Installation logic
    }
}
```

#### Vue.js Admin Component
```typescript
// Admin component template
<template>
    <div class="mora4me-component">
        <!-- Component content -->
    </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';

@Component
export default class Mora4meComponent extends Vue {
    // Component logic
}
</script>
```

### 🎨 Coding Standards

- **PHP**: PSR-12, Shopware coding standards
- **JavaScript/TypeScript**: ESLint + Prettier
- **Vue.js**: Vue 3 Composition API preferred
- **CSS/SCSS**: BEM methodology
- **Git**: Conventional Commits

### 🛠️ Development Workflow

1. Start Docker environment
2. Use Copilot for code generation
3. Test locally
4. Commit with conventional messages
5. Deploy through pipeline

## Advanced Copilot Features

### Slash Commands
- `/explain` - Explain code functionality
- `/fix` - Fix code issues and bugs
- `/tests` - Generate unit/integration tests
- `/docs` - Generate documentation
- `/optimize` - Optimize performance

### Workspace Commands
- `@workspace` - Ask about project structure
- `@terminal` - Help with terminal commands
- `@vscode` - VS Code settings and extensions

This configuration ensures Copilot understands the project context and provides relevant suggestions!