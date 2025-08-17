#!/usr/bin/env groovy

def mvn() {
    echo "Executing pipeline for branch $BRANCH_NAME"
    def mvn = tool 'Default Maven';
    withSonarQubeEnv() {
        sh "${mvn}/bin/mvn clean verify sonar:sonar"
    }
}

def node() {
    echo "Executing pipeline for branch $BRANCH_NAME"
    def scannerHome = tool 'SonarScanner';
        withSonarQubeEnv() {
        sh "${tool("SonarScanner")}/bin/sonar-scanner \
        -Dsonar.projectKey=test-node-js \
        -Dsonar.typescript.node=./node/node \
        -Dsonar.sources=. \
        -Dsonar.css.node=."
    }
}
