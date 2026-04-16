pipeline {
    agent any

    environment {
        FLUTTER_HOME = "C:\\flutter"
        PATH = "${FLUTTER_HOME}\\bin;${env.PATH}"
    }

    stages {

        stage('Clean & Get Packages') {
            steps {
                sh '''
                    flutter clean
                    flutter pub get
                '''
            }
        }

        stage('Build APK') {
            steps {
                sh 'flutter build apk --release'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: '''
                    build/app/outputs/flutter-apk/*.apk,
                ''', fingerprint: true
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully 🚀'
        }
        failure {
            echo 'Build failed ❌'
        }
    }
}