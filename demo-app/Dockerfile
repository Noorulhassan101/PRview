FROM node:22-alpine

WORKDIR /app
COPY server.js .

# Ensure the container runs as a non-root user for security (Requirement 3.2.3)
USER node
EXPOSE 8080

CMD ["node", "server.js"]
