# flask-nginx-docker
To bundle both the Flask application and the Nginx reverse proxy into a single, self-contained Docker image, we can use an entrypoint script that manages both processes inside the container. Terraform will build this combined image and push it to Artifactory via GitLab CI/CD.

# Setup
Ensure 443 is open in the security group being used
```
docker login <your-artifactory-url> -u <your-username> -p <your-api-key>
'

docker run -d \
  --name flask-nginx-app \
  -p 80:80 \
  -p 443:443 \
  --restart always \
  <your-artifactory-url>/flask-nginx-app:latest
```

Access your application in your browser at ⁠https://<your-ec2-public-ip>⁠.