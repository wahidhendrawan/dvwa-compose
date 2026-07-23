[![CI](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml/badge.svg)](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml)

# DVWA Docker Compose

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL-3.0-blue.svg)](https://github.com/wahidhendrawan/dvwa-compose/blob/main/LICENSE)
[![Release](https://img.shields.io/badge/release-v1.0.0-green.svg)](https://github.com/wahidhendrawan/dvwa-compose/releases)
[![CI](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml/badge.svg)](https://github.com/wahidhendrawan/dvwa-compose/actions)
[![Docker](https://img.shields.io/badge/docker-compose%20ready-2496ED?logo=docker&logoColor=white)](docker-compose.yml)
[![Arch](https://img.shields.io/badge/arch-x86__64%20%7C%20ARM64-green)]()

Docker Compose setup for [Damn Vulnerable Web Application (DVWA)](https://github.com/digininja/DVWA) with Nginx reverse proxy and TLS.

Works on **x86_64** and **ARM** (Apple Silicon, Raspberry Pi) — uses MariaDB which supports both architectures natively.

## Quick Start

```bash
git clone https://github.com/wahidhendrawan/dvwa-compose.git
cd dvwa-compose
docker compose up -d
```

Access DVWA at `https://localhost` (default credentials: `admin` / `password`).

### Difficulty Level

Set the DVWA security difficulty via environment variable:

```bash
# Options: impossible, high, medium, low
DVWA_DIFFICULTY=low docker compose up -d

# Or set in .env file
echo "DVWA_DIFFICULTY=medium" > .env
docker compose up -d
```

After `docker compose up`, adjust the difficulty in the DVWA UI (`DVWA Security` → select level → Submit). The `DVWA_DIFFICULTY` variable is passed to the container for startup reference.

## Architecture

```
Client → Nginx (TLS :443) → DVWA (PHP) → MariaDB
```

## Supported Architectures

| Architecture | Tested On |
|---|---|
| **x86_64 (amd64)** | Intel/AMD Linux, WSL2, Docker Desktop (Windows) |
| **ARM64 (aarch64)** | Apple Silicon (M1/M2/M3/M4), Raspberry Pi 4/5, AWS Graviton |

## Configuration

- **Nginx config**: `nginx/conf.d/default.conf`
- **TLS certificates**: `nginx/ssl/` (generate or place your own)
- **Database credentials**: edit `docker-compose.yml` environment variables
- **Difficulty**: set `DVWA_DIFFICULTY` env var (`low`, `medium`, `high`, `impossible` — default)

## Wazuh SIEM Integration

The optional `docker-compose.wazuh.yml` adds a Wazuh agent for monitoring:

```bash
# Set your Wazuh manager address
export WAZUH_MANAGER=192.168.1.100

# Launch with Wazuh agent
docker compose -f docker-compose.yml -f docker-compose.wazuh.yml up -d
```

The agent provides:
- File integrity monitoring of DVWA and MariaDB logs
- Container activity auditing
- Alert correlation with SIEM

## Generate Self-Signed TLS Certificate

```bash
mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/dvwa.key -out nginx/ssl/dvwa.crt \
  -subj "/CN=localhost"
```

## Troubleshooting

| Issue | Solution |
|---|---|
| Connection refused | Wait ~30s for MariaDB to initialize, then retry |
| TLS warning | Accept self-signed certificate in browser |
| Database error | `docker compose down -v && docker compose up -d` (recreate volumes) |
| ARM compatibility | All images are multi-arch — verify Docker `platform` defaults |

## Stop

```bash
docker compose down
docker compose down -v  # also remove database volume
```

## License

This project is provided under the GPL-3.0-or-later license.
