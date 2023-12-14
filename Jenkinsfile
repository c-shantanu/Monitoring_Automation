pipeline {
    agent any
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TERRAFORM_WORKSPACE = "/var/lib/jenkins/workspace/prometheus_infra/"
        INSTALL_WORKSPACE = "/var/lib/jenkins/workspace/prometheus_role/"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/c-shantanu/monitoring_automation.git'
            }
        } 
        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh "cd ${env.TERRAFORM_WORKSPACE} && terraform init"
            }
        }

        stage('Terraform Plan') {
            steps {
                // Run Terraform plan
                sh "cd ${env.TERRAFORM_WORKSPACE} && terraform plan"
            }
        }
        stage('Approval For Apply') {
            when {
                expression { params.action == 'apply' }
            }
            steps {
                // Prompt for approval before applying changes
                input "Do you want to apply Terraform changes?"
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.action == 'apply' }
            }
            steps {
                // Run Terraform apply
                sh """
                    cd ${env.TERRAFORM_WORKSPACE}
                    terraform apply -auto-approve
                    sudo cp ${env.TERRAFORM_WORKSPACE}/mykey.pem ${env.INSTALL_WORKSPACE}
                    sudo chmod 400 ${env.INSTALL_WORKSPACE}/pgsql.pem
                """       
            }
        }

        stage('Approval for Destroy') {
            when {
                expression { params.action == 'destroy' }
            }
            steps {
                // Prompt for approval before destroying resources
                input "Do you want to Terraform Destroy?"
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.action == 'destroy' }
            }
            steps {
                // Destroy Infra
                sh "cd ${env.TERRAFORM_WORKSPACE} && terraform destroy -auto-approve"
            }
        }
        stage('Posgresql Deploy') {
            when {
                expression { params.action == 'apply' }
            }
            steps {
                // Deploy Pgsql
                sh '''cd /var/lib/jenkins/workspace/prometheus_role/
                ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml    '''
            }
        }

    }

    post {
        success {
            // Actions to take if the pipeline is successful
            echo 'Succeeded!'
        }
        failure {
            // Actions to take if the pipeline fails
            echo 'Failed!'
        }
    }
}
