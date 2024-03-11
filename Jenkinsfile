pipeline {
    agent any 
    stages {
        stage('Clean Workspace') {
            steps {
                CleanWs()
            }
        }
        stage("Terraform version"){
            steps {
                sh "terraform --version"
            }
        }
        stage('Terraform Init') {
            steps {
                dir('Eks-Terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir('Eks-Terraform') {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply/Destroy') {
            steps{
                dir('Eks-Terraform') {
                    sh "terraofrm ${action} --auto-approve"
                }
            }
        }
    }
    
}
