pipeline {
    agent any

    triggers {
        pollSCM('H/2 * * * *')
    }

    parameters {
        string(name: 'EC2_HOST', defaultValue: '', description: 'Public IP of the EC2 server (from terraform output public_ip)')
    }

    environment {
        // Jenkins credential of type "SSH Username with private key" or "Secret file" holding the .pem key
        SSH_KEY_ID = 'ec2-ssh-key'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Source code fetched from GitHub'
            }
        }

        stage('Build / Validation') {
            steps {
                sh 'bash scripts/validate.sh'
            }
        }

        stage('Test') {
            steps {
                sh 'bash scripts/test.sh'
            }
        }

        stage('Deploy to EC2') {
            when { expression { return params.EC2_HOST?.trim() } }
            steps {
                withCredentials([file(credentialsId: env.SSH_KEY_ID, variable: 'KEY_FILE')]) {
                    sh '''
                        chmod 400 "$KEY_FILE"
                        bash scripts/deploy.sh "$EC2_HOST" "$KEY_FILE"
                    '''
                }
            }
        }
    }

    post {
        success { echo "Pipeline succeeded. Website live at http://${params.EC2_HOST}" }
        failure { echo 'Pipeline failed. Check the stage logs above.' }
    }
}
