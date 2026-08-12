FROM node:22-alpine

# Upgrade all OS packages to patch any recent, unfixed vulnerabilities that the base image ships with
RUN apk upgrade --no-cache

WORKDIR /app
COPY server.js .

# Ensure the container runs as a non-root user for security (Requirement 3.2.3)
USER node
EXPOSE 8080

CMD ["node", "server.js"]
