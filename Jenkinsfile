pipeline {
    agent any

    environment {
        // Docker Hub credentials
        DOCKER_USERNAME = credentials('docker-hub-username')
        DOCKER_PASSWORD = credentials('docker-hub-password')

        // AWS EC2 credentials
        SERVER_USER = 'ec2-user'           // EC2 instance username
        SERVER_IP = 'your-ec2-public-ip'  // EC2 instance public IP
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/flask-app.git'
            }
        }

        stage('Install Dependencies & Run Tests') {
            steps {
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                pip install -r requirements.txt
                pytest
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                docker build -t $DOCKER_USERNAME/flask-app:latest .
                docker tag $DOCKER_USERNAME/flask-app:latest $DOCKER_USERNAME/flask-app:latest
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                sh '''
                docker push $DOCKER_USERNAME/flask-app:latest
                '''
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $SERVER_USER@$SERVER_IP << EOF
                    sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                    sudo docker pull $DOCKER_USERNAME/flask-app:latest
                    sudo docker stop flask-app || true
                    sudo docker rm flask-app || true
                    sudo docker run -d --name flask-app -p 5000:5000 $DOCKER_USERNAME/flask-app:latest
                    EOF
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Application successfully deployed!'
        }
        failure {
            echo 'Pipeline execution failed.'
        }
    }
}

