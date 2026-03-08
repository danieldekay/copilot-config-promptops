---
name: authentik-management
description: Use when deploying or operating self-hosted Authentik as infrastructure, especially through Ansible playbooks, Docker Compose, Traefik, PostgreSQL, Redis, backups, upgrades, outposts, and production service validation. Prefer this skill when the user wants to build or run Authentik automation on servers, template compose or env files, manage host-level integrations, or handle operational changes beyond documentation lookup.
---

# Authentik Identity Provider Management

## Overview

Authentik is a modern identity and access management platform providing single sign-on (SSO), OAuth2/OIDC provider capabilities, LDAP integration, and flexible authentication flows. This skill covers complete lifecycle management of Authentik 2025.12.3 in production Docker environments.

This is the infrastructure-and-operations skill for Authentik. Use it for deployment, playbooks, runtime topology, secrets, health checks, backup, restore, upgrades, and production operations.

If the task is primarily about reading the upstream community documentation correctly, choosing the right blueprint pattern, or staying inside the Authentik OSS docs model, also load [../authentik-open-source/SKILL.md](../authentik-open-source/SKILL.md).

## When to Use

**Deployment & Infrastructure:**
- Deploy Authentik via Ansible to production servers
- Configure Traefik reverse proxy integration
- Set up PostgreSQL backend and Redis caching
- Manage Docker Compose orchestration

**User & Access Management:**
- Create/manage users, groups, and permissions
- Configure authentication flows and policies
- Set up MFA/2FA requirements
- Manage user lifecycle and provisioning

**Application Integration:**
- Configure OAuth2/OIDC applications
- Set up SAML providers
- Integrate external services with SSO
- Manage application access policies

**Operations:**
- Implement automated backup/restore
- Monitor service health and performance
- Troubleshoot authentication failures
- Perform version upgrades

## Architecture Overview

### Deployment Architecture

```yaml
# Docker Compose stack on rs1000-g12
services:
  authentik-server:     # Web UI and API
  authentik-worker:     # Background tasks
  authentik-postgres:   # Database backend
  authentik-redis:      # Cache and message broker
```

**Network Integration:**
- Traefik reverse proxy (traefik_proxy network)
- Let's Encrypt automatic SSL via HTTP-01 challenge
- External access via HTTPS only (port 443)

**Storage:**
- Docker named volumes for PostgreSQL data
- Bind mounts for configuration files
- Hetzner Storage Box for backups

### Key Components

1. **Server Container**: Handles web interface, API requests, authentication flows
2. **Worker Container**: Processes background tasks (notifications, scheduled jobs, LDAP sync)
3. **PostgreSQL Database**: Stores users, applications, sessions, and configuration
4. **Redis**: Caching layer and message queue between server and worker

## Deployment via Ansible

### Prerequisites Checklist

```yaml
Infrastructure:
  - Target server accessible via SSH
  - Traefik reverse proxy operational with traefik_proxy network
  - DNS: Domain resolves to server IP
  - Backup storage mounted (/mnt/storage-box)
  - Docker Engine 20.10+ and Docker Compose v2.x

Local Environment:
  - Ansible 2.15+ installed
  - 1Password CLI authenticated (op whoami)
  - Repository cloned to ansible workspace
  - Python environment active (uv sync)
```

### 1Password Secret Structure

**Create these items in "Infrastructure" vault:**

```yaml
authentik-db:
  type: Password
  fields:
    password: $(openssl rand -base64 32)

authentik-admin:
  type: Password
  fields:
    username: admin
    email: admin@yourdomain.org
    password: $(openssl rand -base64 32)
    token: $(openssl rand -hex 32)

authentik-config:
  type: Password
  fields:
    secret_key: $(python -c "import secrets; print(secrets.token_urlsafe(50))")
```

### Ansible Role Structure

```
roles/custom/authentik_deploy/
├── defaults/main.yml          # Default variables
├── tasks/
│   ├── main.yml              # Entry point
│   ├── prepare.yml           # Directory setup, volume creation
│   ├── deploy.yml            # Docker Compose deployment
│   ├── validate.yml          # Health checks
│   └── bootstrap.yml         # Admin account setup
├── templates/
│   ├── docker-compose.yml.j2 # Service definitions
│   ├── authentik.env.j2      # Application environment
│   └── postgres.env.j2       # Database environment
└── README.md                 # Documentation
```

### Key Variables

```yaml
# Required variables
authentik_domain: "id.yourdomain.org"
authentik_version: "2025.12.3"

# Admin account (from 1Password)
authentik_admin_email: "admin@yourdomain.org"
authentik_admin_username: "admin"
authentik_admin_password: "{{ lookup('community.general.onepassword', 'authentik-admin', field='password', vault='Infrastructure') }}"
authentik_admin_token: "{{ lookup('community.general.onepassword', 'authentik-admin', field='token', vault='Infrastructure') }}"

# Database credentials (from 1Password)
authentik_db_password: "{{ lookup('community.general.onepassword', 'authentik-db', field='password', vault='Infrastructure') }}"

# Application secrets (from 1Password)
authentik_secret_key: "{{ lookup('community.general.onepassword', 'authentik-config', field='secret_key', vault='Infrastructure') }}"

# Optional settings
authentik_log_level: "info"          # debug, info, warning, error
authentik_worker_count: 2            # Background workers
authentik_deployment_path: "/opt/services/authentik"
authentik_network_name: "traefik_proxy"
```

### Docker Compose Template Pattern

```yaml
# templates/docker-compose.yml.j2
services:
  server:
    image: ghcr.io/goauthentik/server:{{ authentik_version }}
    container_name: authentik-server
    restart: unless-stopped
    command: server
    environment:
      AUTHENTIK_REDIS__HOST: redis
      AUTHENTIK_POSTGRESQL__HOST: postgres
      AUTHENTIK_POSTGRESQL__NAME: authentik
      AUTHENTIK_POSTGRESQL__USER: authentik
      AUTHENTIK_POSTGRESQL__PASSWORD: "{{ authentik_db_password }}"
      AUTHENTIK_SECRET_KEY: "{{ authentik_secret_key }}"
      AUTHENTIK_LOG_LEVEL: "{{ authentik_log_level }}"
    volumes:
      - authentik_media:/media
      - authentik_templates:/templates
    networks:
      - {{ authentik_network_name }}
      - authentik_internal
    labels:
      # Traefik routing
      - "traefik.enable=true"
      - "traefik.http.routers.authentik.rule=Host(`{{ authentik_domain }}`)"
      - "traefik.http.routers.authentik.entrypoints=websecure"
      - "traefik.http.routers.authentik.tls.certresolver=letsencrypt"
      - "traefik.http.services.authentik.loadbalancer.server.port=9000"
      # Security headers
      - "traefik.http.middlewares.authentik-headers.headers.stsSeconds=31536000"
      - "traefik.http.middlewares.authentik-headers.headers.stsIncludeSubdomains=true"
      - "traefik.http.routers.authentik.middlewares=authentik-headers"

  worker:
    image: ghcr.io/goauthentik/server:{{ authentik_version }}
    container_name: authentik-worker
    restart: unless-stopped
    command: worker
    environment:
      AUTHENTIK_REDIS__HOST: redis
      AUTHENTIK_POSTGRESQL__HOST: postgres
      AUTHENTIK_POSTGRESQL__NAME: authentik
      AUTHENTIK_POSTGRESQL__USER: authentik
      AUTHENTIK_POSTGRESQL__PASSWORD: "{{ authentik_db_password }}"
      AUTHENTIK_SECRET_KEY: "{{ authentik_secret_key }}"
      AUTHENTIK_LOG_LEVEL: "{{ authentik_log_level }}"
    volumes:
      - authentik_media:/media
      - authentik_templates:/templates
      - authentik_certs:/certs
    networks:
      - authentik_internal

  postgres:
    image: postgres:16-alpine
    container_name: authentik-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: authentik
      POSTGRES_USER: authentik
      POSTGRES_PASSWORD: "{{ authentik_db_password }}"
    volumes:
      - authentik_postgres_data:/var/lib/postgresql/data
    networks:
      - authentik_internal
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U authentik"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: authentik-redis
    restart: unless-stopped
    networks:
      - authentik_internal
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

volumes:
  authentik_postgres_data:
  authentik_media:
  authentik_templates:
  authentik_certs:

networks:
  authentik_internal:
  {{ authentik_network_name }}:
    external: true
```

### Admin Bootstrapping

Authentik 2025.12.3 uses environment variables for initial setup:

```yaml
# templates/authentik.env.j2
AUTHENTIK_BOOTSTRAP_PASSWORD={{ authentik_admin_password }}
AUTHENTIK_BOOTSTRAP_TOKEN={{ authentik_admin_token }}
AUTHENTIK_BOOTSTRAP_EMAIL={{ authentik_admin_email }}
```

These are read on first startup. Subsequent changes must be made through the admin UI or API.

### Deployment Commands

```bash
# Navigate to ansible workspace
cd /Users/dekay/Dokumente/projects/servers/ansible

# Authenticate with 1Password
eval $(op signin)

# Set become password
export ANSIBLE_BECOME_PASS=$(op item get <item-id> --fields password --reveal)

# Run playbook with check mode first (dry run)
uv run ansible-playbook playbooks/g12/authentik-deploy.yml \
  -i inventories/netcup/hosts.yml \
  --check --diff

# Execute deployment
uv run ansible-playbook playbooks/g12/authentik-deploy.yml \
  -i inventories/netcup/hosts.yml

# Verify deployment
curl -I https://id.yourdomain.org
curl https://id.yourdomain.org/-/health/live/
ssh user@rs1000-g12 'docker ps | grep authentik'
```

### Post-Deployment Validation

```bash
# Check all containers are running
docker ps --filter "name=authentik"

# Expected output: 4 containers (server, worker, postgres, redis)
# All with status "Up" and healthy

# Check logs for errors
docker logs authentik-server | grep -i error
docker logs authentik-worker | grep -i error

# Test admin access
# Navigate to https://id.yourdomain.org/if/flow/initial-setup/
# Login with credentials from 1Password authentik-admin item

# Verify SSL certificate
openssl s_client -connect id.yourdomain.org:443 -servername id.yourdomain.org | grep -A2 "Certificate chain"
```

## User & Group Management

### Creating Users via Admin UI

**Navigation**: Admin Interface → Directory → Users → Create

**Required Fields:**
- Username (unique identifier)
- Name (display name)
- Email (for password resets and notifications)
- Path (organizational hierarchy, default: "users")

**Optional Fields:**
- Groups membership
- Attributes (custom JSON metadata)
- Active status

### User Creation via API

```bash
# Get admin token from 1Password
TOKEN=$(op item get authentik-admin --fields token --reveal)

# Create user
curl -X POST https://id.yourdomain.org/api/v3/core/users/ \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john.doe",
    "name": "John Doe",
    "email": "john.doe@yourdomain.org",
    "is_active": true,
    "path": "users",
    "type": "internal"
  }'
```

### Group Management

**Best Practices:**
- Use groups for permission management (not individual users)
- Create hierarchical groups matching organizational structure
- Assign application access at group level

**Common Group Structure:**
```
users/
├── staff/
│   ├── admins/
│   ├── developers/
│   └── support/
└── external/
    ├── contractors/
    └── partners/
```

### Managing User Lifecycle

**Account Creation:**
1. Create user account (UI or API)
2. Add to appropriate groups
3. Set password (or send invitation email)
4. Assign application access via group policies

**Offboarding:**
1. Deactivate account (don't delete immediately)
2. Revoke active sessions
3. Remove from all groups
4. Archive after 90 days retention period

## Application Integration (OAuth2/OIDC)

### Registering an Application

**Navigation**: Admin Interface → Applications → Providers → Create

**Provider Type Selection:**
- **OAuth2/OpenID Connect**: Most modern applications
- **SAML**: Legacy enterprise applications
- **Proxy**: Applications without native SSO support
- **LDAP**: Legacy applications requiring LDAP

### OAuth2/OIDC Configuration Example

```yaml
Application:
  Name: "Production Dashboard"
  Slug: "prod-dashboard"
  Provider Type: OAuth2/OpenID Connect Provider

Provider Settings:
  Authorization Flow: "Explicit Consent"
  Client Type: "Confidential"
  Client ID: <auto-generated>
  Client Secret: <auto-generated, store in 1Password>
  Redirect URIs:
    - https://dashboard.yourdomain.org/auth/callback
    - https://dashboard.yourdomain.org/login/callback
  Signing Key: <auto-generated>

  Scopes:
    - openid
    - profile
    - email
    - groups

  Subject Mode: "Based on the User's hashed ID"
  Include Claims in ID Token: true
```

### Integration Pattern (Application Side)

```python
# Example: Python FastAPI application
from authlib.integrations.starlette_client import OAuth

oauth = OAuth()
oauth.register(
    name='authentik',
    client_id='<CLIENT_ID>',
    client_secret='<CLIENT_SECRET>',
    server_metadata_url='https://id.yourdomain.org/application/o/<SLUG>/.well-known/openid-configuration',
    client_kwargs={
        'scope': 'openid profile email groups'
    }
)

# Login route
@app.get('/login')
async def login(request: Request):
    redirect_uri = request.url_for('auth')
    return await oauth.authentik.authorize_redirect(request, redirect_uri)

# Callback route
@app.get('/auth')
async def auth(request: Request):
    token = await oauth.authentik.authorize_access_token(request)
    user = token.get('userinfo')
    # Store user session
    return user
```

### Testing Application Integration

```bash
# Test OIDC discovery endpoint
curl https://id.yourdomain.org/application/o/<SLUG>/.well-known/openid-configuration

# Expected: JSON with authorization_endpoint, token_endpoint, jwks_uri, etc.

# Test authorization flow (browser-based)
# 1. Navigate to: https://id.yourdomain.org/application/o/authorize/?client_id=<ID>&redirect_uri=<URI>&response_type=code&scope=openid
# 2. Authenticate as user
# 3. Verify redirect to application with authorization code
```

## Backup & Restore Procedures

### Automated Backup Strategy

**Components to Backup:**
1. **PostgreSQL Database** (critical, daily)
2. **Media Files** (important, weekly)
3. **Configuration Files** (critical, with code changes)
4. **Certificates** (optional, can be regenerated)

### Database Backup via Ansible

```yaml
# roles/authentik_backup/tasks/main.yml
- name: Create backup directory
  file:
    path: "/mnt/storage-box/backups/authentik/{{ ansible_date_time.date }}"
    state: directory
    mode: '0755'

- name: Backup PostgreSQL database
  community.docker.docker_container_exec:
    container: authentik-postgres
    command: >
      pg_dump -U authentik authentik
      --no-owner
      --no-acl
      --clean
      --if-exists
      --format=custom
      --file=/tmp/authentik-backup.dump
  register: pg_dump_result

- name: Copy backup from container
  command: >
    docker cp authentik-postgres:/tmp/authentik-backup.dump
    /mnt/storage-box/backups/authentik/{{ ansible_date_time.date }}/authentik-db.dump

- name: Backup Docker volumes (media files)
  community.docker.docker_container:
    name: authentik-backup-temp
    image: alpine:latest
    command: tar czf /backup/authentik-media.tar.gz -C /media .
    volumes:
      - "authentik_media:/media:ro"
      - "/mnt/storage-box/backups/authentik/{{ ansible_date_time.date }}:/backup"
    auto_remove: yes
    detach: no
```

### Manual Backup Commands

```bash
# SSH to server
ssh user@rs1000-g12

# Backup database
docker exec authentik-postgres pg_dump -U authentik authentik \
  --no-owner --no-acl --clean --if-exists \
  --format=custom \
  --file=/tmp/authentik-$(date +%Y%m%d).dump

# Copy to backup storage
docker cp authentik-postgres:/tmp/authentik-$(date +%Y%m%d).dump \
  /mnt/storage-box/backups/authentik/

# Backup media files
docker run --rm \
  --volumes-from authentik-server \
  -v /mnt/storage-box/backups/authentik:/backup \
  alpine tar czf /backup/authentik-media-$(date +%Y%m%d).tar.gz -C /media .
```

### Restore Procedure

**Critical: Always test restores in staging environment first**

```bash
# Step 1: Stop Authentik services
cd /opt/services/authentik
docker compose stop server worker

# Step 2: Restore database
# Copy backup file to container
docker cp /mnt/storage-box/backups/authentik/YYYY-MM-DD/authentik-db.dump \
  authentik-postgres:/tmp/restore.dump

# Drop and recreate database
docker exec -it authentik-postgres psql -U authentik postgres <<EOF
DROP DATABASE IF EXISTS authentik;
CREATE DATABASE authentik OWNER authentik;
EOF

# Restore from dump
docker exec authentik-postgres pg_restore \
  -U authentik \
  -d authentik \
  --no-owner \
  --no-acl \
  --clean \
  --if-exists \
  /tmp/restore.dump

# Step 3: Restore media files (if needed)
docker run --rm \
  --volumes-from authentik-server \
  -v /mnt/storage-box/backups/authentik:/backup \
  alpine tar xzf /backup/authentik-media-YYYYMMDD.tar.gz -C /media

# Step 4: Restart services
docker compose start server worker

# Step 5: Verify
curl https://id.yourdomain.org/-/health/live/
# Login to admin interface and verify data
```

### Backup Retention Policy

```yaml
Daily Backups:
  Retention: 7 days
  Schedule: 02:00 UTC
  Files: authentik-db-YYYYMMDD.dump

Weekly Backups:
  Retention: 4 weeks
  Schedule: Sunday 03:00 UTC
  Files: authentik-db-YYYYMMDD.dump, authentik-media-YYYYMMDD.tar.gz

Monthly Backups:
  Retention: 12 months
  Schedule: 1st day 04:00 UTC
  Files: Full snapshot (database + media + config)
```

## Health Monitoring & Troubleshooting

### Health Check Endpoints

```bash
# Liveness check (service is running)
curl https://id.yourdomain.org/-/health/live/
# Expected: {"status":"ok"}

# Readiness check (service can accept requests)
curl https://id.yourdomain.org/-/health/ready/
# Expected: {"status":"ok"}

# Detailed health status (requires authentication)
curl -H "Authorization: Bearer $TOKEN" \
  https://id.yourdomain.org/api/v3/admin/system/
```

### Monitoring via Systemd Timer

```ini
# /etc/systemd/system/authentik-health-check.service
[Unit]
Description=Authentik Health Check
After=docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/authentik-health-check.sh
User=monitor
StandardOutput=journal
StandardError=journal

# /etc/systemd/system/authentik-health-check.timer
[Unit]
Description=Check Authentik health every 5 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
```

### Health Check Script

```bash
#!/bin/bash
# /usr/local/bin/authentik-health-check.sh

DOMAIN="id.yourdomain.org"
ALERT_EMAIL="admin@yourdomain.org"
ALERT_WEBHOOK=""  # Optional Slack/Discord webhook

# Counter file for tracking failures
COUNTER_FILE="/var/lib/authentik-health/failure_count"
mkdir -p $(dirname $COUNTER_FILE)
[ -f $COUNTER_FILE ] || echo "0" > $COUNTER_FILE

# Perform health check
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN/-/health/live/)

if [ "$HTTP_CODE" != "200" ]; then
  FAILURES=$(cat $COUNTER_FILE)
  FAILURES=$((FAILURES + 1))
  echo $FAILURES > $COUNTER_FILE

  echo "Health check failed: HTTP $HTTP_CODE (attempt $FAILURES/3)"

  # Alert after 3 consecutive failures (15 minutes)
  if [ $FAILURES -ge 3 ]; then
    echo "Authentik health check FAILED after $FAILURES attempts" | \
      mail -s "ALERT: Authentik Down on $DOMAIN" $ALERT_EMAIL

    # Reset counter after alerting
    echo "0" > $COUNTER_FILE
  fi

  exit 1
else
  # Reset counter on success
  echo "0" > $COUNTER_FILE
  echo "Health check passed"
  exit 0
fi
```

### Common Issues & Solutions

**Issue: Container won't start**
```bash
# Check logs
docker logs authentik-server --tail 50
docker logs authentik-worker --tail 50

# Common causes:
# 1. Database connection failure → Check postgres container health
# 2. Missing secret key → Verify AUTHENTIK_SECRET_KEY env var
# 3. Port conflict → Check if port 9000 is already in use
# 4. Volume permission issues → Check volume ownership

# Fix permissions
docker exec authentik-server chown -R authentik:authentik /media
```

**Issue: Login page loads but authentication fails**
```bash
# Check worker logs (handles authentication flows)
docker logs authentik-worker --tail 100 | grep -i error

# Check database connectivity
docker exec authentik-postgres psql -U authentik -d authentik -c "SELECT COUNT(*) FROM authentik_core_user;"

# Verify admin credentials
docker exec authentik-server ak list_users
```

**Issue: SSL certificate not obtained**
```bash
# Check Traefik logs
docker logs traefik | grep -i authentik

# Verify DNS resolution
dig id.yourdomain.org

# Check Traefik configuration
docker exec traefik cat /etc/traefik/traefik.yml

# Common causes:
# 1. DNS not pointing to correct IP
# 2. Port 80 not accessible (HTTP-01 challenge)
# 3. Domain not in Traefik router rule
```

**Issue: OAuth2 flow fails**
```bash
# Check provider configuration
curl https://id.yourdomain.org/application/o/<SLUG>/.well-known/openid-configuration

# Verify redirect URIs are correct
# Navigate to: Admin Interface → Applications → Providers → <APP> → Redirect URIs

# Check application logs for specific error
docker logs authentik-server | grep -i oauth

# Test token endpoint
curl -X POST https://id.yourdomain.org/application/o/token/ \
  -d "grant_type=client_credentials" \
  -d "client_id=<ID>" \
  -d "client_secret=<SECRET>"
```

**Issue: Slow performance**
```bash
# Check resource usage
docker stats authentik-server authentik-worker authentik-postgres

# Optimize PostgreSQL
docker exec authentik-postgres psql -U authentik -d authentik <<EOF
VACUUM ANALYZE;
REINDEX DATABASE authentik;
EOF

# Check Redis cache
docker exec authentik-redis redis-cli INFO stats

# Increase worker count if CPU usage is high
# Edit docker-compose.yml → authentik_worker → deploy.replicas: 4
```

### Monitoring Metrics to Track

```yaml
Service Health:
  - Container uptime
  - HTTP response time (<2s for login page)
  - Health endpoint status (200 OK)
  - Database connection pool utilization

Authentication Metrics:
  - Successful logins/hour
  - Failed login attempts (monitor for attacks)
  - Active user sessions
  - OAuth2 token issuance rate

Resource Utilization:
  - CPU usage per container
  - Memory usage (watch for leaks)
  - Database size growth
  - Disk I/O on volume storage

Error Rates:
  - Application errors in logs
  - Database query failures
  - External integration failures (LDAP, SMTP)
  - Certificate renewal failures
```

## Version Upgrade Procedure

### Pre-Upgrade Checklist

- [ ] **Full backup completed and verified**
- [ ] **Review release notes** for breaking changes
- [ ] **Test upgrade in staging environment**
- [ ] **Schedule maintenance window** (announce to users)
- [ ] **Document current version** and configuration

### Upgrade Steps

```bash
# Step 1: Backup current state
cd /opt/services/authentik
docker compose exec postgres pg_dump -U authentik authentik --format=custom \
  --file=/tmp/pre-upgrade-$(date +%Y%m%d).dump
docker cp authentik-postgres:/tmp/pre-upgrade-*.dump /mnt/storage-box/backups/authentik/

# Step 2: Update version in Ansible inventory
# Edit: inventories/netcup/host_vars/rs1000-g12/authentik.yml
# Change: authentik_version: "2025.12.3" → "2026.1.0"

# Step 3: Run Ansible playbook with check mode
cd /Users/dekay/Dokumente/projects/servers/ansible
uv run ansible-playbook playbooks/g12/authentik-deploy.yml \
  -i inventories/netcup/hosts.yml \
  --check --diff

# Step 4: Execute upgrade
uv run ansible-playbook playbooks/g12/authentik-deploy.yml \
  -i inventories/netcup/hosts.yml

# Step 5: Monitor startup and run migrations
docker logs -f authentik-server
# Watch for "Authentik server started" and "Migrations applied"

# Step 6: Verify functionality
curl https://id.yourdomain.org/-/health/live/
# Test login and critical application integrations

# Step 7: Post-upgrade validation
docker exec authentik-server ak version
# Verify version matches expected

# Monitor logs for 24 hours
docker logs authentik-server --follow | grep -i error
```

### Rollback Procedure (if upgrade fails)

```bash
# Step 1: Stop new version
cd /opt/services/authentik
docker compose down

# Step 2: Restore database backup
docker exec authentik-postgres psql -U authentik postgres <<EOF
DROP DATABASE authentik;
CREATE DATABASE authentik OWNER authentik;
EOF

docker cp /mnt/storage-box/backups/authentik/pre-upgrade-*.dump \
  authentik-postgres:/tmp/restore.dump

docker exec authentik-postgres pg_restore \
  -U authentik -d authentik \
  --no-owner --no-acl --clean --if-exists \
  /tmp/restore.dump

# Step 3: Revert to previous version in Ansible
# Edit inventory: authentik_version: "2025.12.3"

# Step 4: Redeploy previous version
uv run ansible-playbook playbooks/g12/authentik-deploy.yml \
  -i inventories/netcup/hosts.yml

# Step 5: Verify rollback success
curl https://id.yourdomain.org/-/health/live/
docker exec authentik-server ak version
```

## Security Best Practices

### Secrets Management

```yaml
DO:
  - Store all secrets in 1Password
  - Use unique passwords for each service (db, admin, secret_key)
  - Rotate secrets annually (or after suspected compromise)
  - Use Ansible lookup plugins for secret injection
  - Set restrictive file permissions (600) on env files

DON'T:
  - Hardcode secrets in playbooks or templates
  - Commit secrets to version control
  - Share admin credentials across team
  - Use default passwords
  - Store secrets in plain text files on servers
```

### Access Control

```yaml
Administrative Access:
  - Limit admin accounts to IT operations team
  - Use strong passwords (20+ characters, generated)
  - Enable MFA for all admin accounts
  - Regularly audit admin actions via logs

Application Access:
  - Use group-based policies, not individual grants
  - Implement least-privilege principle
  - Review access quarterly
  - Implement session timeouts (15 minutes idle)

Network Security:
  - HTTPS only (no HTTP access)
  - Use Traefik for TLS termination
  - Restrict admin interface to VPN/trusted networks
  - Enable rate limiting on authentication endpoints
```

### Hardening Checklist

- [ ] All secrets stored in 1Password
- [ ] MFA enabled for admin accounts
- [ ] Session timeout configured (15 min)
- [ ] Failed login monitoring and alerting active
- [ ] Regular backup verification (monthly restore test)
- [ ] Security headers enabled (HSTS, CSP)
- [ ] Audit logging enabled and retained (90 days)
- [ ] Admin interface restricted to VPN/whitelist
- [ ] Database encrypted at rest (LUKS volume)
- [ ] TLS 1.3 enforced, older protocols disabled

## Blueprint Apply Without Filesystem Access

The `/blueprints/custom` bind-mount on the Authentik worker container is read-only (`ro`). The `apply_blueprint` management command validates paths against allowed directories and rejects `/tmp/`. When you cannot write to the blueprints mount (e.g., Ansible manages the host filesystem with `ro` mounts), use the Django Importer directly.

### Python script workaround

Write this script to `/tmp/ak_apply_blueprint.py` inside the worker container, then pipe blueprint YAML to it:

```python
#!/usr/bin/env python3
import sys, os
sys.path.insert(0, '/')  # manage.py at /, authentik package at /authentik/
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "authentik.root.settings")
import django
django.setup()
from authentik.blueprints.v1.importer import Importer
blueprint_yaml = sys.stdin.read()
importer = Importer.from_string(blueprint_yaml)
result = importer.validate()
print(f"Validate: {result}")
apply_result = importer.apply()
print(f"Blueprint applied successfully: {apply_result.success}")
```

Apply a blueprint:

```bash
# Deploy the script once
cat /tmp/ak_apply_blueprint.py | ssh user@host \
  "docker exec -i authentik-worker sh -c 'cat > /tmp/ak_apply_blueprint.py'"

# Strip Jinja2 raw/endraw wrappers from .j2 templates, then pipe blueprint YAML
python3 -c "
import re, sys
t = open('path/to/blueprint.yaml.j2').read()
t = re.sub(r'\{%-?\s*raw\s*-?%\}\n?', '', t)
t = re.sub(r'\{%-?\s*endraw\s*-?%\}\n?', '', t)
sys.stdout.write(t)
" | ssh user@host "docker exec -i authentik-worker python3 /tmp/ak_apply_blueprint.py"
```

Key notes:
- `sys.path.insert(0, '/')` is required — `manage.py` lives at `/`, the `authentik` package at `/authentik/`.
- This approach bypasses API token auth entirely — useful when bootstrap tokens have expired.
- The script is idempotent in the same way Authentik blueprints are: existing objects are updated, not duplicated.

### Deploying files through read-only mounts

For email templates or other files on volumes with `rw` mounts (e.g., `/templates` on the server container):

```bash
cat local-file.html | ssh user@host \
  "docker exec -i authentik-server sh -c 'cat > /templates/email/filename.html'"
```

### Redis cache flush after blueprint changes

Flow and policy data is cached in Redis. After applying a blueprint that modifies flows, stages, or policies, flush the cache:

```bash
docker exec authentik-redis redis-cli FLUSHDB
```

### API Token Management

The bootstrap token (`AUTHENTIK_BOOTSTRAP_TOKEN`) has a default expiry (~30 days). To find a valid permanent token:

```bash
# Substitute the actual user_id (akadmin is typically 1 or 6)
docker exec authentik-postgres psql -U authentik -A -t -c \
  "SELECT key, intent, expires FROM authentik_core_token
   WHERE user_id = <uid> AND (expires IS NULL OR expires > NOW());"
```

If no permanent token exists, create one in the Admin UI: Admin Interface → Directory → Tokens → Create, or use the Django shell via `docker exec -it authentik-server python3 /manage.py shell`.

## Quick Reference Commands

```bash
# Container Management
docker ps --filter "name=authentik"
docker logs -f authentik-server
docker logs -f authentik-worker
docker exec -it authentik-server /bin/bash

# Database Operations
docker exec authentik-postgres psql -U authentik -d authentik
docker exec authentik-postgres pg_dump -U authentik authentik > backup.sql

# Admin CLI (ak command)
docker exec authentik-server ak list_users
docker exec authentik-server ak create_admin_group
docker exec authentik-server ak version

# Health Checks
curl https://id.yourdomain.org/-/health/live/
curl https://id.yourdomain.org/-/health/ready/
docker inspect authentik-server | jq '.[0].State.Health'

# Maintenance
docker exec authentik-postgres psql -U authentik -d authentik -c "VACUUM ANALYZE;"
docker exec authentik-redis redis-cli FLUSHALL  # Clears cache
docker compose restart server worker  # Restart application

# Logs Analysis
docker logs authentik-server | grep -i error
docker logs authentik-worker | grep -i "failed"
journalctl -u docker.service | grep authentik

# Certificate Management
openssl s_client -connect id.yourdomain.org:443 -servername id.yourdomain.org
docker exec traefik cat /data/acme.json | jq '.letsencrypt.Certificates[] | select(.domain.main=="id.yourdomain.org")'
```

## Reference Documentation

- **Official Docs**: https://docs.goauthentik.io/
- **Release Notes**: https://github.com/goauthentik/authentik/releases
- **API Reference**: https://id.yourdomain.org/api/v3/schema/swagger-ui/
- **Docker Hub**: https://hub.docker.com/r/goauthentik/server
- **Community**: https://github.com/goauthentik/authentik/discussions

## Related Skills

- `ansible-automation` - General Ansible practices
- `ansible-expert` - Advanced Ansible patterns
- `secure-vps-setup` - Server hardening
- `cloudflare-dns` - DNS management
- `debian-linux-triage` - OS troubleshooting
- `django-security` - Web application security (Authentik is Django-based)
