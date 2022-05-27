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
        //sh './terraformw apply -auto-approve -no-color'\
        sh 'terraform init'
        sh 'terraform plan -var-file terraform.tfvars'
        sh 'terraform destroy -auto-approve'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}