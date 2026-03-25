# Step 1: Build the bot
FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Step 2: Create the final running container
FROM node:22-slim
# This is the "Magic Line" that installs git!
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# Copy the built bot and the config files
COPY --from=build /app/dist ./dist
COPY lettabot.yaml ./lettabot.yaml
COPY lettabot-agent.json ./lettabot-agent.json

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/main.js"]
