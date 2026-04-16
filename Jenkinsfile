pipeline {
    agent {
        label 'windows-agent'
    }

    environment {
        FLUTTER_HOME = "C:\\flutter"
        PATH = "${FLUTTER_HOME}\\bin;${env.PATH}"
    }

    stages {

        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
            }
        }

        stage('Build APK') {
            steps {
                bat 'flutter build apk --release'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/*.apk',
                fingerprint: true
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