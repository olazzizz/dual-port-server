#!/bin/bash

# Create directory for certificates
mkdir -p certs
cd certs

# Create self-signed certificate valid for 365 days
openssl req -nodes -new -x509 -keyout server.key -out server.cert -days 365 -subj "/CN=localhost"

echo "Self-signed certificates generated in the certs directory"
