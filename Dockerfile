FROM python:3.11-slim

# Install Nginx, curl, and openssl
RUN apt-get update && apt-get install -y nginx curl openssl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Set executable permission for entrypoint script
RUN chmod +x entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["./entrypoint.sh"]
