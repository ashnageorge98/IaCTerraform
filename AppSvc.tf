pipeline {
    agent any

    environment {
        AZURE_CLIENT_ID = credentials('5e5d108d-60b0-4a24-83a3-0d4a98a5605d')
        AZURE_CLIENT_SECRET = credentials('b6577361-8d74-4eed-b3cd-03d583f8a006')
        AZURE_TENANT_ID = credentials('2db475df-db59-4f26-a4a5-b4829d6f7d86')
        AZURE_SUBSCRIPTION_ID = credentials('81b0b41e-5edd-4af2-86ea-1b1457a4374c')
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub
                git branch: 'main', url: 'https://github.com/ashnageorge98/IaCTerraform.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                withCredentials([
                    string(credentialsId: '5e5d108d-60b0-4a24-83a3-0d4a98a5605d', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'b6577361-8d74-4eed-b3cd-03d583f8a006', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: '2db475df-db59-4f26-a4a5-b4829d6f7d86', variable: 'ARM_TENANT_ID'),
                    string(credentialsId: '81b0b41e-5edd-4af2-86ea-1b1457a4374c', variable: 'ARM_SUBSCRIPTION_ID')
                ]) {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                withCredentials([
                    string(credentialsId: '5e5d108d-60b0-4a24-83a3-0d4a98a5605d', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'b6577361-8d74-4eed-b3cd-03d583f8a006', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: '2db475df-db59-4f26-a4a5-b4829d6f7d86', variable: 'ARM_TENANT_ID'),
                    string(credentialsId: '81b0b41e-5edd-4af2-86ea-1b1457a4374c', variable: 'ARM_SUBSCRIPTION_ID')
                ]) {
                    // Run terraform plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                withCredentials([
                    string(credentialsId: '5e5d108d-60b0-4a24-83a3-0d4a98a5605d', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'b6577361-8d74-4eed-b3cd-03d583f8a006', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: '2db475df-db59-4f26-a4a5-b4829d6f7d86', variable: 'ARM_TENANT_ID'),
                    string(credentialsId: '81b0b41e-5edd-4af2-86ea-1b1457a4374c', variable: 'ARM_SUBSCRIPTION_ID')
                ]) {
                    // Apply the terraform plan
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            node {
                // Clean up after the build
                cleanWs()
            }
        }
    }
}
