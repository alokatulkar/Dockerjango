pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t dockerjango .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 8000:8000 dockerjango'
            }
        }
    }
}
