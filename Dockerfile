FROM node:22-bookworm-slim

# ClamAV is installed in the runtime image, not merely documented.
RUN apt-get update \
 && apt-get install -y --no-install-recommends clamav clamav-freshclam gosu ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --chown=node:node . /app
COPY server/container-entrypoint.sh /usr/local/bin/gjh-entrypoint
RUN chmod 0755 /usr/local/bin/gjh-entrypoint \
 && mkdir -p /data /var/lib/clamav \
 && chown -R node:node /data

ENV NODE_ENV=production PORT=3000 DATA_DIR=/data REQUIRE_MALWARE_SCAN=true CLAMSCAN_PATH=/usr/bin/clamscan
VOLUME ["/data"]
EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/gjh-entrypoint"]
