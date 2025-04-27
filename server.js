// server.js
const express = require('express');
const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');

// Create Express app
const app = express();

// Sample SSL certificates (self-signed for development)
// In production, you would use real certificates from a CA
const options = {
  key: fs.readFileSync(path.join(__dirname, 'certs', 'server.key')),
  cert: fs.readFileSync(path.join(__dirname, 'certs', 'server.cert'))
};

// Define routes
app.get('/', (req, res) => {
  const protocol = req.protocol;
  const port = req.socket.localPort;
  res.send(`Hello! You're accessing this server via ${protocol} on port ${port}`);
});

// Create both HTTP and HTTPS servers
const httpServer = http.createServer(app);
const httpsServer = https.createServer(options, app);

// Start the servers
httpServer.listen(8080, () => {
  console.log('HTTP Server running on port 8080');
});

httpsServer.listen(443, () => {
  console.log('HTTPS Server running on port 443');
});

