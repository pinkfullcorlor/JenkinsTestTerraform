pipeline {
  agent { label 'linux'}
  options {
    skipDefaultCheckout(true)
  }
  tools{
    terraform 'TerraformTestDeploy'
  }
  stages{
    stage('clean workspace') {
      steps {
        cleanWs()
      }
    }
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    stage('terraform') {
      steps {
        //sh 'terraform init'
        sh 'terraform apply -auto-approve'
        //sh 'terraform apply -var-file variables.tfvars'
        //sh 'yes'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}