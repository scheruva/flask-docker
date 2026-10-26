FROM amazonlinux:2023

# Install the Python runtime and utilities used by the application
RUN dnf -y install python3 python3-pip openssl && dnf clean all

WORKDIR /app

COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt

COPY . .

# Generate a self-signed SSL certificate for HTTPS inside the container
RUN openssl req -x509 -newkey rsa:4096 -nodes \
    -out cert.pem -keyout key.pem -days 365 \
    -subj "/C=US/ST=AL/L=Huntsville/O=WATT/CN=localhost"

EXPOSE 5000

CMD ["python3", "app.py"]