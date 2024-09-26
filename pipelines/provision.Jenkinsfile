pipeline {
    agent {
        label 'general'
    }
    parameters { 
        choice(name: 'ENV', choices: ['prod', 'dev'], description: '')
        choice(name: 'WORKSPACE', choices: ['default', 'us-east-1'], description: '')
    }
    stages {
        stage('initializing workspace') {
            steps {
                sh '''
                    terraform --version
                '''
            }
        }   

        stage('initializing workspace') {
            steps {
                sh '''
                    terraform workspace select $WORKSPACE || terraform workspace new $WORKSPACE
                '''
            }
        }    

        stage('auto-apply') {
            steps { 
                sh '''
                    terraform init
                    if [ "$WORKSPACE" == "default" ]; then
                        WORKSPACE="eu-north-1"
                    fi
                    terraform apply -auto-approve -var-file tf/"$WORKSPACE.$ENV.tfvars"
                '''
            }
        }

    }
}
