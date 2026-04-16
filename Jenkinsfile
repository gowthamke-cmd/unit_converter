pipeline {
    agent {
        label 'windows-agent'
    }

    parameters {
        booleanParam(name: 'BUILD_APK', defaultValue: true, description: 'Build Android APK')
        booleanParam(name: 'BUILD_AAB', defaultValue: true, description: 'Build Android AAB')
        booleanParam(name: 'BUILD_WEB', defaultValue: true, description: 'Build Web')
        booleanParam(name: 'BUILD_WINDOWS', defaultValue: true, description: 'Build Windows App')
    }

    environment {
        FLUTTER_HOME = "C:\\flutter"
        ANDROID_HOME = "C:\\Users\\DevOps\\AppData\\Local\\Android\\Sdk"
        PATH = "${FLUTTER_HOME}\\bin;${ANDROID_HOME}\\platform-tools;${env.PATH}"
    }

    stages {

        stage('Clean Build Artifacts') {
    steps {
        echo "Cleaning only build artifacts..."

        bat '''
        if exist build rd /s /q build
        if exist build_apk rd /s /q build_apk
        if exist build_aab rd /s /q build_aab
        if exist build_web rd /s /q build_web
        if exist build_windows rd /s /q build_windows
        '''
    }
}


        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
            }
        }

        stage('Parallel Build') {
            parallel {

                stage('APK') {
                    when { expression { params.BUILD_APK } }
                    steps {
                        bat 'flutter build apk --release'
                    }
                }

                stage('AAB') {
                    when { expression { params.BUILD_AAB } }
                    steps {
                        bat 'flutter build aab --release --no-shrink'
                    }
                }

                stage('WEB') {
                    when { expression { params.BUILD_WEB } }
                    steps {
                        bat 'flutter build web --release'
                    }
                }

                stage('WINDOWS') {
                    when { expression { params.BUILD_WINDOWS } }
                    steps {
                        bat 'flutter build windows --release'
                    }
                }

            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: '''
                    build/app/outputs/flutter-apk/*.apk,
                    build/app/outputs/bundle/release/*.aab,
                    build/web/**,
                    build/windows/**
                ''', fingerprint: true
            }
        }
    }
}