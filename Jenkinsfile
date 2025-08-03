
pipeline {
    agent any
    tools {
            maven 'Maven 3.9.11'   // Use the name configured in Global Tool Config
    }
    environment {
        IMAGE_NAME = "savipavan/myapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stages {

        stage('Checkout Source') {
            steps {
                git url: 'https://github.com/savipavan/blue-green-jenkins-java-app.git'
            }
        }

        stage('Deploy to Deployment1 (Blue)') {
            steps {
                sh """
                    sed 's|__IMAGE__|${IMAGE_NAME}:${IMAGE_TAG}|' k8s/deployment-blue.yaml | kubectl apply -f -
                """
            }
        }

        stage('Manual Approval to Trigger Green') {
            steps {
                input message: "Deploy to Green and shift traffic?"
            }
        }

        stage('Deploy to Deployment-Green') {
            steps {
                sh """
                    sed 's|__IMAGE__|${IMAGE_NAME}:${IMAGE_TAG}|' k8s/deployment-green.yaml | kubectl apply -f -
                """
            }
        }

        stage('Switch Traffic to Green') {
            steps {
                sh 'kubectl patch svc myapp-service -p '{"spec": {"selector": {"version": "green"}}}''
            }
        }

        stage('Cleanup Blue (Optional)') {
            steps {
                sh 'kubectl delete deployment myapp-blue || true'
            }
        }
    }
}
