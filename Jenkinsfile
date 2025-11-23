pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
    DOCKER_IMAGE = "bhoomika714442/cloud-native-node-api"
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    KUBE_DEPLOY_FILE = "deployment.yaml"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Image') {
      steps {
        script {
          sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
            docker push ${DOCKER_IMAGE}:latest
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh """
          sed "s#bhoomika714442/cloud-native-node-api:latest#${DOCKER_IMAGE}:${IMAGE_TAG}#g" deployment.yaml > k8s-deploy-${IMAGE_TAG}.yaml
          kubectl apply -f k8s-deploy-${IMAGE_TAG}.yaml
          kubectl rollout status deployment/cloud-node-api --timeout=120s
        """
      }
    }
  }

  post {
    success { echo "Pipeline completed successfully." }
    failure { echo "Pipeline failed." }
  }
}
