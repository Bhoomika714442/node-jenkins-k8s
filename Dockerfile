# Use official Node image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm ci --only=production

# Bundle app source
COPY . .

# Production port
ENV PORT=3000
EXPOSE 3000

CMD ["node", "index.js"]
