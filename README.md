# DevPulse – Complete CI/CD Pipeline (Jenkins + Docker + AWS)

DevPulse is a production-style CI/CD implementation demonstrating a complete DevOps workflow using Jenkins, Docker, Ansible, Terraform, and AWS EC2.

The pipeline builds frontend and backend services independently, creates Docker images, pushes them to Docker Hub, and deploys them to a separate hosting EC2 instance via secure SSH.

---

## Architecture Overview

Developer Push  
↓  
GitHub Repositories  
↓  
Jenkins (CI EC2)  
↓  
Docker Build & Push  
↓  
Docker Hub  
↓  
Hosting EC2 (CD via SSH)  
↓  
Live Application  

---

## Repositories Used

| Purpose | Repository |
|------|-----------|
| CI/CD & Infrastructure | https://github.com/Shresth2725/DevPulse-CICD |
| Frontend | https://github.com/Shresth2725/devpulse-frontend |
| Backend | https://github.com/Shresth2725/DevPulse |

---

## Tech Stack

- AWS EC2 (CI and Hosting)
- Jenkins (WAR-based)
- Docker and Docker Compose
- Docker Hub
- Ansible
- Terraform
- Node.js
- Nginx
- SSH (Key-based authentication)

---

## Infrastructure Setup

### EC2 Instances

| Instance | Purpose |
|-------|--------|
| Jenkins EC2 | CI/CD server |
| Hosting EC2 | Runs application containers |

Both instances are provisioned using Terraform and configured using Ansible.

---

## CI/CD Flow

1. Jenkins pulls infrastructure repository  
   - Jenkinsfile  
   - Docker configurations  
   - Docker Compose files  

2. Jenkins pulls frontend repository  
   - Installs dependencies  
   - Builds production dist folder  

3. Frontend build injected into Docker context  
   - docker/nginx/dist/  

4. Jenkins pulls backend repository  
   - Copies backend source into Docker context  
   - docker/backend/DevPulse/  

5. Secure environment setup  
   - Secrets stored in Jenkins Credentials  
   - .env generated at runtime  
   - No secrets committed to GitHub  

6. Docker images built  
   - shresth2725/devpulse-backend:latest  
   - shresth2725/devpulse-frontend:latest  

7. Docker images pushed to Docker Hub  

8. Deployment to Hosting EC2  
   - SSH from Jenkins  
   - Pull latest images  
   - Run containers using docker-compose  

---

## Jenkins Credentials Used

| Credential ID | Type | Purpose |
|------------|------|--------|
| dockerhub-creds | Username + Token | Push images |
| jenkins-cd-key | SSH private key | Deploy to hosting |
| DB_CONNECTION_STRING | Secret text | Database |
| JWT_SECRET_KEY | Secret text | Authentication |
| API_KEY / API_SECRET | Secret text | Cloudinary |
| RAZORPAY_SECRET_KEY | Secret text | Payments |

---

## Security Practices

- No secrets stored in GitHub
- Environment variables generated dynamically
- SSH key-based authentication
- Separate CI and Hosting EC2 instances
- Immutable Docker images

---

## Docker Compose (Hosting EC2)

- Backend runs on port 7777
- Frontend runs on port 80
- Auto-restart enabled
- Environment loaded from .env

---

## Run Locally

docker compose up -d


---

## Current Status

- CI pipeline operational
- Docker images building successfully
- Images pushed to Docker Hub
- SSH deployment working
- Ready for full CD automation

---

## Future Improvements

- Blue/Green deployments
- Image tagging with Git commit SHA
- Health checks
- HTTPS with Nginx SSL
- Automated rollback

---

## Author

Shresth  
DevOps | Cloud | CI/CD

