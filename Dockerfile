# Step 1: Build the bot
FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Step 2: Create the final running container
FROM node:22-slim
# Install git for memory sync
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# Copy the built bot and the config file
COPY --from=build /app/dist ./dist
COPY lettabot.yaml ./lettabot.yaml

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/main.js"]
