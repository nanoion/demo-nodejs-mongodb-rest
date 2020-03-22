pipeline {
  agent {
	
  stages {
    stage('Checkout') {
        checkout scm
    }

    stage("Docker build") {

        dockerfile {
        filename 'Dockerfile'
        dir '.'
        label 'production'
        additionalBuildArgs  '-t app:1.0.0'
        }
    }

  }
}
}
