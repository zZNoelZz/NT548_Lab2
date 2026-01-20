pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "zznoelzz/nt548-lab2-app:latest"
        SONAR_ORG = "zznoelzz"
        SONAR_PROJ = "zZNoelZz_NT548_Lab2"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/zZNoelZz/NT548_Lab2.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('SonarCloud') {
                        bat "${scannerHome}/bin/sonar-scanner " +
                        "-Dsonar.organization=${SONAR_ORG} " +
                        "-Dsonar.projectKey=${SONAR_PROJ} " +
                        "-Dsonar.sources=. " +
                        "-Dsonar.host.url=https://sonarcloud.io"
                    }
                }
            }
        }
        stage('Snyk Security Scan') {
            steps {
                // Sử dụng ID 'snyk.io' bạn đã tạo
                snykSecurity(snykInstallation: 'snyk', snykTokenId: 'snyk.io')
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE} ."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        bat "echo %PASS% | docker login -u %USER% --password-stdin"
                        bat "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                bat "kubectl apply -f k8s-deployment.yaml"
            }
        }
    }
}
