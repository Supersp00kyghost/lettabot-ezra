# STEP 1: The "Toolbox" Stage (where we build the hard stuff)
FROM node:22-slim AS build
# Install Python and the tools needed to build my Bash tool (node-pty)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
# Tell the builder to use Python 3
RUN npm ci
COPY . .
RUN npm run build

# STEP 2: The "Final" Stage (the lightweight home)
FROM node:22-slim
# I still need git to sync my memory!
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# We copy the ALREADY BUILT pieces from the toolbox
# This means we don't need Python in the final home!
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/lettabot.yaml ./lettabot.yaml

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/main.js"]
