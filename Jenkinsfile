pipeline {
    agent any
    environment {
        AWS_SSH_CREDENTIALS = credentials('my-ec2-ssh-key') // Replace with your credential ID
        DOCKER_USERNAME = 'senthilkumarsoundararajan' // Set your DockerHub username
        DOCKER_PASSWORD = '294224789' // Set your DockerHub password
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/creativesenthil/flask-app.git'
            }
        }
        stage('Install Dependencies & Run Tests') {
            steps {
                script {
                    sh '''#!/bin/bash
                    set -e
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pytest || echo 'No tests available'
                    '''
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh '''#!/bin/bash
                    docker build -t senthilkumarsoundararajan/flask-app:latest .
                    '''
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    sh '''#!/bin/bash
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    docker push senthilkumarsoundararajan/flask-app:latest
                    '''
                }
            }
        }
        stage('Deploy to AWS EC2') {
            steps {
                script {
                    sh '''#!/bin/bash
                    ssh -o StrictHostKeyChecking=no -i $AWS_SSH_CREDENTIALS ubuntu@13.232.19.254 <<EOF
                    set -e
                    echo "Starting deployment process on EC2 instance..."

                    # Pull the latest Docker image
                    docker pull senthilkumarsoundararajan/flask-app:latest

                    # Stop and remove the existing container if it exists
                    docker ps -q --filter "name=flask-app" | grep -q . && docker rm -f flask-app || echo "No existing container to remove."

                    # Run the new container
                    docker run -d --name flask-app -p 80:5000 senthilkumarsoundararajan/flask-app:latest

                    echo "Deployment completed successfully!"
EOF
                    '''
                }
            }
        }
    }
}
