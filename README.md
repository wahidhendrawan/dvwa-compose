[![CI](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml/badge.svg)](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml)

# DVWA Docker Compose

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL-3.0-blue.svg)](https://github.com/wahidhendrawan/dvwa-compose/blob/main/LICENSE)
[![Release](https://img.shields.io/badge/release-v1.0.0-green.svg)](https://github.com/wahidhendrawan/dvwa-compose/releases)
[![CI](https://github.com/wahidhendrawan/dvwa-compose/actions/workflows/ci.yml/badge.svg)](https://github.com/wahidhendrawan/dvwa-compose/actions)
[![Pages](https://img.shields.io/badge/docs-🌐-orange.svg)]({"message":"Not Found","documentation_url":"https://docs.github.com/rest/pages/pages#get-a-apiname-pages-site","status":"404"})

Docker Compose setup for [Damn Vulnerable Web Application (DVWA)](https://github.com/digininja/DVWA) with Nginx reverse proxy and TLS.

Works on **x86_64** and **ARM** (Apple Silicon, Raspberry Pi) — uses MariaDB which supports both architectures natively.

## Quick Start

```bash
git clone https://github.com/wahidhendrawan/dvwa-compose.git
cd dvwa-compose
docker compose up -d
```

Access DVWA at `https://localhost` (default credentials: `admin` / `password`).

## Architecture

```
Client → Nginx (TLS :443) → DVWA (PHP) → MariaDB
```

## Configuration

- **Nginx config**: `nginx/conf.d/default.conf`
- **TLS certificates**: `nginx/ssl/` (generate or place your own)
- **Database credentials**: edit `docker-compose.yml` environment variables

## Generate Self-Signed TLS Certificate

```bash
mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/dvwa.key -out nginx/ssl/dvwa.crt \
  -subj "/CN=localhost"
```

## Stop

```bash
docker compose down
docker compose down -v  # also remove database volume
```

## License

This project is provided under the GPL-3.0-or-later license.
