# Authentik OSS Doc Map

Reviewed: 2026-03-08 CET

This file captures the upstream community documentation pages used to shape the `authentik-open-source` skill.

## Canonical Source Rules

- Prefer `https://docs.goauthentik.io/`.
- Prefer community docs sections outside `/enterprise/`.
- Use release notes only to confirm version-specific upgrade warnings.
- Ignore pricing and support links unless the user explicitly asks for commercial support.

## Core Pages

### Blueprints and infrastructure as code

- Blueprints overview:
  - `https://docs.goauthentik.io/customize/blueprints`
  - Key facts:
    - Blueprints are Authentik's native configuration-as-code mechanism.
    - Blueprints can be stored as local files, in OCI registries, or in Authentik's database.
    - File-backed blueprints are discovered automatically and changed files are re-applied automatically.
    - Blueprint execution is atomic and rolls back fully on failure.

- Working with blueprints:
  - `https://docs.goauthentik.io/customize/blueprints/working_with_blueprints`
  - Key facts:
    - Blueprint instances can be managed from the UI or by editing YAML directly.
    - Imported flows are useful for applying packaged flows but are not the same as ongoing file-backed reconciliation.

- Export to blueprints:
  - `https://docs.goauthentik.io/customize/blueprints/export`
  - Key facts:
    - `ak export_blueprint` exports most current objects from a worker container.
    - Exports contain raw objects and usually need manual cleanup.
    - Write-only fields and some defaults are not exported.

- Blueprint file structure:
  - `https://docs.goauthentik.io/customize/blueprints/v1/structure`
  - Key facts:
    - Official schema URL: `https://goauthentik.io/blueprints/schema.json`
    - Core fields include `version`, `metadata`, `context`, `entries`, `identifiers`, `attrs`, and `state`.
    - Important labels include `blueprints.goauthentik.io/instantiate` and `blueprints.goauthentik.io/description`.
    - Discovery order is not guaranteed; dependencies should use meta models.

- Blueprint models:
  - `https://docs.goauthentik.io/customize/blueprints/v1/models`
  - Key facts:
    - Some fields are only writable through blueprints, such as token `key` and user `password`.
    - Blueprints can set permissions and certain fields that the standard API exposes differently.

### Install and configuration

- Docker Compose install:
  - `https://docs.goauthentik.io/install-config/install/docker-compose`
  - Key facts:
    - Intended for test setups and small-scale production setups.
    - Start from the upstream `compose.yml`.
    - Required bootstrap secrets are `PG_PASS` and `AUTHENTIK_SECRET_KEY`.
    - Optional `.env` values include `AUTHENTIK_ERROR_REPORTING__ENABLED`, `COMPOSE_PORT_HTTP`, and `COMPOSE_PORT_HTTPS`.
    - Initial setup path must end with `/if/flow/initial-setup/` including the trailing slash.
    - Do not mount `/etc/timezone` or `/etc/localtime` into the containers.
    - Default Compose mounts the Docker socket into the worker for automatic outpost management.

- Configuration:
  - `https://docs.goauthentik.io/install-config/configuration`
  - Key facts:
    - Environment variables use double underscores to represent nested YAML settings.
    - Docker Compose changes are typically made in `.env` and applied with `docker compose up -d`.
    - `docker compose run --rm worker ak dump_config` is the primary config verification command.

- First steps:
  - `https://docs.goauthentik.io/install-config/first-steps`
  - Key facts:
    - The recommended first workflow is application + provider, then users, groups, and bindings.
    - `Create with Provider` is the simplest admin path for a first application.
    - The docs explicitly warn that the `:latest` image tag is deprecated and frozen.
    - Without bindings, users broadly get access to the application.

### Applications and providers

- Applications:
  - `https://docs.goauthentik.io/add-secure-apps/applications`
  - Key facts:
    - Applications govern visibility and access on `My applications`.
    - Applications and providers are the two halves of the same integration model.
    - Some cases use extra providers as backchannel providers.

- Providers:
  - `https://docs.goauthentik.io/providers`
  - Key facts:
    - Providers are protocol and auth mechanism definitions.
    - Common provider families include OAuth2/OIDC, SAML, LDAP, Proxy, RADIUS, and SCIM.
    - SAML provider setup can be bootstrapped from SP metadata XML.

### Outposts

- Manual outpost deployment with Docker Compose:
  - `https://docs.goauthentik.io/add-secure-apps/outposts/manual-deploy-docker-compose`
  - Key facts:
    - Authentik documents manual Compose snippets for proxy, LDAP, RAC, and RADIUS outposts.
    - Manual deployment needs `AUTHENTIK_HOST`, `AUTHENTIK_INSECURE`, and an Authentik-generated token.
    - The outpost container must be able to reach the core Authentik server and, when relevant, the protected app.

- Docker outpost integration:
  - `https://docs.goauthentik.io/add-secure-apps/outposts/integrations/docker`
  - Key facts:
    - Authentik can create and manage outposts through the Docker HTTP API.
    - This enables automatic outpost upgrades together with Authentik upgrades.
    - Docker socket access is sensitive; Docker Socket Proxy is the safer documented pattern.

### Upgrades and troubleshooting

- Upgrade guide:
  - `https://docs.goauthentik.io/install-config/upgrade`
  - Key facts:
    - Downgrades are unsupported.
    - PostgreSQL backup is required before upgrades.
    - Major upgrades must be performed sequentially.
    - Outposts must be upgraded with the core instance and versions must match.
    - For Docker Compose, refresh `compose.yml`, then run `docker compose pull` and `docker compose up -d`.

- Logs:
  - `https://docs.goauthentik.io/troubleshooting/logs`
  - Key facts:
    - Valid log levels are `debug`, `info`, `warning`, `error`, and `trace`.
    - `trace` can expose sensitive data, including session cookies.
    - `docker logs --since ...` and `docker logs -f` are the primary Docker troubleshooting commands.

- Hardening:
  - `https://docs.goauthentik.io/security/security-hardening/`
  - Key facts:
    - Blocking `/api/v3/managed/blueprints` prevents blueprint changes through the API.
    - With that restriction, blueprints are effectively edited through the filesystem only.
    - This is a strong fit for git-managed, file-backed blueprint workflows.

## Tavily Workflow

Use Tavily tools to stay grounded in current docs:

1. `mcp_tavily-search_tavily_map`
   - Map `https://docs.goauthentik.io/` to find the relevant OSS sections.

2. `mcp_tavily-search_tavily_crawl`
   - Crawl focused paths like:
     - `/customize/blueprints/.*`
     - `/install-config/.*`
     - `/add-secure-apps/.*`
     - `/core/architecture.*`
     - `/security/.*`
     - `/troubleshooting/.*`
   - Exclude `/enterprise/.*` unless the user explicitly asks for Enterprise.

3. `mcp_tavily-search_tavily_extract`
   - Extract only the exact pages needed for the current question.

4. Synthesize
   - Answer from the extracted pages.
   - Keep the answer scoped to the user's deployment method.
   - Call out one concrete verification step and one concrete risk or gotcha.

## Safe Defaults for Answers

- Prefer Docker Compose guidance when the user does not specify a platform but mentions `compose.yml`, `.env`, or containers.
- Prefer blueprints over click paths when the user mentions Ansible, Git-managed configuration, or repeatable setup.
- Prefer the admin UI path `Create with Provider` for first-time discovery or bootstrap guidance only.
- Prefer `debug` over `trace` for logging unless the problem clearly requires deeper inspection.
- Prefer manual outposts or a Docker Socket Proxy when discussing hardening around the default Docker socket mount.