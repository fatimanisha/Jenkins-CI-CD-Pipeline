pipeline {
    agent any

    stages {
        stage('Initialize Terraform') {
            steps {
                script {
                    dir('terraform/rbac-policies') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Role Assignment') {
            steps {
                script {
                    dir('terraform/rbac-policies') {
                        // Apply RBAC roles and assignments
                        sh 'terraform apply -auto-approve -target=azurerm_role_assignment.role_assignment'
                    }
                }
            }
        }

        stage('Policy Enforcement') {
            steps {
                script {
                    dir('terraform/rbac-policies') {
                        // Apply Azure policies
                        sh 'terraform apply -auto-approve -target=azurerm_policy_assignment.policy_assignment'
                    }
                }
            }
        }

        stage('Compliance Validation') {
            steps {
                script {
                    // Run compliance checks
                    dir('terraform/rbac-policies') {
                        sh 'terraform plan'
                    }

                    // Optional: Retrieve compliance summary using Azure CLI
                    sh '''
                    az policy state summarize --management-group <your-management-group> --output table
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'RBAC and Policies Deployment Successful!'
        }
        failure {
            echo 'RBAC and Policies Deployment Failed!'
        }
    }
}
