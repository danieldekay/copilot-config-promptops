# Authentik Ansible IaC Patterns

Reviewed: 2026-03-08 CET

This reference translates the Authentik community docs into Ansible-friendly operating patterns.

## Default Recommendation

For self-hosted Authentik managed with Ansible:

1. Manage container runtime config with Ansible templates.
2. Manage Authentik objects with file-backed blueprints.
3. Use manual outposts if Ansible owns container lifecycle.
4. Use UI export only to migrate existing click-configured state into blueprints.
5. Use the blueprint API or database-backed blueprints only if filesystem-based control is not feasible.

## Control Plane Choices

| Concern | Preferred control plane | Why |
|--------|--------------------------|-----|
| Container images, ports, volumes, networks | Ansible + Compose templates | This is infrastructure, not Authentik object state |
| Secrets and env vars | Ansible-managed `.env` or mounted secret files | Matches Compose and Authentik config model |
| Flows, stages, policies, apps, providers, groups, roles | File-backed blueprints | Native Authentik config-as-code |
| Outpost containers when central automation is desired inside Authentik | Docker integration | Authentik can auto-manage and auto-upgrade them |
| Outpost containers when Ansible is source of truth | Manual outpost Compose definitions | Keeps lifecycle under Ansible control |
| Bootstrap from an existing hand-built instance | `ak export_blueprint` + cleanup | Converts UI state into git-managed YAML |

## Recommended Role Shape

```text
roles/custom/authentik/
├── defaults/main.yml
├── tasks/
│   ├── main.yml
│   ├── install.yml
│   ├── config.yml
│   ├── blueprints.yml
│   ├── outposts.yml
│   └── verify.yml
├── templates/
│   ├── compose.yml.j2
│   ├── authentik.env.j2
│   └── blueprints/
│       ├── 10-groups.yaml.j2
│       ├── 20-providers.yaml.j2
│       └── 30-applications.yaml.j2
└── handlers/main.yml
```

## Recommended Deployment Pattern

### 1. Compose and environment

Manage the container runtime declaratively with Ansible:

- `compose.yml`
- `.env`
- bind mounts for blueprint directories
- optional secret file mounts used with `file://...`

Suggested responsibilities:

- Compose template defines images, volumes, networks, and mounts.
- `.env` template defines `PG_PASS`, `AUTHENTIK_SECRET_KEY`, ports, and Authentik env settings.
- Secret values should come from the deployment secret store, not from hardcoded YAML.

### 2. Blueprint mount strategy

Mount a custom blueprint directory into the worker container under `/blueprints` or a subdirectory inside it.

Operational behavior from the docs:

- new blueprint file: discovery triggers automatically
- modified blueprint file: apply triggers automatically
- periodic reconciliation: blueprint instances are re-read approximately every 60 minutes

This means Ansible can usually manage blueprint files without having to call a separate apply command.

## Blueprint Authoring Guidance

### Header and schema

Start blueprint files with:

```yaml
# yaml-language-server: $schema=https://goauthentik.io/blueprints/schema.json
version: 1
```

### State selection

Use `state` intentionally:

- `present` for managed objects that should reconcile to the declared fields
- `created` when initial creation should happen once but later UI changes should survive
- `must_created` when duplicates indicate a real error
- `absent` for controlled deletion

### Dependency control

Blueprint file ordering is not guaranteed. If blueprint A depends on objects from blueprint B, use blueprint meta models instead of relying on filename sort order alone.

### Export cleanup workflow

When migrating existing UI-managed state:

1. Run `docker compose run --rm worker ak export_blueprint`
2. Split the large export into smaller intent-based files
3. Remove hardcoded primary keys where possible
4. Reintroduce identifiers, context, and tags deliberately
5. Re-add secrets and other write-only fields from Ansible-managed variables

## Outpost Decision Rule

Choose one owner for outposts.

### Option A: Authentik owns outposts

Use Docker integration when:

- the worker is allowed to access the Docker API
- automatic outpost upgrades with Authentik upgrades are desired
- infrastructure ownership inside Authentik is acceptable

Security implications:

- Docker API permissions are required
- Docker socket access should be treated as sensitive
- Docker Socket Proxy is preferable to a raw socket mount

### Option B: Ansible owns outposts

Use manual outposts when:

- container lifecycle must stay in Ansible
- networks, labels, and ports are already standardized in infra code
- host hardening avoids giving Authentik Docker API control

Required environment values in manual Compose snippets typically include:

- `AUTHENTIK_HOST`
- `AUTHENTIK_INSECURE`
- `AUTHENTIK_TOKEN`

## Hardening Pattern

If blueprints should only be changed from git-managed files, the hardening docs recommend blocking:

```text
/api/v3/managed/blueprints
```

This makes the filesystem the practical edit path for blueprints. If you do this, ensure the mounted blueprint directory is itself tightly controlled.

## Verification Pattern

After Ansible changes, verify at two layers.

### Runtime configuration

```bash
docker compose run --rm worker ak dump_config
```

### Reconciliation and logs

```bash
docker logs authentik-worker --since 5m
docker logs authentik-server --since 5m
```

Use `debug` logging before `trace`. Reserve `trace` for difficult cases because it may expose sensitive data.