# Docker Compose Templates

## Traefik (Reverse Proxy)

Use this configuration to set up Traefik. It handles SSL certificates automatically and routes traffic to your containers.

**Security Note:** The Dashboard is disabled publicly by default.

```yaml
services:
  traefik:
    # ALWAYS check for the latest stable version: https://hub.docker.com/_/traefik
    image: traefik:v3 # Pulls the latest v3.x release
    container_name: traefik
    command:
      - "--api.dashboard=true" # Enable Dashboard logic
      - "--accesslog=true" # Enable Access Logs for Crowdsec
      - "--accesslog.filepath=/var/log/traefik/access.log"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
      - "--certificatesresolvers.myresolver.acme.email=your-email@example.com" # CHANGE THIS
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"   # HTTP (Public)
      - "443:443" # HTTPS (Public)
    volumes:
      - "./letsencrypt:/letsencrypt" # CRITICAL: Run 'touch acme.json && chmod 600 acme.json' locally first!
      - "./logs:/var/log/traefik" # Shared logs for Crowdsec
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
    networks:
      - proxy-net
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      # Watchtower update
      - "com.centurylinklabs.watchtower.enable=true"
      # SECURITY: Dashboard is NOT exposed publicly.
      # To access: Use SSH Tunnel: ssh -L 8080:localhost:8080 user@host
      # Then browse http://localhost:8080/dashboard/

networks:
  proxy-net:
    external: true
```

## Watchtower (Auto-Update Containers)

Automatically updates your running containers when new images are available.

```yaml
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true # Remove old images
      - WATCHTOWER_SCHEDULE=0 0 4 * * * # Run every day at 4am
    restart: unless-stopped
    networks:
      - proxy-net
```

## Crowdsec (Security Automation)

Crowdsec parses logs to detect attacks and blocks malicious IPs.

```yaml
services:
  crowdsec:
    image: crowdsecurity/crowdsec
    container_name: crowdsec
    environment:
      GID: "${GID-1000}"
      COLLECTIONS: "crowdsecurity/traefik crowdsecurity/linux crowdsecurity/sshd"
    volumes:
      - ./config:/etc/crowdsec:rw
      - ./data:/var/lib/crowdsec/data:rw
      - /var/log/auth.log:/var/log/auth.log:ro
      - /var/log/syslog:/var/log/syslog:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - proxy-net
    restart: unless-stopped
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

networks:
  proxy-net:
    external: true
```

## Duplicati (Backups)

Duplicati provides a web interface for managing encrypted backups.

**CRITICAL SECURITY:** We bind the port to `127.0.0.1` (Localhost) or your Tailscale IP so it is NOT exposed to the public internet. **Docker bypasses UFW**, so mapping `8200:8200` is dangerous.

```yaml
services:
  duplicati:
    image: lscr.io/linuxserver/duplicati:latest
    container_name: duplicati
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - ./config:/config
      - ./backups:/backups
      - /home/ubuntu:/source
    ports:
      # SECURE: Only allow access from the server itself (or SSH tunnel)
      # To access via Tailscale, replace 127.0.0.1 with your Tailscale IP (e.g. 100.x.y.z)
      - "127.0.0.1:8200:8200" 
    restart: unless-stopped
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      # We do NOT expose this via Traefik publicly.
      # Access via http://<Tailscale-IP>:8200
```
