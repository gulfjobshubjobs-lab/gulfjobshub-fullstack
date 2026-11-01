#!/bin/sh
set -eu

# Refresh signatures before the API starts. If update fails, the API may start,
# but REQUIRE_MALWARE_SCAN=true makes CV uploads fail closed unless clamscan
# can complete successfully with a usable database.
if command -v freshclam >/dev/null 2>&1; then
  freshclam --stdout --verbose || echo "WARNING: ClamAV signature update failed; CV uploads will remain blocked if scanning is unavailable." >&2
else
  echo "ERROR: freshclam is missing; refusing to start with malware scanning enabled." >&2
  exit 1
fi

exec gosu node node --disable-warning=ExperimentalWarning server/server.js
