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


    }
}
