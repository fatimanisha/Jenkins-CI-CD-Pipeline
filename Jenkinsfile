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
        stage('Check Azure CLI Version') {
            steps {
                script {
                    sh 'az --version'
                }
            }
        }

        stage('Install Azure CLI Automation Extension') {
            steps {
                script {
                    sh 'az extension add --name automation'
                    az extension list --query "[?name=='automation']" -o table

                }
            }
        }

        stage('Register DSC Node') {
            steps {
                script {
                    sh '''
                    az automation dsc node register \
                        --automation-account-name automation-demo \
                        --resource-group demo-group \
                        --vm-id "/subscriptions/b330d894-4acd-4a5f-8b65-fc039e25fb53/resourceGroups/demo-group/providers/Microsoft.Compute/virtualMachines/VM2" \
                        --node-configuration-name ConfigureVM.localhost
                    '''
                }
            }
        }
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
