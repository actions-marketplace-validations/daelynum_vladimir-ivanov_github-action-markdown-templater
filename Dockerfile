# Use the official node.js image
FROM node:16-alpine

# Install bash and jq (for JSON processing)
RUN apk add --no-cache bash jq

# Create an app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install

# Bundle your app
COPY docker .

# Install replace-in-file globally
RUN npm install -g replace-in-file

# Set permissions for entrypoint.sh
RUN chmod +x entrypoint.sh

# Execute the script
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
