#!/usr/bin/env groovy
def mvn() {
    echo 'building application'
    sh '''git submodule deinit -f .
    git submodule update --init --remote --merge

    mvn package -DskipTests=true'''
}

def node_react() {
    echo 'building application'
    sh '''npm install
    npm run build'''
}

def node_angular() {
    echo 'building application'
    sh '''npm install npm@7.24.0 --legacy-peer-deps
    npm run build'''
}