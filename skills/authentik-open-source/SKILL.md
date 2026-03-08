---
name: authentik-open-source
description: Use when the task depends on the self-hosted Authentik community documentation, especially docs.goauthentik.io pages about blueprints, managed/blueprints, export_blueprint, Docker Compose, .env settings, manual outposts, and OSS-only configuration patterns. Prefer this skill when the user wants Authentik guidance grounded in upstream docs, blueprint schema details, or explicit exclusion of Enterprise features.
---

# Authentik Open Source Docs

Last reviewed: 2026-03-08 CET

## Overview

Use this skill for self-hosted Authentik based on the upstream community documentation at `docs.goauthentik.io`.

Treat this as a documentation-grounded skill, not a general IAM improvisation skill. Prefer the official docs, use Tavily tools to fetch the relevant pages, and keep Enterprise guidance out of scope unless the user explicitly asks for it.

This skill is the documentation-and-schema companion to [../authentik-management/SKILL.md](../authentik-management/SKILL.md). Use this one to interpret upstream Authentik OSS docs correctly. Use `authentik-management` when the task becomes concrete server automation, deployment, or production operations.

For configuration management, prefer this order unless the user explicitly asks otherwise:

1. File-backed blueprints managed by Ansible
2. Authentik configuration via `.env` and container mounts managed by Ansible
3. Manual outpost deployment managed by Ansible
4. Database-backed blueprints or blueprint API only when filesystem-based control is not practical
5. Admin UI only for discovery, export, or one-off bootstrap

## When to Use This Skill

- The user asks about Authentik installation, configuration, applications, providers, bindings, outposts, upgrades, or logs.
- The user wants Authentik managed as code through blueprints, YAML, or Ansible.
- The user wants community/open source Authentik guidance and does not want Enterprise-specific instructions.
- The user references `docs.goauthentik.io`, `compose.yml`, `akadmin`, `AUTHENTIK_SECRET_KEY`, `Create with Provider`, `ak export_blueprint`, `managed/blueprints`, or Authentik outposts.
- The user wants answers grounded in current Authentik documentation rather than memory or generic SSO advice.

Do not use this skill for:

- Enterprise-only Authentik features or pages under `/enterprise/`.
- Authentik Cloud or commercial packaging questions.
- Generic OAuth, SAML, LDAP, or reverse proxy questions that do not require Authentik-specific behavior.

## Scope Guardrails

- Prefer `docs.goauthentik.io` pages outside `/enterprise/`.
- If the site navigation or search results include Enterprise material, ignore it unless the user explicitly asks for Enterprise.
- Prefer blueprints over repetitive click-path instructions when the user is managing Authentik declaratively.
- Prefer file-backed blueprints for steady-state management with Ansible.
- Treat Admin UI instructions as secondary when the request is about repeatable operations or infrastructure as code.
- Do not invent deployment shortcuts that contradict the docs.
- Do not recommend the deprecated `:latest` container tag.
- For upgrades, assume downgrades are unsupported.

## Primary Workflow

### 1. Discover the right documentation pages

Use Tavily against `docs.goauthentik.io` before answering non-trivial questions.

- Use `mcp_tavily-search_tavily_map` to understand the section layout.
- Use `mcp_tavily-search_tavily_crawl` to gather a focused slice of the OSS docs.
- Use `mcp_tavily-search_tavily_extract` for the exact pages you plan to rely on.

Recommended crawl focus:

- `/install-config/.*`
- `/add-secure-apps/.*`
- `/customize/blueprints/.*`
- `/core/architecture.*`
- `/security/.*`
- `/troubleshooting/.*`

Exclude:

- `/enterprise/.*`
- pricing or support pages
- unrelated integration marketing pages unless the user asked for one specific integration

### 2. Choose the control plane

When the user wants Ansible or infrastructure as code, choose one of these models explicitly:

- File-backed blueprints:
   - Blueprint YAML lives in git.
   - Ansible templates or copies files into a mounted blueprint directory.
   - Authentik worker auto-discovers new files and reapplies changed files.
   - Best default for Git-managed Authentik state.

- Database-backed blueprints:
   - Blueprint content is stored in Authentik's database.
   - Suitable when the control plane must work through API-driven tooling.
   - Useful when direct filesystem mounts are not available.

- Imported flows:
   - Good for one-time bootstrap or experimentation.
   - Not the preferred steady-state configuration-as-code model.

- Docker outpost integration:
   - Lets Authentik manage outpost containers through the Docker API.
   - Useful when Authentik is allowed to control runtime infrastructure.

- Manual outposts:
   - Better fit when Ansible is the source of truth for containers and networks.

### 3. Anchor the answer in Authentik's model

Keep these distinctions explicit:

- Applications control visibility and access on the `My applications` page.
- Providers define the authentication protocol or mechanism.
- Bindings are how access is restricted or hidden.
- Outposts are separate components used for proxy, LDAP, RAC, RADIUS, and related deployment patterns.
- Blueprints are the native Authentik configuration-as-code mechanism.

### 4. Answer with the smallest correct workflow

Prefer a minimal path that matches the docs:

- the Ansible-managed files or variables involved
- the required `.env` variables or blueprint fields
- the exact Authentik object model involved
- the one or two checks that confirm success

If the user needs depth, then expand into provider-specific, blueprint-schema, or outpost-specific detail.

## Quick Reference

### Blueprint-first configuration as code

Blueprints are Authentik's native configuration-as-code system. For Ansible-managed environments, prefer file-backed blueprints mounted into the worker container over repeated UI configuration.

Key facts from the docs:

- Blueprint files are YAML.
- File-based blueprints are discovered under `/blueprints` in the worker container.
- New files trigger discovery automatically.
- Modified files trigger apply automatically.
- Blueprint instances are also re-read regularly, approximately every 60 minutes.
- Blueprint execution is atomic: if one entry fails, the entire blueprint is rolled back.

### Blueprint schema essentials

Use the official schema header in blueprint files:

```yaml
# yaml-language-server: $schema=https://goauthentik.io/blueprints/schema.json
version: 1
metadata:
   name: example-blueprint
entries: []
```

Important fields to explain correctly:

- `version`
- `metadata.labels`
- `context`
- `entries`
- `model`
- `identifiers`
- `attrs`
- `state`

Important `state` values:

- `present`: create or update selected fields
- `created`: create once, preserve later manual changes
- `must_created`: fail if the object already exists
- `absent`: delete the object if it exists

Important caveats:

- Blueprint discovery order is not guaranteed.
- If one blueprint depends on another, use blueprint meta models to control ordering.
- Exported blueprints usually need cleanup because they contain hardcoded primary keys and are not automatically templated.

### Docker Compose install

Use the upstream `compose.yml`, not a hand-written stack, for first-time community installs.

Key steps from the docs:

1. Download `compose.yml` from `https://docs.goauthentik.io/compose.yml`.
2. Add at minimum:
   - `PG_PASS`
   - `AUTHENTIK_SECRET_KEY`
3. Optionally add:
   - `AUTHENTIK_ERROR_REPORTING__ENABLED=true`
   - `COMPOSE_PORT_HTTP`
   - `COMPOSE_PORT_HTTPS`
4. Start with:

```bash
docker compose pull
docker compose up -d
```

5. Open the initial setup flow with a trailing slash:

```text
http://<host>:9000/if/flow/initial-setup/
```

Important warnings from the docs:

- Do not mount `/etc/timezone` or `/etc/localtime` into Authentik containers.
- The initial setup URL must end with `/` or you can get `Not Found`.

### Configuration via environment variables

- Authentik configuration keys use double underscores, for example `AUTHENTIK_POSTGRESQL__HOST`.
- With Docker Compose, append keys to `.env` and re-apply with `docker compose up -d`.
- These `.env` values are a good fit for Ansible templating.
- The docs also support `env://...` and `file://...` sources, which are useful when secrets are injected by deployment tooling.
- Verify the active config with:

```bash
docker compose run --rm worker ak dump_config
```

### Applications, providers, and bindings

- Use `Applications -> Applications -> Create with Provider` for the simplest first setup.
- Explain that every application needs a provider.
- If no bindings are defined, all users can access the application.
- Use bindings when the user wants application visibility or access limited by group or user.
- When the request is IaC-focused, translate UI objects into blueprint-managed objects instead of stopping at click instructions.

### Provider selection

Use the provider that matches the application protocol instead of forcing one pattern everywhere.

| Need | Typical provider |
|------|------------------|
| Modern web app SSO | OAuth2/OIDC |
| Existing enterprise app or SP metadata | SAML |
| Directory access | LDAP |
| Forward auth or protected app proxying | Proxy |
| Network auth edge case | RADIUS |
| Provisioning users/groups into downstream apps | SCIM |

### Outposts

- The default community Docker Compose install mounts the Docker socket into the worker for automatic outpost management.
- Treat that as a security decision, not a default you must preserve.
- If Authentik manages outposts through Docker integration, the worker needs Docker API permissions and can auto-upgrade outposts when Authentik upgrades.
- If Ansible is the source of truth for containers, prefer manual outpost deployment and manage the outpost Compose definitions yourself.
- Safer documented alternatives are:
  - use a Docker Socket Proxy
  - remove the socket mount and deploy outposts manually
- For manual Compose deployments, use the documented container image and environment pattern for the specific outpost type.

### Export and migration to blueprints

Use export when the current state lives in the UI and needs to be moved into git-managed configuration.

Global export command:

```bash
docker compose run --rm worker ak export_blueprint
```

Key export caveats from the docs:

- Exports contain raw object lists and usually need cleanup.
- Write-only fields, such as some secret values, are not exported.
- Default values may be omitted.
- Expect manual refactoring before treating an export as a reusable blueprint.

### Ansible-managed Authentik pattern

Prefer this model for repeatable infrastructure:

1. Template `compose.yml` and `.env` with Ansible.
2. Mount a dedicated blueprint directory into the Authentik worker.
3. Manage blueprint YAML files in git.
4. Use handlers to restart or reconcile only when Compose or environment changes require it.
5. Rely on blueprint file creation and modification events for blueprint discovery and apply.

For steady state, avoid editing the same objects manually in the UI without reconciling those changes back into blueprints.

### Upgrades

- Authentik does not support downgrading.
- Back up PostgreSQL before upgrading.
- Read the release notes for the target version.
- Follow major releases sequentially and do not skip directly across them.
- Upgrade outposts at the same time and keep versions matched.
- Refresh `compose.yml`, then run:

```bash
docker compose pull
docker compose up -d
```

### Logs and troubleshooting

- Default log level is `info`.
- Raise to `debug` first; use `trace` only when necessary because it can expose sensitive data.
- Recreate containers after changing log level.
- For recent logs:

```bash
docker logs <container> --since 5m
docker logs <container> -f
```

### Hardening for IaC-controlled environments

If Authentik must only be changed from files managed by Ansible, the hardening docs note that you can block API access to:

```text
/api/v3/managed/blueprints
```

With that restriction in place, blueprints can only be edited through the filesystem. This is a strong fit when file-backed blueprints in git are the intended source of truth.

## Response Pattern

For non-trivial requests, structure the answer in this order:

1. What part of Authentik the request touches.
2. Which community docs pages you relied on.
3. Which control plane is appropriate: file blueprint, database blueprint, manual outpost, or runtime config.
4. The shortest correct workflow.
5. The main gotcha or risk.
6. One verification step.

Keep answers specific. If the docs distinguish between Docker Compose, Kubernetes, and AWS CloudFormation, only describe the one the user is actually using.

When the user mentions Ansible, always prefer a repo-managed file path and reconciliation workflow over click-by-click instructions unless they explicitly ask for UI steps.

## Common Mistakes

- Mixing Enterprise pages into community guidance.
- Treating the Admin UI as the primary source of truth in an Ansible-managed deployment.
- Telling users to write a custom Compose stack before they have a working baseline unless that is explicitly the target state.
- Forgetting the trailing slash on the initial setup URL.
- Recommending `:latest` instead of a real release tag.
- Changing log level to `trace` without warning about sensitive data exposure.
- Upgrading core Authentik without upgrading outposts.
- Treating applications and providers as interchangeable.
- Forgetting that bindings control access and visibility behavior.
- Assuming blueprint apply order is deterministic.
- Treating exported blueprints as production-ready without cleanup.
- Letting Authentik auto-manage outposts via Docker when Ansible is supposed to own container lifecycle.
- **Using Jinja2 filter syntax in email templates** — Authentik email templates use Django template language, not Jinja2. `{{ var | default(fallback) }}` crashes with `TemplateSyntaxError: default requires 2 arguments`. Use `{% firstof var fallback %}` instead.
- **Nesting `{% raw %}` blocks in `.j2` email templates** — Ansible `.j2` files for email content must wrap the entire body in a single outer `{% raw %}…{% endraw %}`. Never place an inner `{% raw %}` inside an already-open outer block; Django receives the literal tag text and re-crashes.

## Email Template Patterns

Authentik email templates use **Django template language**, not Jinja2.

### Correct Patterns

```django
{# Fallback value — Django style #}
{% firstof user.name user.username %}

{# Conditional block #}
{% if action_url %}
  <a href="{{ action_url }}">{{ action_label }}</a>
{% endif %}

{# Loop over key/value table #}
{% for key, value in key_value.items %}
  <tr><td>{{ key }}</td><td>{{ value }}</td></tr>
{% endfor %}
```

### Incorrect Patterns (Jinja2)

```
{{ user.name | default(user.username) }}  ← TemplateSyntaxError: default requires 2 arguments
{{ value | upper }}                        ← not all Jinja filters exist in Django
```

### Available Template Variables

| Variable | Notes |
|----------|-------|
| `user.name` | Display name |
| `user.username` | Username |
| `user.email` | Email address |
| `flow_info.title` | Flow display title |
| `site_name` | Authentik brand name |
| `url` | Recovery/confirmation link (EmailStage) |
| `title` | Subject or notification title |
| `body` | Main notification body |
| `action_url` | CTA link URL |
| `action_label` | CTA button label |
| `key_value` | Dict for table display |

### Ansible `.j2` Template Rule

When managing email templates as Ansible templates, the entire Django template body must lie inside ONE outer `{% raw %}…{% endraw %}` wrapper. Not nested — one wrapper, whole file:

```jinja2
{% raw %}
<!DOCTYPE html>
<html>
  {% if user.name %}…{% endif %}
  <p>{% firstof user.name user.username %}</p>
</html>
{% endraw %}
```

## Authentication Flow Patterns

### Single-Screen Login (Username + Password on one page)

Set `password_stage` on the IdentificationStage `attrs` to embed the password field on the same screen:

```yaml
- model: authentik_stages_identification.identificationstage
  id: stage-identification
  attrs:
    name: tangoatlas-auth-identification
    user_fields:
      - username
      - email
    password_stage: !KeyOf stage-password   # ← embeds password on same screen
    recovery_flow: !Find                    # ← adds "Forgot password?" link
      - authentik_flows.flow
      - [slug, tangoatlas-recovery-flow]
```

Add the `PasswordStage` as a normal entry — it will not be shown as a separate step:

```yaml
- model: authentik_stages_password.passwordstage
  id: stage-password
  attrs:
    name: tangoatlas-auth-password
    backends:
      - authentik.core.auth.InbuiltBackend
```

### `!KeyOf` vs `!Find`

| Tag | Use when |
|-----|----------|
| `!KeyOf <id>` | Object is created in the **same blueprint** — references by the blueprint entry's `id` field |
| `!Find [model.class, [field, value]]` | Object exists **outside the blueprint** (created by another blueprint or the UI) — looks up by a known field value |

```yaml
# Inside the same blueprint:
password_stage: !KeyOf stage-password

# Cross-blueprint reference (flow created by another blueprint):
recovery_flow: !Find
  - authentik_flows.flow
  - [slug, tangoatlas-recovery-flow]
```

### Brand Wiring

To attach authentication and recovery flows to a brand (domain), include an `authentik_brands.brand` entry in the blueprint:

```yaml
- model: authentik_brands.brand
  id: brand-tangoatlas
  identifiers:
    domain: id.tangoatlas.org
  attrs:
    branding_title: TangoAtlas Passport
    flow_authentication: !KeyOf flow-auth      # ← auth flow
    flow_recovery: !KeyOf flow-recovery        # ← recovery flow (shows on login page)
    flow_invalidation: null                    # optional
```

`flow_recovery` on the brand is what makes "Forgot password?" appear on the login page. Setting `recovery_flow` on the IdentificationStage is the companion setting that routes the stage's link to the correct flow.

## References

Use the bundled source map in [references/oss-doc-map.md](./references/oss-doc-map.md) to choose the right upstream page before answering.

Use [references/ansible-iac-patterns.md](./references/ansible-iac-patterns.md) when the user wants a practical Ansible management pattern for Authentik.