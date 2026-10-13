#!/bin/sh
cd "$(dirname "$0")/web" || exit 1
port="${1:-43123}"
exec python3 -m http.server "$port" --bind 0.0.0.0
