# Aline Financial

## Usage

Aline Financial is an online banking platform that utilizes the power of the AWS Cloud to deliver a seamless and secure user experience. The platform is composed of multiple microservices and user interface components that handles member applications, credit-line underwriting, etc. This allows customers to easily register for accounts, apply for lines of credit, and conduct financial transactions. 

### Aline Financial App Architecture:

![logo](diagram.png)

## Source files
This repo contains Terraform resource files for the Aline Banking Application. 

## Support

lynda.foster@smoothstack.com<br>
[Cyber Cumulus Jira](https://cyber-cumulus-smoothstack.atlassian.net/jira/software/projects/CC/boards/1)

## Roadmap

[Aline DevOps repo](https://git1.smoothstack.com/cohorts/2022/organizations/cyber-cumulus/lynda-foster/aws-cicd) - Check the devlop branch for completed features.

- [x] Cloud Containerization

    - [x] Kubernetes Cloud - EKS
    - [x] Docker-Compose Cloud via ECS

- [x] Jenkins CI/CD
Our Jenkins distributed environment and SonarQube server is runs on 2 EC2 instances.  
    - [x] Jenkins Pipelines for Microservices
        - Multi-branch pipelines with a [Node](https://git1.smoothstack.com/cohorts/2022/organizations/cyber-cumulus/lynda-foster/lib-aline-node) and [Maven](https://git1.smoothstack.com/cohorts/2022/organizations/cyber-cumulus/lynda-foster/lib-aline-maven) class library.
        - Push and Merge triggers via Jenkins Integrations webhook on GitLab. 
    - [x] Jenkins Integration with SonarQube
        - Tests and Quality Gates for each Maven and Node applications implemented. 
    - [x] Docker-Compose via Jenkins
    - [x] Kubernetes via Jenkins
    - [x] Terraform Plan and Apply via Jenkins

- [x] Terraform CI/CD
    - [x] Architect Base Infrastructure
    - [x] Create Base Infrastructure
    - [x] TFLint
    - [x] Terratest
    - [x] Terraform Associate Certificate

- [ ] General CI/CD
    - [ ] Ansible Playbooks
    - [ ] Vanilla CloudFormation Templates
 
## Acknowledgements
Lead Developer:

[Lynda Foster](https://git1.smoothstack.com/lynda.foster)

With support from the Cyber Cumulus Team:

[Anthony Foster](https://git1.smoothstack.com/anthony.foster)<br>
[Nathan Galler](https://git1.smoothstack.com/nathan.galler)<br>
[Dennis Ghitas](https://git1.smoothstack.com/dennis.ghitas)<br>
[Sebastian Marzal](https://git1.smoothstack.com/sebastian.marzal)

## License
[MIT License](LICENSE)

## Project status
Local Containerization and Automation Complete
Coud Containerization and Automation Complete
Jenkins CI/CD Complete
Terraform CI/CD Complete