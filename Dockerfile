FROM node:22-slim AS build
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:22-slim
RUN apt-get update && apt-get install -y git jq curl python3 make g++ && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist
COPY --from=build /app/skills ./skills

ENV NODE_ENV=production
EXPOSE 8080
HEALTHCHECK NONE

CMD ["sh", "-c", "node generate-config.js && node dist/main.js"]
