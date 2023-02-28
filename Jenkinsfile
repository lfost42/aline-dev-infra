#!/usr/bin/env groovy
@Library('lib-aline')
def gv

pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('LF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('LF_AWS_SECRET_ACCESS_KEY')
        AWS_ID = credentials('AWS_ID')
        AWS_REGION = credentials('LF_ALINE_AWS_REGION')
        ALINE_TFVARS = credentials('LF_ALINE_TFVARS')
    }
    stages {
        stage('tflint') {
            steps {
                script {
                    echo 'tflint'
                    tflint()
                }
            }
        }
        stage('tftest') {
            when { branch pattern: "^(feature/).*", comparator: "REGEXP"}
            steps {
                script {
                    tftest()
                }
            }
        }
        stage('terraform plan') { 
            steps {
                script {
                    tfplan()
                }
            }
        }
        stage('terraform apply') {
            when { branch pattern: "^(main).*", comparator: "REGEXP"}
            steps {
                script {
                    tfapply()
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}