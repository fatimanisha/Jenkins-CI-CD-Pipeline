pipeline {
    agent any
    stages {
        stage('Login to Azure') {
            steps {
                script {
                    // Log in to Azure using the managed identity assigned to the Jenkins VM
                    sh 'az login --identity --allow-no-subscriptions'
                }
            }
        }

        stage('Checkout Code') {
            steps {
                // Checkout code from version control
                git branch: 'main', url: 'https://github.com/fatimanisha/Jenkins-CI-CD-Pipeline.git', credentialsId: 'github-pat'
            }
        }

        stage('Initialize') {
            steps {
                script {
                    // Initialize Terraform or configure for ARM/CloudFormation
                    sh 'terraform init'  // Adjust this for ARM or CloudFormation setup if necessary
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    // Generate and review a deployment plan
                    sh 'terraform plan -out=tfplan'  // For Terraform
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    // Apply the changes to provision resources
                    sh 'terraform apply -auto-approve tfplan'  // Adjust for other providers
                }
            }
        }

        stage('Validation') {
            steps {
                script {
                    // Perform any necessary validation, e.g., checking resource status
                    sh 'terraform output'  // Outputs the result for inspection
                }
            }
        }

        stage('DSC Configuration') {
            steps {
                script {
                    // Use Azure PowerShell to deploy DSC configuration
                    sh 'pwsh -Command "Start-DscConfiguration -Path C:\\DSC -Wait -Verbose"'
                }
            }
        } // Close the 'DSC Configuration' stage
    } // Close the 'stages' block

    post {
        always {
            // Clean up after execution, e.g., removing generated files or temporary credentials
            cleanWs()
        }
        success {
            echo 'Infrastructure and Configuration deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
} // Close the 'pipeline' block
