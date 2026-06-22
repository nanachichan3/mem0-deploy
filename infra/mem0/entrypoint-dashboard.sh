#!/bin/sh
set -e
API="${NEXT_PUBLIC_API_URL:-http://localhost:8888}"
NAME="${NEXT_PUBLIC_INSTANCE_NAME:-Mem0}"

# Build-time NEXT_PUBLIC_* values were placeholders; Next.js inlines them into both
# server bundles and .next/static/chunks (browser). Replace everywhere before boot.
replace_if_present() {
  _f="$1"
  [ -f "$_f" ] || return 0
  grep -q 'NEXT_PUBLIC_API_URL\|NEXT_PUBLIC_INSTANCE_NAME' "$_f" 2>/dev/null || return 0
  sed -i "s|NEXT_PUBLIC_API_URL|${API}|g; s|NEXT_PUBLIC_INSTANCE_NAME|${NAME}|g" "$_f"
}

replace_if_present /app/server.js

# Static client chunks + RSC/server chunks (BusyBox sh does not expand ** reliably).
find /app/.next/static /app/.next/server -type f \( -name '*.js' -o -name '*.json' \) \
  2>/dev/null | while IFS= read -r f; do
  replace_if_present "$f"
done

exec node server.js
