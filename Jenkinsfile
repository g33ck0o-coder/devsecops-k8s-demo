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
        }

        stage('Mutation Test - PIT') {
            steps {
              sh "mvn org.pitest:pitest-maven:mutationCoverage"
            }
        }

        stage('SonarQube - SAST') {
            steps {
              withSonarQubeEnv('SonarQube') {
                sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.projectName='numeric-application' -Dsonar.host.url=http://192.168.10.144:9000" //-Dsonar.token=sqp_cdd42f5515b11948627fae0b21c935ecf3eb900a"             
            }
            timeout(time: 2, unit: 'MINUTES') {
              script {
                waitForQualityGate abortPipeline: true
              }
            }
        }
      }

      stage('Vulnerability Scan - Docker') {
            steps {
                sh "mvn dependency-check:check" //-Dsonar.token=sqp_cdd42f5515b11948627fae0b21c935ecf3eb900a"             
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

        stage('Kubernetes Deployment - DEV') {
          steps {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "sed -i 's#replace#g33ck0o/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
              sh "kubectl apply -f k8s_deployment_service.yaml"
            }
          }
        }
    }
    post {
      always {
        junit 'target/surefire-reports/*.xml'
        jacoco execPattern: 'target/jacoco.exec'
        pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
      }
      //success {

      //}
      //failure {

      //}
    }
}
