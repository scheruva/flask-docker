#!/bin/bash

# Generate SSL certificates if they don't exist
if [ ! -f /etc/nginx/certs/cert.pem ]; then
    mkdir -p /etc/nginx/certs
    openssl req -x509 -newkey rsa:4096 -nodes \
        -out /etc/nginx/certs/cert.pem -keyout /etc/nginx/certs/key.pem \
        -days 365 -subj "/C=US/ST=State/L=City/O=Development/CN=localhost"
fi

# Start Flask application in the background
python /app/app.py &

# Start Nginx in the foreground (keeps container alive)
nginx -g 'daemon off;'
