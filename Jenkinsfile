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

        stage('Clone Backend Repo') {
            steps {
                dir('backend_src') {
                    git branch: 'main',
                        url: 'https://github.com/Shresth2725/DevPulse.git'
                }
            }
        }

        stage('Verify Structure') {
            steps {
                sh '''
                  echo "==== Workspace Structure ===="
                  ls -la
                  echo "==== Frontend ===="
                  ls -la frontend
                  echo "==== Backend ===="
                  ls -la backend_src
                '''
            }
        }
    }
}
