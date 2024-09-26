pipeline {
    agent {
        label 'general'
    }
    parameters { 
       parameters { choice(name: 'ENV', choices: ['prod', 'dev'], description: '') }.
       parameters { choice(name: 'WORKSPACE', choices: ['default', 'us-east-1',], description: '') }.
    }
    stages {

            stage('initializing workspace') {
                steps {
                    sh '''
                        terraform select $WORKSPACE
                    
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
