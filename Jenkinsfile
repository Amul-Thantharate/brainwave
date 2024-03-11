pipeline {
    agent any 
    environment {
            AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        }
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
