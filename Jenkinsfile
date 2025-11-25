pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
        DOCKER_IMAGE = "bhoomika714442/node-jenkins-k8s"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/bhoomika714442/node-jenkins-k8s.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                    docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                    docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                bat """
                    docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                    docker push ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Deploy to Kubernetes') {
    steps {
        bat """
        powershell -Command "(Get-Content k8s/deployment.yaml) -replace 'IMAGE_PLACEHOLDER', 'bhoomika714442/node-jenkins-k8s:9' | Set-Content k8s/k8s-deploy-9.yaml"
        kubectl apply -f k8s/k8s-deploy-9.yaml
        kubectl rollout status deployment/cloud-node-api --timeout=120s
        """
    }
}

    }

    post {
        success { echo "Pipeline completed successfully." }
        failure { echo "Pipeline failed!" }
    }
}
