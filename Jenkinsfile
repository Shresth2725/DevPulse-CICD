pipeline {
    agent any

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
                    docker run --rm \
                        node -v || true
                        npm -v || true
                        npm install
                        npm run build
                    '''
                }
            }
        }


        stage('Verify Frontend Build') {
            steps {
                sh '''
                  echo "==== dist contents ===="
                  ls -la frontend/dist
                '''
            }
        }

        stage('Copy Frontend Dist to Docker Context') {
            steps {
                sh '''
                echo "Injecting frontend dist into docker/nginx..."
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
                echo "Injecting backend code into docker/backend/DevPulse..."
                rm -rf docker/backend/DevPulse
                mkdir -p docker/backend/DevPulse
                cp -r backend_src/* docker/backend/DevPulse/
                '''
            }
        }

        stage('Create .env file') {
            steps {
                withCredentials([
                    string(credentialsId: 'DB_CONNECTION_STRING', variable: 'DB_CONNECTION_STRING'),
                    string(credentialsId: 'JWT_SECRET_KEY', variable: 'JWT_SECRET_KEY'),
                    string(credentialsId: 'PORT', variable: 'PORT'),
                    string(credentialsId: 'RAZORPAY_SECRET_KEY', variable: 'RAZORPAY_SECRET_KEY'),
                    string(credentialsId: 'RAZORPAY_WEBHOOK_SECRET', variable: 'RAZORPAY_WEBHOOK_SECRET'),
                    string(credentialsId: 'CLOUD_NAME', variable: 'CLOUD_NAME'),
                    string(credentialsId: 'API_KEY', variable: 'API_KEY'),
                    string(credentialsId: 'API_SECRET', variable: 'API_SECRET')
                ]) {
                    sh '''
                    echo "Creating .env file"
                    rm -f .env

                    echo "DB_CONNECTION_STRING=$DB_CONNECTION_STRING" >> .env
                    echo "JWT_SECRET_KEY=$JWT_SECRET_KEY" >> .env
                    echo "PORT=$PORT" >> .env
                    echo "RAZORPAY_SECRET_KEY=$RAZORPAY_SECRET_KEY" >> .env
                    echo "RAZORPAY_WEBHOOK_SECRET=$RAZORPAY_WEBHOOK_SECRET" >> .env
                    echo "CLOUD_NAME=$CLOUD_NAME" >> .env
                    echo "API_KEY=$API_KEY" >> .env
                    echo "API_SECRET=$API_SECRET" >> .env

                    echo ".env file created"
                    '''
                }
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
                docker build -t shresth2725/devpulse-backend:latest docker/backend
                docker build -t shresth2725/devpulse-frontend:latest docker/nginx
                '''
            }
        }

        stage('Push Docker Images') {
            steps {
                sh '''
                docker push shresth2725/devpulse-backend:latest
                docker push shresth2725/devpulse-frontend:latest
                '''
            }
        }


    }
}
