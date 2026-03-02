# Security Concepts & The Threat Landscape

## ⚠️ The Stakes: Why Security Matters
Before typing a single command, understand what we are fighting against.
An unsecured VPS connected to the internet is typically scanned and attacked within **minutes**.

*   **Botnets:** Hackers infect servers to use your bandwidth for DDoS attacks.
*   **Cryptomining:** They use your CPU to mine crypto, slowing your apps and potentially getting your VPS banned by the provider.
*   **Ransomware:** They encrypt your data (databases, photos) and demand payment.
*   **Data Theft:** If you host personal data, it can be stolen and leaked.

---

## The Layers of Defense

### 1. SSH Keys & Hardening (Identity Layer)
**The Concept:** Instead of a password (which can be guessed), you use a cryptographic key pair.
**Why:** Passwords are the weakest link. Disabling them makes brute-force attacks mathematically impossible.

### 2. Unattended Upgrades (Maintenance Layer)
**The Concept:** Automatic daily security updates for Linux.
**Why:** Security is a race. If a vulnerability is found in Linux (like "Log4Shell"), bots exploit it instantly. We want the server to patch itself while you sleep.

### 3. Sysctl & UFW (Network Layer)
**The Concept:** Hardening the Linux Kernel and using a Firewall (Default Deny).
**Why:** We close all "doors" (ports) except the ones we strictly need. We also tweak the kernel to ignore "network noise" that attackers use to crash servers.

### 4. Tailscale (VPN / Obscurity Layer)
**The Concept:** A private, encrypted network mesh.
**Why:** It allows you to access sensitive ports (SSH, Databases) without exposing them to the public internet. It turns your server "invisible" for management tasks.

### 5. Traefik (Application Gateway)
**The Concept:** A Reverse Proxy that handles HTTPS.
**Why:** It ensures all web traffic is encrypted and directs users to the right container without exposing the container directly to the web.

### 6. Crowdsec (Active Defense)
**The Concept:** An Intrusion Prevention System (IPS).
**Why:** Passive walls aren't enough. Crowdsec watches logs. If IP `1.2.3.4` tries 10 passwords in 1 second, Crowdsec bans it instantly and shares that info with the community.
