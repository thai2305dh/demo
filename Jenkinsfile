pipeline { 
  agent {label "linux"}
  options {
    buildDiscarder logRotator(artifactDasToKeepStr: '', artifactNumToKeepStr: '5', dasToKeepStr: '', numToKeepStr:'5')
    disableConcurrentBuilds()
  }
  stages {
    stage('hello') {
      steps {
        echo "hello"
      }
    }
  }
}
