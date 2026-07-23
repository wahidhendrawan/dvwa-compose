#!/bin/bash
# Set DVWA difficulty level based on environment variable
# Called by docker-entrypoint or manually after container starts

DVWA_URL="${DVWA_URL:-http://dvwa}"
SESSION_TOKEN=$(curl -s -c /tmp/dvwa_cookies "$DVWA_URL/login.php" | grep -oP 'user_token=\K[^"]+' | head -1)

if [ -z "$SESSION_TOKEN" ]; then
  echo "Cannot reach DVWA at $DVWA_URL — is it running?"
  exit 1
fi

# Login as admin
curl -s -b /tmp/dvwa_cookies -c /tmp/dvwa_cookies \
  -X POST "$DVWA_URL/login.php" \
  -d "username=admin&password=password&Login=Login&user_token=$SESSION_TOKEN" > /dev/null

# Set difficulty
DIFFICULTY="${DVWA_DIFFICULTY:-impossible}"
curl -s -b /tmp/dvwa_cookies \
  -X POST "$DVWA_URL/security.php" \
  -d "security=$DIFFICULTY&seclev_submit=Submit" > /dev/null

echo "DVWA difficulty set to: $DIFFICULTY"
rm -f /tmp/dvwa_cookies
