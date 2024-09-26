pipeline {
    agent {
        label 'general'
    }
    parameters { 
        choice(name: 'ENV', choices: ['prod', 'dev'], description: '')
        choice(name: 'WORKSPACE', choices: ['default', 'us-east-1'], description: '')
    }
    stages {
        stage('terraform installation ') {
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
                withCredentials({usernamePassword(credentialsId: 'aws', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCEES_KEY')}) {
                    sh '''
                    terraform init
                    if [ "$WORKSPACE" == "default" ]; then
                        WORKSPACE="eu-north-1"
                    fi
                    cd tf
                    terraform apply -auto-approve -var-file "regions.$WORKSPACE.$ENV.tfvars"
                   
                    '''
                }
            }
        }

    }
}
