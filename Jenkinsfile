pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '145023120684'
        ECR_REPO = 'my-web-app'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/soniya-natarajan/flask-webapp.git'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 145023120684.dkr.ecr.ap-south-1.amazonaws.com
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $ECR_REPO ."
            }
        }

        stage('Tag & Push Docker Image to ECR') {
            steps {
                sh """
                docker tag $ECR_REPO:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                """
            }
        }
    }
}
