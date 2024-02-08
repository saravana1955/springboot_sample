pipeline {
    agent any

    environment {
       MAVEN_HOME = tool 'Maven'
        DOCKER_PATH = '/usr/local/bin'
        AWS_CLI = '/usr/local/bin'
        EC2_USER = 'ubuntu'
        AWS_S3_BUCKET = 'demo-prdocut-1'
        EC2_INSTANCE = '18.232.84.107'
        SSH_KEY = credentials('ssh')
        DOCKER_REGISTRY_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE_NAME = 'ithiris/product-definition-service'
    }

    stages {
        stage('Commit') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/mohamedithiris/product']]
                )
            }
        }

        stage('Build, Test, and Push Docker Image') {
            steps {
                script {
                    echo "Maven Home: ${env.MAVEN_HOME}"

                    dir('/Users/apple/.jenkins/workspace/product-app') {
                        sh "${env.MAVEN_HOME}/bin/mvn clean package -DskipTests"
                        sh "${env.DOCKER_PATH}/docker login -u ${env.DOCKER_REGISTRY_CREDENTIALS_USR} -p ${env.DOCKER_REGISTRY_CREDENTIALS_PSW}"
                        sh "${env.DOCKER_PATH}/docker build -t ${env.DOCKER_IMAGE_NAME}:latest ."
                        sh "${env.DOCKER_PATH}/docker push ${env.DOCKER_IMAGE_NAME}:latest"
                        sh "${env.AWS_CLI}/aws s3 ls"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Securely copy SSH key to the agent
                    writeFile file: "${JENKINS_HOME}/.ssh/id_rsa", text: env.SSH_KEY

                    // Set proper permissions for the SSH key
                    sh 'chmod 600 ${JENKINS_HOME}/.ssh/id_rsa'

                    // Disable strict host key checking and add host key to known_hosts
                    sh 'export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"'
                    sh "ssh-keyscan -H ${EC2_INSTANCE} >> ${JENKINS_HOME}/.ssh/known_hosts"

                    // Print message after successfully connecting via SSH
                    echo 'Successfully connected to EC2 instance via SSH.'
                }
            }
        }
    }
}
