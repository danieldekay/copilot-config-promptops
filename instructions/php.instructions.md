---
description: 'PHP development standards for TMD Core plugin'
applyTo: '**/*.php'
---

## Meta Box Integration

### Core Functions

- Use `rwmb_meta()` to retrieve meta values
- Define fields in PHP arrays or use Meta Box Builder
- Use `rwmb_the_value()` for frontend display
- Implement custom validation with `rwmb_validate_field`

### Best Practices

- **Field naming**: Use consistent prefixes (e.g., `tmd_event_`, `tmd_dj_`)
- **Conditional logic**: Use `visible` and `hidden` conditions for dynamic forms
- **Performance**: Use `'save_field' => false` for display-only fields
- Fields automatically available in REST responses

## PHPStan Static Analysis

### Commands

- `composer phpstan` - Full analysis with timestamped output
- `composer phpstan-quiet` - Silent analysis
- `composer phpstan-baseline` - Generate/update baseline
- `composer phpstan-file -- src/MyFile.php` - Single file analysis

### Best Practices

- Use baseline for existing codebases to focus on new code
- Critical errors to fix: `staticMethod.notFound`, `method.staticCall`, `function.notFound`
- Acceptable baseline issues: `nullCoalesce.offset`, `function.alreadyNarrowedType`, `trait.unused`
- Clean up temporary output files after analysis sessions

## Code Quality

### Commands

- `composer phpcs` - Check code style
- `composer phpcbf` - Fix code style automatically
- `composer test` - Run PHPUnit tests

### Standards

- Don't fix WordPress linting issues unless specifically requested
- Don't rename classes unless explicitly requested
- Always run `composer phpstan` before finalizing PHP changes

## WordPress Security

### Sanitization (Input)

```php
$title = sanitize_text_field($_POST['title'] ?? '');
$content = wp_kses_post($_POST['content'] ?? '');
$email = sanitize_email($_POST['email'] ?? '');
```

### Escaping (Output)

```php
echo esc_html($title);
echo esc_attr($class);
echo esc_url($link);
```

### Nonces

```php
wp_nonce_field('tmd_action', 'tmd_nonce');
if (!wp_verify_nonce($_POST['tmd_nonce'] ?? '', 'tmd_action')) {
    return;
}
```

### Capabilities

```php
if (!current_user_can('edit_posts')) {
    return;
}
```

### Database Queries

```php
$wpdb->prepare("SELECT * FROM {$wpdb->posts} WHERE ID = %d", $post_id);
```

## Plugin Lifecycle

- **Activation**: Handle setup with activation hooks
- **Deactivation**: Clean temporary data, flush rewrite rules
- **Uninstall**: Remove all plugin data (use uninstall.php)
- **Database migrations**: Version-controlled schema updates

## Custom Post Types & Meta

- Use proper labels, capabilities, and supports
- Register meta fields with sanitization callbacks
- Flush rewrite rules on activation/deactivation
- Define custom capabilities for fine-grained access control

## Performance

- Minimize database queries, use `WP_Query` parameters efficiently
- Implement transients for expensive operations
- Conditional asset loading - only load scripts/styles where needed
- Always paginate large datasets

## Code Organization

- Check existing traits before adding new code
- Create traits for code organization (use existing folder structure)
- Use existing plugin hooks (Meta Box, WPGraphQL)
- Keep files smaller than 500 lines
- Follow DRY, KISS, and SRP principles
- Prefix all global functions, classes, constants with `tmd_`

## Testing

- Write tests for REST API endpoints and GraphQL queries
- Place test files in `tests/` subdirectories, never in project root
- Use BrainMonkey for WordPress function mocking
