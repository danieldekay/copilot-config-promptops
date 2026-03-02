#!/bin/bash

echo "=== VPS Security Verification (Expert) ==="

# Check UFW
echo -n "[Check] UFW... "
if sudo ufw status | grep -q "Status: active"; then
    echo "✅ Active"
else
    echo "❌ Inactive (Run 'sudo ufw enable')"
fi

# Check Unattended Upgrades
echo -n "[Check] Unattended Upgrades... "
if systemctl is-active --quiet unattended-upgrades; then
    echo "✅ Running"
else
    echo "❌ Stopped/Not Installed"
fi

# Check Sysctl Hardening
echo -n "[Check] Sysctl Hardening... "
if /sbin/sysctl net.ipv4.conf.all.rp_filter | grep -q "1"; then
    echo "✅ Applied"
else
    echo "❌ Not applied (Check /etc/sysctl.d/99-security.conf)"
fi

# Check SSH Restriction
echo -n "[Check] SSH Public Access... "
if sudo ufw status | grep -E "^22(/tcp)? +ALLOW +Anywhere" > /dev/null; then
    echo "⚠️  STILL OPEN (Public). Recommended: restrict to Tailscale."
else
    echo "✅ Restricted (Secure)"
fi

# Check Traefik Permissions (Critical)
echo -n "[Check] Traefik acme.json permissions... "
ACME_FILE="$HOME/app-data/traefik/letsencrypt/acme.json"
if [ -f "$ACME_FILE" ]; then
    PERM=$(stat -c "%a" "$ACME_FILE")
    if [ "$PERM" = "600" ]; then
        echo "✅ Correct (600)"
    else
        echo "❌ Unsafe ($PERM) - Run: chmod 600 $ACME_FILE"
    fi
else
    echo "⚠️  File not found (Is Traefik set up?)"
fi

# Check Tailscale
echo -n "[Check] Tailscale... "
if tailscale status > /dev/null 2>&1; then
    echo "✅ Connected"
else
    echo "❌ Not connected"
fi

# Check Docker & Containers
echo "[Check] Critical Containers/Services:"
for container in traefik watchtower; do
    echo -n "  - $container (Docker)... "
    if docker ps --format '{{.Names}}' | grep -q "$container"; then
        echo "✅ Up"
    else
        echo "⚠️  Not found or stopped"
    fi
done

echo -n "  - crowdsec... "
if docker ps --format '{{.Names}}' | grep -q "crowdsec"; then
    echo "✅ Up (Docker)"
elif systemctl is-active --quiet crowdsec; then
    echo "✅ Up (Systemd)"
else
    echo "⚠️  Not found or stopped"
fi

echo "=== Verification Complete ==="