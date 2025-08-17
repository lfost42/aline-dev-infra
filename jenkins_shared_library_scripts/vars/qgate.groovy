#!/usr/bin/env groovy
def call() {
    echo "Executing pipeline for branch $BRANCH_NAME"
    timeout(time: 1, unit: 'HOURS') {
        script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
                echo 'Pipeline quality gate failed: ${qg.status}'
            }
        }
    }
}