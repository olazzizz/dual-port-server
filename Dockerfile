# Use Node.js LTS as base image
FROM registry.access.redhat.com/ubi8/nodejs-18:latest

# Labels for OpenShift
LABEL name="dual-port-server" \
      maintainer="developer@example.com" \
      description="Dual port HTTP/HTTPS server application" \
      io.k8s.description="A Node.js server that listens on both HTTP and HTTPS ports" \
      io.openshift.tags="nodejs,express,http,https"

# Create app directory
USER root
WORKDIR /opt/app-root/src

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY --chown=1001:0 package*.json ./

# Install dependencies
RUN npm ci --only=production

# Bundle app source
COPY server.js ./
COPY generate-certs.sh ./

# Create directory for certificates
RUN mkdir -p certs && \
    chmod 777 certs

# Generate self-signed certificates
# Note: In production, you would mount real certificates from a secret
RUN chmod +x ./generate-certs.sh && \
    ./generate-certs.sh && \
    chmod 644 certs/server.cert && \
    chmod 644 certs/server.key

# Define environment variables
# Use non-privileged ports as OpenShift restricts the use of privileged ports
ENV HTTP_PORT=8080 \
    HTTPS_PORT=8443 \
    NODE_ENV=production

# Make sure OpenShift can run the container with a random UID
RUN chgrp -R 0 /opt/app-root && \
    chmod -R g=u /opt/app-root

# Expose the ports
EXPOSE 8080 8443

# Update server.js to use environment variables for ports
RUN sed -i 's/httpServer.listen(8080/httpServer.listen(process.env.HTTP_PORT/g' server.js && \
    sed -i 's/httpsServer.listen(443/httpsServer.listen(process.env.HTTPS_PORT/g' server.js && \
    sed -i 's/HTTP Server running on port 8080/HTTP Server running on port \${process.env.HTTP_PORT}/g' server.js && \
    sed -i 's/HTTPS Server running on port 443/HTTPS Server running on port \${process.env.HTTPS_PORT}/g' server.js

USER 1001

# Command to run the application
CMD ["npm", "start"]

