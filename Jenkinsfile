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
                        -v "$PWD":/app \
                        -w /app \
                        node:20-alpine \
                        sh -c "npm install && npm run build"
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
    }
}
