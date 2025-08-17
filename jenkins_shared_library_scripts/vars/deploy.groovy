#!/usr/bin/env groovy
environment {
  // move host info to jenkins
  EC2 = "ubuntu@ec2-13-56-16-192.${AWS_REGION}.compute.amazonaws.com"
}

def ecs() {
    echo 'updating lf-aline-dc'
    docker.withRegistry ("https://${REGISTRY}", "ecr:${AWS_REGION}:${AWS_ID}") {
        def yaml = libraryResource 'docker-compose.yaml'
        writeFile file: "docker-compose.yaml", text: yaml

        sh '''
        for name in "APP_VPC" "APP_LB" "LOAD_BALANCER" "DB_USERNAME" "DB_HOST" "DB_PORT" "DB_NAME" "ACCOUNT_PORT" "BANK_PORT" "CARD_PORT" "GATEWAY_PORT" "TRANSACTION_PORT" "UNDERWRITER_PORT" "USER_PORT"
        do
            value=$(aws ssm get-parameters --names $name --region ${AWS_REGION} --query Parameters[0].Value --output text)
            echo "$name=$value" >> .env_ecs
        done

        docker context create ecs lf_ecs --from-env
        docker context use lf_ecs
        docker compose -p "lf-aline-dc" --env-file .env_ecs up
        '''
    }
}

// try/catch

def eks() {
    echo 'updating lf-aline-eks'
    withKubeConfig([credentialsId: 'lf-kubeconfig']) {
        def yaml = libraryResource "${TYPE}-${SUBNET}-deployment.yaml"
        writeFile file: "deployment.yaml", text: yaml
        sh '''envsubst < deployment.yaml | kubectl apply -f -'''
    }
}

def dockercompose() {
    echo 'Deploy local docker compose'
    withCredentials([file(credentialsId: 'lf-aline-pem', variable: 'PEM_FILE')]) {
        sh """
            ssh -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2} \
            'docker compose -f aline/dc/docker-compose_loc.yml --env-file aline/dc/.env_loc up | exit'
        """
    }
}
// add delay or check prior to exit

def kubernetes() {
    echo 'updating lf-aline-local'
    withKubeConfig([credentialsId: 'lf-local-kubeconfig']) {
        // ssh -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2} \
        'kubectl apply -f aline/k8/${SERVICE}-deployment.yaml --insecure-skip-tls-verify'
    }
}
