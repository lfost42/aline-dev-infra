#!/usr/bin/env groovy

def call() {
    echo "Linting terraform files ..."
    sh """
        cd aws
        set -e
        ./lint | tee lint-output.txt
        set +e
        if grep -q "issue(s) found:" lint-output.txt; then
            echo "Linting failed"
            rm lint-output.txt
            exit 1
        fi
        set -e
        rm lint-output.txt
    """
}