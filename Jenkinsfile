pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"   // update path
        PATH = "${FLUTTER_HOME}/bin:${env.PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'YOUR_REPO_URL'
            }
        }

        stage('Flutter Doctor') {
            steps {
                sh 'flutter doctor'
            }
        }

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

        stage('Build AAB (Play Store)') {
            steps {
                sh 'flutter build aab --release'
            }
        }

        stage('Build Web') {
            steps {
                sh 'flutter build web --release'
            }
        }

        stage('Build IPA (iOS)') {
            when {
                expression { return isUnix() } // ensure Mac agent
            }
            steps {
                sh 'flutter build ipa --release'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: '''
                    build/app/outputs/flutter-apk/*.apk,
                    build/app/outputs/bundle/release/*.aab,
                    build/web/**,
                    build/ios/ipa/*.ipa
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