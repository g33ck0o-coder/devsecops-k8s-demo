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
            withDockerRegistry([credentialsId: "docker-hub", url: ""])//se actualizan credenciales de docker-hub {
                sh 'printenv'
                sh 'docker build -t siddharth67/numeric-app:""$GIT_COMMIT"" .'
                sh 'docker push siddharth67/numeric-app:""$GIT_COMMIT""'
          }
        }
      }
    }
}
