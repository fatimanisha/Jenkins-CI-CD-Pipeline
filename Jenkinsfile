pipeline {
    agent any

    stages {
        stage('Initialize Terraform') {
            steps {
                script {
                    // Initialize Terraform in the root directory
                    sh 'terraform init'
                }
            }
        }
        stage('Plan Terraform') {
            steps {
                script {
                        sh 'terraform plan'
                            }
                        }
                    }
        stage('Apply Terraform') {
            steps {
                script {
                        // Apply changes to create or update policies
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
            
        stage('Role Assignment') {
            steps {
                script {
                    // Apply RBAC roles and assignments
                    sh 'terraform apply -auto-approve -target=azurerm_role_assignment.role_assignment'
                }
            }
        }

        stage('Policy Enforcement') {
            steps {
                script {
                    // Apply Azure policies
                    sh 'terraform apply -auto-approve -target=azurerm_policy_assignment.policy_assignment'
                }
            }
        }

        stage('Compliance Validation') {
            steps {
                script {
                    sh 'terraform plan'
                
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
