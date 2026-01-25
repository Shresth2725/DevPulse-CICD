pipeline {
    agent any

    environment {
        HOST_IP = "98.92.171.29"
        FRONTEND_IMAGE = "shresth2725/devpulse-frontend:latest"
        BACKEND_IMAGE  = "shresth2725/devpulse-backend:latest"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Infra Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Shresth2725/DevPulse-CICD.git'
            }
        }

        stage('Clone Frontend Repo') {
            steps {
                dir('frontend') {
                    git branch: 'main',
                        url: 'https://github.com/Shresth2725/devpulse-frontend.git'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh '''
                    npm install
                    npm run build
                    '''
                }
            }
        }

        stage('Copy Frontend Dist to Docker Context') {
            steps {
                sh '''
                rm -rf docker/nginx/dist
                mkdir -p docker/nginx/dist
                cp -r frontend/dist/* docker/nginx/dist/
                '''
            }
        }

        stage('Clone Backend Repo') {
            steps {
                dir('backend_src') {
                    git branch: 'main',
                        url: 'https://github.com/Shresth2725/DevPulse.git'
                }
            }
        }

        stage('Copy Backend Code to Docker Context') {
            steps {
                sh '''
                rm -rf docker/backend/DevPulse
                mkdir -p docker/backend/DevPulse
                cp -r backend_src/* docker/backend/DevPulse/
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )]) {
                    sh '''
                    echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                docker build -t $BACKEND_IMAGE docker/backend
                docker build -t $FRONTEND_IMAGE docker/nginx
                '''
            }
        }

        stage('Push Docker Images') {
            steps {
                sh '''
                docker push $BACKEND_IMAGE
                docker push $FRONTEND_IMAGE
                '''
            }
        }

        stage('Deploy to Hosting EC2') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'jenkins-cd-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    ),
                    string(credentialsId: 'DB_CONNECTION_STRING', variable: 'DB_CONNECTION_STRING'),
                    string(credentialsId: 'JWT_SECRET_KEY', variable: 'JWT_SECRET_KEY'),
                    string(credentialsId: 'RAZORPAY_SECRET_KEY', variable: 'RAZORPAY_SECRET_KEY'),
                    string(credentialsId: 'RAZORPAY_WEBHOOK_SECRET', variable: 'RAZORPAY_WEBHOOK_SECRET'),
                    string(credentialsId: 'CLOUD_NAME', variable: 'CLOUD_NAME'),
                    string(credentialsId: 'API_KEY', variable: 'API_KEY'),
                    string(credentialsId: 'API_SECRET', variable: 'API_SECRET')
                ]) {
                    sh """
                    ssh -i \$SSH_KEY -o StrictHostKeyChecking=no \$SSH_USER@${HOST_IP} << EOF
                    set -e

                    mkdir -p ~/devpulse
                    cd ~/devpulse

                    cat > docker-compose.yml << EOC
services:
  backend:
    image: ${BACKEND_IMAGE}
    container_name: devpulse-backend
    env_file:
      - .env
    ports:
      - "7777:7777"
    restart: always

  frontend:
    image: ${FRONTEND_IMAGE}
    container_name: devpulse-frontend
    ports:
      - "80:80"
    restart: always
EOC

                    cat > .env << ENV
DB_CONNECTION_STRING=${DB_CONNECTION_STRING}
JWT_SECRET_KEY=${JWT_SECRET_KEY}
PORT=7777
RAZORPAY_SECRET_KEY=${RAZORPAY_SECRET_KEY}
RAZORPAY_WEBHOOK_SECRET=${RAZORPAY_WEBHOOK_SECRET}
CLOUD_NAME=${CLOUD_NAME}
API_KEY=${API_KEY}
API_SECRET=${API_SECRET}
ENV

                    docker compose pull
                    docker compose up -d --remove-orphans
                    EOF
                    """
                }
            }
        }
    }
}
