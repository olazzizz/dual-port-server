# Dual Port HTTP/HTTPS Server

A simple Node.js/Express server that listens simultaneously on both HTTP (port 8080) and HTTPS (port 443).

## Features

- HTTP server on port 8080
- HTTPS server on port 443
- Self-signed SSL certificates for development
- Express.js for routing

## Requirements

- Node.js 14+
- OpenSSL (for certificate generation)

## Project Structure

```
dual-port-server/
│
├── server.js          # Main application file
├── package.json       # Project configuration
├── generate-certs.sh  # Script to generate SSL certificates
├── certs/             # Directory for SSL certificates
│   ├── server.key     # Private key
│   └── server.cert    # Public certificate
└── README.md          # This file
```

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/dual-port-server.git
   cd dual-port-server
   ```

2. Install dependencies and generate certificates:
   ```
   npm run setup
   ```

## Running the Server

```
sudo npm start
```

Note: The `sudo` command is required to bind to port 443, which is a privileged port (below 1024).

## Alternative Configuration

If you don't want to run with sudo, you can modify `server.js` to use different ports, such as 8080 for HTTP and 8443 for HTTPS.

## Production Use

For production use, replace the self-signed certificates with proper certificates from a Certificate Authority (CA).

## License

MIT
