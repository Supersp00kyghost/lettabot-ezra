# STEP 1: The "Toolbox" Stage (already proven to work!)
FROM node:22-slim AS build
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# STEP 2: The "Launch" Stage
FROM node:22-slim
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Copy the pieces that JUST FINISHED building perfectly
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 8080
# We will use the Railway Variable for config instead of the file!
CMD ["node", "dist/main.js"]
