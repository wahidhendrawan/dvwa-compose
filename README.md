[![CI](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml/badge.svg)](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml)

# DVWA Docker Compose

> [!WARNING]
> **DVWA is intentionally vulnerable. NEVER expose this deployment to the internet or an untrusted LAN. Run it only on an isolated lab network; this configuration binds its web interface to `127.0.0.1` by default.**

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
cp .env.example .env
# Edit .env and replace both password placeholders with unique values.
docker compose up -d
```

Access DVWA at `https://localhost` (default credentials: `admin` / `password`). The browser TLS warning is expected for the self-signed certificate.

### Difficulty Level

Set the DVWA security difficulty in `.env`:

```bash
# Options: impossible, high, medium, low
DVWA_DIFFICULTY=medium
```

After `docker compose up`, adjust the difficulty in the DVWA UI (`DVWA Security` → select level → Submit). The `DVWA_DIFFICULTY` variable is passed to the container for startup reference.

## Architecture

```
Client (localhost only) → Nginx (TLS :443) → DVWA (PHP) → MariaDB
```

## Supported Architectures

| Architecture | Tested On |
|---|---|
| **x86_64 (amd64)** | Intel/AMD Linux, WSL2, Docker Desktop (Windows) |
| **ARM64 (aarch64)** | Apple Silicon (M1/M2/M3/M4), Raspberry Pi 4/5, AWS Graviton |

## Configuration

- **Deployment environment**: Copy `.env.example` to `.env`; `.env` is gitignored and must contain unique database passwords.
- **Nginx config**: `nginx/conf.d/default.conf`
- **TLS certificates**: `nginx/ssl/` (generate or place your own)
- **Database credentials**: Set `MYSQL_ROOT_PASSWORD`, `DVWA_DB_USER`, and `DVWA_DB_PASSWORD` in `.env`.
- **Difficulty**: Set `DVWA_DIFFICULTY` in `.env` (`low`, `medium`, `high`, `impossible` — default).
- **Image pinning**: Images use version tags; pin the corresponding digests before production use.

## Wazuh SIEM Integration

The optional `docker-compose.wazuh.yml` adds a Wazuh agent for monitoring:

```bash
# Set your Wazuh manager address in .env.
WAZUH_MANAGER=192.168.1.100

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

## Lifecycle: Setup, Reset, Teardown

### 1. Initial Setup

Bring the lab up with detached services:

```bash
# Verify the configuration first (optional)
docker compose --env-file .env.example config

# Create and start all services in the background
docker compose up --detach
```

### 2. Teardown (Stop and Remove Containers)

Stop services and remove containers, networks, and volumes:

```bash
# Stop services and remove containers/networks
docker compose down

# Also remove the MariaDB data volume (resets all DVWA data)
docker compose down --volumes
```

### 3. Resetting the Database

If DVWA's database setup fails or you need to reset it without a full teardown, use the web interface:

1.  Access `https://localhost/setup.php`
2.  Click the `Create / Reset Database` button.
3.  You will be redirected to the login page; the database is now reset.

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
