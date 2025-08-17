#!/usr/bin/env groovy

def call() {
    echo "Terraform Apply"
    sh '''
    cd aws/environments
    cat $ALINE_TFVARS >> variables.auto.tfvars && echo "" >> variables.auto.tfvars
    mv variables.auto.tfvars develop/aline-eks-app/variables.auto.tfvars
    ./run develop aline-eks-app apply
    '''
}