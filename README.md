# DVWA Docker Compose

[![CI](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml/badge.svg)](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/wahidhendrawan/dvwa-compose?sort=semver)](https://github.com/wahidhendrawan/dvwa-compose/releases/latest)
[![License](https://img.shields.io/github/license/wahidhendrawan/dvwa-compose)](LICENSE)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/wahidhendrawan/dvwa-compose/badge)](https://scorecard.dev/viewer/?uri=github.com/wahidhendrawan/dvwa-compose)
[![Docker](https://img.shields.io/badge/docker-compose%20ready-2496ED?logo=docker&logoColor=white)](docker-compose.yml)

> [!WARNING]
> **DVWA is intentionally vulnerable. NEVER expose this deployment to the internet or an untrusted LAN. Run it only on an isolated lab network; this configuration binds its web interface to `127.0.0.1` by default.**

Docker Compose setup for [Damn Vulnerable Web Application (DVWA)](https://github.com/digininja/DVWA) with Nginx reverse proxy and TLS.

Works on **x86_64** and **ARM** (Apple Silicon, Raspberry Pi). MariaDB and Nginx run natively on both; the DVWA image is published for amd64 only, so on ARM it runs under emulation (Docker Desktop does this out of the box; on Linux install QEMU binfmt, e.g. `docker run --privileged --rm tonistiigi/binfmt --install amd64`).

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

DVWA keeps the difficulty in a per-browser `security` cookie that starts at `impossible`, so it cannot be preset from `.env`. After logging in, choose the level in the DVWA UI (`DVWA Security` → select `low`, `medium`, `high` or `impossible` → Submit).

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
- **Difficulty**: Set per browser in the DVWA UI (see [Difficulty Level](#difficulty-level)); `impossible` is the default.
- **Image pinning**: Every image is pinned as `tag@sha256:digest`; update tag and digest together when upgrading.

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

> [!CAUTION]
> The agent runs with host-level access: it mounts `/var/run/docker.sock` (the `:ro` flag does not restrict Docker API calls, so this is root-equivalent control of the host's Docker daemon), shares the host PID namespace (`pid: host`), and adds the `SYS_ADMIN`, `SYS_PTRACE`, `DAC_OVERRIDE`, `NET_ADMIN` and `NET_RAW` capabilities. Enable it only on a dedicated lab host, and keep the agent version no newer than your Wazuh manager.

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
| ARM compatibility | `vulnerables/web-dvwa` is amd64-only and runs under emulation; enable QEMU binfmt on Linux hosts (Docker Desktop has it built in) |

## Stop

```bash
docker compose down
docker compose down -v  # also remove database volume
```

## Security

Please report vulnerabilities privately as described in [SECURITY.md](SECURITY.md), not in a public issue.

## License

This project is provided under the GPL-3.0-or-later license.
