# Use Node.js LTS version on Alpine Linux as the base image
FROM node:lts-alpine

# Install bash and git
RUN apk add --no-cache bash git jq

# Update npm to the latest version
RUN npm install -g npm@9.8.1

# Install replace-in-file globally
RUN npm install -g replace-in-file

# Copy the entrypoint script into the container and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Specify the entrypoint script as the main command to run when the container starts
ENTRYPOINT ["/entrypoint.sh"]
