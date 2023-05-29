pipeline {
  agent any

  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName = "g33ck0o/numeric-app:${GIT_COMMIT}"
    applicationURL="https://devsecops.jenkins.promad.com.mx:18084/"
    applicationURI="/increment/99"
  }

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archiveArtifacts 'target/*.jar' //comentario agregado
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
            post {
              always {
                pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
              }
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

      //stage('Vulnerability Scan - Docker') {
      //      steps {
      //          sh "mvn dependency-check:check" //-Dsonar.token=sqp_cdd42f5515b11948627fae0b21c935ecf3eb900a"             
      //      }
      //}

      stage('Vulnerability Scan - Docker') {
            steps {
              parallel(
                   "Dependency Scan": {
                       sh "mvn dependency-check:check"
                    },
                    "Trivy Scan":{
                        sh "bash trivy-docker-image-scan.sh"
                    },
                    "OPA Conftest": {
                      sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile --all-namespaces'
                    }
                )
            }
      }

        stage('Docker Build and Push') {
          steps {
            withDockerRegistry([credentialsId: "docker-hub", url: ""]) { //se actualizan credenciales de docker-hub y se corrije comentario
                sh 'printenv'
                sh 'sudo docker build -t g33ck0o/numeric-app:""$GIT_COMMIT"" .'
                sh 'docker push g33ck0o/numeric-app:""$GIT_COMMIT""'
            }
          }
        }

        stage('Vulnerability Scan Kubernetes') {
          steps {
                sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
          }
        }

        //stage('Kubernetes Deployment - DEV') {
        //  steps {
        //    withKubeConfig([credentialsId: 'kubeconfig']) {
        //      sh "sed -i 's#replace#g33ck0o/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
        //      sh "kubectl apply -f k8s_deployment_service.yaml"
        //      }
        //    }
        // }
        //}

        stage('Kubernetes Deployment - DEV') {
          steps {
            parallel (
              "Deployment": {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                  sh "bash k8s-deployment.sh"
                }
              },
              "Rollout Status": {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                  sh "bash k8s-deployment-rollout-status.sh"
                }
              }
            )
          }
        }
      }

        post {
          always { //fix wrong section
            junit 'target/surefire-reports/*.xml'
            jacoco execPattern: 'target/jacoco.exec'
            dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
          }
        
          //success {

          //}
          //failure {

          //}
        }    
}
