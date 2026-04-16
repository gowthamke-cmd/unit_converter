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

        // ✅ Clean only build artifacts (safe)
        stage('Clean Build Artifacts') {
            steps {
                echo "Cleaning build artifacts..."

                bat '''
                if exist build rd /s /q build
                if exist build_apk rd /s /q build_apk
                if exist build_aab rd /s /q build_aab
                if exist build_web rd /s /q build_web
                if exist build_windows rd /s /q build_windows
                '''
            }
        }

        // ✅ Install dependencies
        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
                bat 'flutter precache'
            }
        }

        // ✅ Parallel builds (correct declarative syntax)
        stage('Parallel Build') {
            failFast false
            parallel {

                stage('APK') {
                    when { expression { params.BUILD_APK } }
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            bat '''
                            set BUILD_DIR=build_apk
                            flutter build apk --release --build-dir=%BUILD_DIR%
                            '''
                        }
                    }
                }

                stage('AAB') {
                    when { expression { params.BUILD_AAB } }
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            bat '''
                            set BUILD_DIR=build_aab
                            flutter build aab --release --no-shrink --no-tree-shake-icons --build-dir=%BUILD_DIR%
                            '''
                        }
                    }
                }

                stage('WEB') {
                    when { expression { params.BUILD_WEB } }
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            bat '''
                            set BUILD_DIR=build_web
                            flutter build web --release --build-dir=%BUILD_DIR%
                            '''
                        }
                    }
                }

                stage('WINDOWS') {
                    when { expression { params.BUILD_WINDOWS } }
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            bat '''
                            set BUILD_DIR=build_windows
                            flutter build windows --release --build-dir=%BUILD_DIR%
                            '''
                        }
                    }
                }
            }
        }

        // ✅ Archive artifacts safely
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: '''
                    build_apk/**,
                    build_aab/**,
                    build_web/**,
                    build_windows/**
                ''', fingerprint: true
            }
        }
    }
}