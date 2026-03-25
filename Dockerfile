# Step 1: Build
FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Step 2: Run
FROM node:22-slim
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# Copy the built code
COPY --from=build /app/dist ./dist
# Grab the config file specifically from the build stage
COPY --from=build /app/lettabot.yaml ./lettabot.yaml

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/main.js"]
