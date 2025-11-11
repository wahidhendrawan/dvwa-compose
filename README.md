# DVWA Compose

DVWA (Damn Vulnerable Web Application) stack with HTTPS and MySQL, packaged for Docker Compose.

## 🧱 Services
- **MySQL 5.7** – Database backend
- **DVWA** – Web application (vulnerables/web-dvwa)
- **Nginx** – HTTPS reverse proxy (port 443)

## ⚙️ Setup Instructions

### 1. Generate SSL Certificates
```bash
mkdir -p nginx/ssl nginx/conf.d
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/dvwa.key -out nginx/ssl/dvwa.crt \
  -subj "/CN=localhost"
```

### 2. Start the stack
```bash
docker compose up -d
```

### 3. Access
- URL: https://localhost  
- Login: `admin` / `password`
- Setup page: https://localhost/setup.php

### 4. Stop and remove
```bash
docker compose down
```

## 🧰 Directory Structure
```
dvwa-compose/
│
├── docker-compose.yml
├── nginx/
│   ├── conf.d/
│   │   └── default.conf
│   └── ssl/
│       ├── dvwa.crt
│       └── dvwa.key
└── README.md
```

## 🧩 Notes
- Self-signed certificate is used (browser may warn about it).
- To use a real domain, replace SSL files with Let's Encrypt or other valid certs.
