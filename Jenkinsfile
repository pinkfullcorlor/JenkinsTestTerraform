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
        sh 'terraform init'
        sh 'terraform apply -auto-approve -no-color'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}