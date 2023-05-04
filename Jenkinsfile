pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //comentario agregado
            }
        }
        
         stage('Unit Test - JUnit and Jacoco') {
            steps {
              sh "mvn test"
            }
            post {
              always {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
        }

        stage('Docker Build and Push') {
          steps {
            withDockerRegistry([credentialsId: "docker-hub", url: ""]) { //se actualizan credenciales de docker-hub y se corrije comentario
                sh 'printenv'
                sh 'docker build -t g33ck0o/numeric-app:""$GIT_COMMIT"" .'
                sh 'docker push g33ck0o/numeric-app:""$GIT_COMMIT""'
          }
        }
      }
    }
}
