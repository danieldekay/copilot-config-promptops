---
description: 'SCSS/CSS development standards for TMD4 Genesis child theme'
applyTo: '**/*.scss'
---

## Bootstrap 4 Integration

**Critical**: Do NOT upgrade to Bootstrap 5 without extensive testing. Breaking changes require careful migration.

### SCSS Organization

```text
sass/
├── _variables.scss      # Bootstrap variable overrides (load first)
├── _mixins.scss        # Custom mixins
├── _typography.scss    # Type styles
├── _components/        # Component styles
│   ├── _cards.scss
│   ├── _events.scss
│   └── _navigation.scss
└── style.scss          # Main import file
```

### Variable Overrides

Override Bootstrap variables BEFORE importing Bootstrap:

```scss
// _variables.scss
$primary: #d43f3f;
$secondary: #6c757d;
$font-family-base: 'Open Sans', sans-serif;
$border-radius: 0.25rem;

// Then import Bootstrap
@import "node_modules/bootstrap/scss/bootstrap";
```

## Bootstrap Grid Usage

```scss
// Use Bootstrap grid classes in templates
// <div class="container">
//   <div class="row">
//     <div class="col-md-6">Content</div>
//   </div>
// </div>

// Custom responsive adjustments
.tmd-event-grid {
    @include make-row();
    
    .tmd-event-card {
        @include make-col-ready();
        @include make-col(12);
        
        @include media-breakpoint-up(md) {
            @include make-col(6);
        }
        
        @include media-breakpoint-up(lg) {
            @include make-col(4);
        }
    }
}
```

## Bootstrap Components

### Cards

```scss
.tmd-event-card {
    @extend .card;
    margin-bottom: $spacer;
    
    .card-body {
        padding: $card-spacer-x;
    }
    
    .card-title {
        @extend .h5;
        margin-bottom: $spacer / 2;
    }
}
```

### Buttons

```scss
.tmd-btn-primary {
    @extend .btn;
    @extend .btn-primary;
    
    &:hover {
        transform: translateY(-1px);
    }
}
```

## Responsive Design

### Breakpoint Usage

```scss
// Mobile first approach
.tmd-sidebar {
    display: none;
    
    @include media-breakpoint-up(lg) {
        display: block;
        width: 300px;
    }
}

// Bootstrap 4 breakpoints:
// xs: 0
// sm: 576px
// md: 768px
// lg: 992px
// xl: 1200px
```

### Container Widths

```scss
// Use Bootstrap containers
.tmd-full-width {
    @extend .container-fluid;
    padding-left: 0;
    padding-right: 0;
}

.tmd-content-width {
    @extend .container;
}
```

## TMD Component Styles

### Event Cards

```scss
.tmd-event-card {
    border: 1px solid $border-color;
    border-radius: $border-radius;
    overflow: hidden;
    transition: box-shadow 0.2s ease;
    
    &:hover {
        box-shadow: $box-shadow;
    }
    
    &__image {
        aspect-ratio: 16/9;
        object-fit: cover;
        width: 100%;
    }
    
    &__content {
        padding: $spacer;
    }
    
    &__date {
        color: $text-muted;
        font-size: $small-font-size;
    }
}
```

### DJ Cards

```scss
.tmd-dj-card {
    text-align: center;
    
    &__avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        margin-bottom: $spacer;
    }
    
    &__name {
        @extend .h5;
        margin-bottom: $spacer / 4;
    }
}
```

## Genesis Framework Styles

### Genesis Markup

```scss
// Genesis uses specific class names
.site-container {
    // Main wrapper
}

.site-inner {
    @extend .container;
}

.content-sidebar-wrap {
    @include make-row();
}

.content {
    @include make-col-ready();
    @include make-col(12);
    
    @include media-breakpoint-up(lg) {
        @include make-col(8);
    }
}

.sidebar-primary {
    @include make-col-ready();
    @include make-col(12);
    
    @include media-breakpoint-up(lg) {
        @include make-col(4);
    }
}
```

## Accessibility

### Focus States

```scss
// Ensure visible focus states
a:focus,
button:focus,
input:focus {
    outline: 2px solid $primary;
    outline-offset: 2px;
}

// Skip link
.skip-link {
    @extend .sr-only;
    @extend .sr-only-focusable;
}
```

### Color Contrast

```scss
// Maintain WCAG 2.1 AA contrast ratios
// Use Bootstrap's color-yiq() function
.tmd-badge {
    background-color: $primary;
    color: color-yiq($primary);
}
```

## Build Commands

```bash
npm run watch         # Development with file watching
npm run build         # Production build (minified)
```

## Best Practices

- Override Bootstrap variables, don't overwrite components
- Use Bootstrap mixins and utilities
- Follow BEM naming for custom components
- Mobile-first responsive design
- Keep specificity low
- Use Bootstrap spacing utilities ($spacer, $spacer * 2, etc.)

## Do NOT

- Upgrade Bootstrap without extensive testing
- Use `!important` unless absolutely necessary
- Create custom grid systems (use Bootstrap's)
- Hard-code colors (use variables)
- Skip responsive testing
