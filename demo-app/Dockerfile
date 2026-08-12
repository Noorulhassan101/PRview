# Use Chainguard's minimal, zero-CVE Node.js image to guarantee a clean Trivy scan
FROM cgr.dev/chainguard/node:latest

# Copy our server payload
COPY server.js /app/server.js

# Note: Chainguard images run as the non-root `node` user by default (Requirement 3.2.3)
EXPOSE 8080

# Chainguard's default entrypoint is `/usr/bin/node`
CMD ["/app/server.js"]
