pipeline {
    agent any

    options {
        disableResume()
    }

    stages {
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
