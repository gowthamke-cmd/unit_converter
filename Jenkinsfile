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

        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
                bat 'flutter precache'
            }
        }

        stage('Parallel Build') {
            failFast false
            parallel {

                stage('APK') {
                    when { expression { params.BUILD_APK } }
                    steps {
                        dir('apk_build') {
                            deleteDir()
                            checkout scm

                            bat 'flutter pub get'
                            bat 'flutter build apk --release'
                        }
                    }
                }

                stage('AAB') {
                    when { expression { params.BUILD_AAB } }
                    steps {
                        dir('aab_build') {
                            deleteDir()
                            checkout scm

                            bat 'flutter pub get'
                            bat 'flutter build aab --release --no-shrink --no-tree-shake-icons'
                        }
                    }
                }

                stage('WEB') {
                    when { expression { params.BUILD_WEB } }
                    steps {
                        dir('web_build') {
                            deleteDir()
                            checkout scm

                            bat 'flutter pub get'
                            bat 'flutter build web --release'
                        }
                    }
                }

                stage('WINDOWS') {
                    when { expression { params.BUILD_WINDOWS } }
                    steps {
                        dir('windows_build') {
                            deleteDir()
                            checkout scm

                            bat 'flutter pub get'
                            bat 'flutter build windows --release'
                        }
                    }
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: '''
                    apk_build/build/app/outputs/flutter-apk/*.apk,
                    aab_build/build/app/outputs/bundle/release/*.aab,
                    web_build/build/web/**,
                    windows_build/build/windows/**
                ''', fingerprint: true
            }
        }
    }
}