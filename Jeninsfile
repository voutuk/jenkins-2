pipeline {
    agent any
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([usernamePassword(credentialsId: '2ee71291-a2e1-41b6-86db-ecde653e40b4', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        sh "terraform apply -var='aws_acces=$USERNAME' -var='aws_secret=$PASSWORD' -auto-approve"

                    }
                }
            }
        }
    }
}