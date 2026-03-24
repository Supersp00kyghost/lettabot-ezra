const fs = require('fs');
const http = require('http');

const config = `server:
  mode: api
  apiKey: ${process.env.LETTA_API_KEY}

agents:
  - name: Ezra
    id: ${process.env.EZRA_AGENT_ID}

    features:
      allowedTools: [web_search, conversation_search, fetch_webpage]

    conversations:
      mode: shared
      heartbeat: last-active

    channels:
      discord:
        enabled: true
        token: ${process.env.DISCORD_TOKEN}
        groups:
          "${process.env.DISCORD_CHANNEL_1}": { mode: mention-only }
          "${process.env.DISCORD_CHANNEL_2}": { mode: mention-only }

providers:
  - id: google
    name: lc-google
    type: google_ai_studio
    apiKey: ${process.env.GOOGLE_API_KEY}
`;

fs.writeFileSync('lettabot.yaml', config);
console.log('Generated lettabot.yaml from environment variables');

// Health check server
http.createServer((req, res) => {
  res.writeHead(200);
  res.end('ok');
}).listen(8080);
console.log('Health check server running on port 8080');