---
description: 'JavaScript/React development standards for TMD Core plugin'
applyTo: '**/*.js'
---

## WordPress React Integration

### Required Imports

```javascript
import { createElement, useState, useEffect } from '@wordpress/element';
import { Button, Card, Notice } from '@wordpress/components';
import { __ } from '@wordpress/i18n';
import apiFetch from '@wordpress/api-fetch';
```

### Critical Rules

- **No JSX**: Use `createElement` only
- Use `apiFetch` with nonce middleware for API requests
- Attach exports to `window.wp` namespace for backward compatibility

## Hub Application Architecture

### Directory Structure

```text
src/Admin/components/hub/
├── index.js                 # Main entry point
├── HubApp.js               # Root application component
├── components/             # UI components
│   ├── common/            # Shared (Loading, ErrorBoundary)
│   ├── dashboard/         # Dashboard-specific
│   └── ui/               # Generic UI (Tabs, Cards)
├── services/             # API calls
├── hooks/               # Custom React hooks
├── utils/              # Helper functions
└── styles/            # Component styles
```

## Component Architecture

```javascript
import { createElement, useState, useEffect } from '@wordpress/element';
import { __ } from '@wordpress/i18n';
import { Button, Card } from '@wordpress/components';

function MyComponent({ title, onAction }) {
    const [state, setState] = useState(null);
    const { data, loading, error } = useApi('/endpoint');
    
    useEffect(() => {
        // Effect logic
        return () => { /* Cleanup */ };
    }, []);
    
    if (loading) return createElement('div', null, __('Loading...', 'tmd'));
    if (error) return createElement('div', null, __('Error occurred', 'tmd'));
    
    return createElement(Card, { className: 'my-component' },
        createElement('h2', null, title),
        createElement(Button, { onClick: onAction }, __('Action', 'tmd'))
    );
}

export default MyComponent;
```

## Service Layer Pattern

```javascript
import apiFetch from '@wordpress/api-fetch';

class ApiService {
    constructor() {
        this.baseUrl = '/wp-json/tmd/v1';
    }
    
    async get(endpoint) {
        return apiFetch({ path: `${this.baseUrl}${endpoint}`, method: 'GET' });
    }
    
    async post(endpoint, data) {
        return apiFetch({ path: `${this.baseUrl}${endpoint}`, method: 'POST', data });
    }
}

export default new ApiService();
```

## Custom Hooks Pattern

```javascript
import { useState, useEffect } from '@wordpress/element';
import ApiService from '../services/api';

export function useApi(endpoint) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    
    useEffect(() => {
        let mounted = true;
        
        ApiService.get(endpoint)
            .then(response => { if (mounted) { setData(response); setError(null); } })
            .catch(err => { if (mounted) setError(err); })
            .finally(() => { if (mounted) setLoading(false); });
            
        return () => { mounted = false; };
    }, [endpoint]);
    
    return { data, loading, error };
}
```

## Import/Export Standards

```javascript
// Named exports for utilities
export { validateData, formatDate, sanitizeInput };

// Default exports for components
export default MyComponent;

// Directory index files for clean imports
export { default as Loading } from './Loading';
export { default as ErrorBoundary } from './ErrorBoundary';
```

## Best Practices

- **One component per file**: Each React component in its own file
- **Error boundaries**: Catch React errors gracefully
- **Loading states**: Always show loading indicators for async operations
- **Lazy loading**: Use dynamic imports for large components
- **Memoization**: Use useMemo/useCallback for expensive operations
- **Cleanup**: Implement proper useEffect cleanup
- **Accessibility**: Follow WordPress accessibility guidelines
- **Testing**: Use BrainMonkey for mocking

## Build Commands

- `npm run dev` - Development with file watching
- `npm run build` - Production build
- `npm run build:css` / `npm run watch:css` - SCSS compilation

## Migration from Legacy Code

1. Extract services first (move API calls to service layer)
2. Create custom hooks (extract shared logic)
3. Split components (break large components into smaller ones)
4. Add error boundaries
5. Update imports to use new modular structure
