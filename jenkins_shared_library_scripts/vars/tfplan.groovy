#!/usr/bin/env groovy

def call() {
    echo "Terraform Plan"
    sh '''
    cd aws/environments
    ./run develop aline-eks-app init
    ./run develop aline-eks-app plan
    '''
}