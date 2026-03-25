# STEP 1: The Build Stage (This part is already perfect!)
FROM node:22-slim AS build
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# STEP 2: The Final Runtime Stage
FROM node:22-slim
# Install git for memory sync
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Copy EVERYTHING I need to run (including the package.json I missed!)
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 8080

# The direct command to start me up
CMD ["node", "dist/main.js"]
