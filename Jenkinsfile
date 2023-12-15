pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select action: apply or destroy')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TERRAFORM_WORKSPACE = "/var/lib/jenkins/workspace/tool_deploy/prometheus_infra/"
        INSTALL_WORKSPACE = "/var/lib/jenkins/workspace/tool_deploy/prometheus_role/"
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
                expression { params.ACTION == 'apply' }
            }
            steps {
                // Prompt for approval before applying changes
                input "Do you want to apply Terraform changes?"
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                // Run Terraform apply
                sh """
                    cd ${env.TERRAFORM_WORKSPACE}
                    terraform apply -auto-approve
                    cp ${env.INSTALL_WORKSPACE}/mykey.pem ${env.TERRAFORM_WORKSPACE}
                    chmod 400 ${env.INSTALL_WORKSPACE}/mykey.pem
                """       
            }
        }

        stage('Approval for Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                // Prompt for approval before destroying resources
                input "Do you want to Terraform Destroy?"
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                // Destroy Infra
                sh "cd ${env.TERRAFORM_WORKSPACE} && terraform destroy -auto-approve"
            }
        }
        stage('Prometheus Deploy') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                // Deploy Prometheus
                sh 'chmod 600 /var/lib/jenkins/workspace/tool_deploy/prometheus_role/mykey.pem'
                sh 'chown jenkin:jenkins /var/lib/jenkins/workspace/tool_deploy/prometheus_role/mykey.pem'
                //sh 'service ssh start'
                //sh 'ssh-add /var/lib/jenkins/workspace/tool_deploy/prometheus_role/mykey.pem'
                sh '''cd /var/lib/jenkins/workspace/tool_deploy/prometheus_role/
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
