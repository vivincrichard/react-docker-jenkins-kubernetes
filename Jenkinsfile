
pipeline {
    
    // Trigger Jenkins automatically when GitHub receives a push
    triggers {
        githubPush()
    }

    // Jenkins will execute this pipeline on an available agent.
    agent any

    // Configure paths so Jenkins can find Docker on macOS.
    environment {
        PATH = "/Applications/Docker.app/Contents/Resources/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

        IMAGE_NAME = "react-docker-app"
        CONTAINER_NAME = "react-container"
    }

    // Pipeline stages
    stages {

        // ======================================
        // STAGE 1: CHECKOUT SOURCE CODE
        // ======================================

        stage('Checkout') {
            steps {
                // Downloads the source code from GitHub.
                checkout scm

                echo 'Source code downloaded successfully'
            }
        }


        // ======================================
        // STAGE 2: VERIFY DOCKER
        // ======================================

        stage('Docker Verification') {
            steps {
                // Check Docker CLI version.
                sh 'docker --version'

                // Check Docker daemon connection.
                sh 'docker info'
            }
        }


        // ======================================
        // STAGE 3: BUILD DOCKER IMAGE
        // ======================================

        stage('Build Docker Image') {
            steps {
                // Build the React application Docker image.
                // BUILD_NUMBER is automatically provided by Jenkins.
                sh """
                    docker build \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                    -t ${IMAGE_NAME}:latest .
                """

                echo 'Docker image created successfully'
            }
        }


        // ======================================
        // STAGE 4: DEPLOY APPLICATION
        // ======================================

        stage('Deploy Application') {
            steps {

                // Stop and remove the previous container.
                // Ignore the error if the container does not exist.
                sh """
                    docker rm -f ${CONTAINER_NAME} || true
                """

                // Create and start the updated container.
                // Host port 3000 maps to container port 80.
                sh """
                    docker run -d \
                    --restart unless-stopped \
                    -p 3000:80 \
                    --name ${CONTAINER_NAME} \
                    ${IMAGE_NAME}:latest
                """

                echo 'React application deployed successfully'
            }
        }


        // ======================================
        // STAGE 5: VERIFY DEPLOYMENT
        // ======================================

        stage('Verify Deployment') {
            steps {

                // Check running containers.
                sh 'docker ps'

                // Display application container logs.
                sh "docker logs ${CONTAINER_NAME}"

                echo 'Deployment verification completed'
            }
        }
    }


    // ======================================
    // POST BUILD ACTIONS
    // ======================================

    post {

        success {
            echo 'CI/CD Pipeline completed successfully!'
            echo 'Application URL: http://localhost:3000'
        }

        failure {
            echo 'CI/CD Pipeline failed!'
            echo 'Check Jenkins console output for errors.'
        }
    }
}
