pipeline {

    agent { label 'docker-agent' }

    stages {
        stage ( "Building maven 3.5-openjdk-7") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh "make build base=openjdk:7-alpine version=3.5.4 name=3.5-openjdk-7"
                        sh "make push v=3.5-openjdk-7"
                    }
                }
            }
        }

        stage ( "Building maven 3.6-openjdk-7") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh "make build base=openjdk:7-alpine version=3.6.3 name=3.6-openjdk-7"
                        sh "make push v=3.6-openjdk-7"
                    }
                }
            }
        }

        stage ( "Building maven 3.8-openjdk-7") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh "make build base=openjdk:7-alpine version=3.8.3 name=3.8-openjdk-7"
                        sh "make push v=3.8-openjdk-7"
                    }
                }
            }
        }

        stage ( "Building maven 3.5-openjdk-8") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh "make build base=openjdk:8-alpine version=3.5.4 name=3.5-openjdk-8"
                        sh "make push v=3.5-openjdk-8"
                    }
                }
            }
        }

        stage ( "Building maven 3.6-openjdk-8") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh "make build base=openjdk:8-alpine version=3.6.3 name=3.6-openjdk-8"
                        sh "make push v=3.6-openjdk-8"
                    }
                }
            }
        }

        stage ( "Building maven 3.8-openjdk-8") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh "make build base=openjdk:8-alpine version=3.8.3 name=3.8-openjdk-8"
                        sh "make push v=3.8-openjdk-8"
                    }
                }
            }
        }

        stage ( "Building maven 3.8-openjdk-16") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh "make build base=openjdk:16-alpine version=3.8.3 name=3.8-openjdk-16"
                        sh "make push v=3.8-openjdk-16"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'make remove'
            }
        }
        cleanup {
            cleanWs()
        }
    }
}
