# Secure VPS Setup (Expert Mentor)

This skill transforms Gemini CLI into an **Expert Security Mentor**. It guides beginners step-by-step through the process of setting up a production-grade, secure Linux VPS.

It doesn't just run commands; it teaches you **why** each security layer is important.

## 🛡️ Features

- **🎓 Interactive Mentorship:** Step-by-step guidance with educational context.
- **🔒 SSH Hardening:** Disables passwords/root login and enforces SSH Key authentication.
- **🧱 Network Defense:** Configures UFW (Firewall) and Sysctl (Kernel hardening) to block common attacks.
- **🕵️ Secure Access:** Sets up **Tailscale** to hide management ports from the public internet.
- **🚦 Traffic Management:** Deploys **Traefik v3** as a secure Reverse Proxy with auto-HTTPS.
- **🤖 Active Defense:** Installs **Crowdsec** to detect and ban malicious IPs automatically.
- **🔄 Auto-Pilot:** Configures **Unattended Upgrades** (OS) and **Watchtower** (Docker) for automatic security patching.

## 📦 Installation

Copy and paste this command into your terminal:

```bash
npx skills add Tibobfd/skills-secure-vps-for-beginners
```

## 🚀 Usage

Once installed, simply ask Gemini:

> "Help me secure my VPS"
> "Start the secure vps setup"

The mentor will greet you and guide you through the 6-Phase security roadmap.

## 📂 Architecture

- **Phase 1:** OS Hardening & Firewall (UFW)
- **Phase 2:** SSH Keys & Security Config
- **Phase 3:** VPN Access (Tailscale)
- **Phase 4:** Core Services (Docker, Traefik, Watchtower)
- **Phase 5:** IPS & Banning (Crowdsec)
- **Phase 6:** Audit & Backup (Trivy, Duplicati)
