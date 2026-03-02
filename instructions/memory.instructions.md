---
description: 'Recurring patterns and fixes observed during development'
applyTo: '**/*'
---

## Memory Notes

### REST 403 in WP Admin Embedded Tools

**Pattern**: An embedded React tool in WP Admin shows `403 rest_forbidden` on mount, even though nonce/cookie auth is correctly wired.

**Cause**: The WP admin menu page uses a broad capability (e.g. `edit_posts`), but the REST endpoints the tool calls require a stricter capability (e.g. `manage_options`). Non-admin users can reach the UI but all API calls fail.

**Fix**:
1. Pass `current_user_can()` flags via `wp_localize_script` (e.g. `tmdHub.permissions.canManageOptions`).
2. Gate the tool's visibility in JS using those flags — don't render the component for users who lack the capability.
3. Add a guard notice in case someone navigates directly (URL param).
4. Keep server-side `permission_callback` unchanged as the authoritative check.

**Key insight**: Always distinguish _authentication_ (is the user logged in with a valid nonce?) from _authorization_ (does the user have the required capability?). The `rest_forbidden` code is used for both, but the fix is very different.
