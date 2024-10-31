pipeline {
    agent any
    stages {
        stage('Login to Azure') {
            steps {
                script {
                    // Log in to Azure using the managed identity assigned to the Jenkins VM
                    sh 'az login --identity'
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
                    // Uncomment the next line for ARM templates
                    // sh 'az deployment group create --resource-group MyResourceGroup --template-file azuredeploy.json --parameters azuredeploy.parameters.json'
                    // Uncomment the next line for CloudFormation
                    // sh 'aws cloudformation validate-template --template-body file://template.yaml'
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
    }

    post {
        always {
            // Clean up after execution, e.g., removing generated files or temporary credentials
            cleanWs()
        }
        success {
            echo 'Infrastructure deployment successful!'
        }
        failure {
            echo 'Infrastructure deployment failed.'
        }
    }
}

