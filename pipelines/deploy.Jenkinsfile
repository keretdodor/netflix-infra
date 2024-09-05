pipeline {
    agent {
        label 'general'
    }
    
    parameters { 
        string(name: 'SERVICE_NAME', defaultValue: '', description: '')
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: '', description: '')
    }

    stages {
        stage('Git Setup') {
             steps {             
                sh 'git checkout -b main || git checkout mian'
            }
        }
        stage ('Deploy and update YAML manifest')
             steps {
                sh ''' 
                    cd k8s/${SERVICE_NAME}
                    sed -i "s|image: .*|image: $IMAGE_FULL_NAME_PARAM|g" netflix-frontend.yml
                    git add "netflix-frontend.yml"
                    git commit -m "Jenkins deploy and update $SERVICE_NAME $IMAGE_FULL_NAME_PARAM"
                '''
             }
        stage ('Push to github')
            steps {
                   withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')])
                   sh 'git push https://$GITHUB_TOKEN@github.com/keretdodor/netflix-infra.git'

            }


               /*
                
                Now your turn! implement the pipeline steps ...
                
                - `cd` into the directory corresponding to the SERVICE_NAME variable. 
                - Change the YAML manifests according to the new $IMAGE_FULL_NAME_PARAM parameter.
                  You can do so using `yq` or `sed` command, by a simple Python script, or any other method.
                - Commit the changes, push them to GitHub. 
                   * Setting global Git user.name and user.email in 'Manage Jenkins > System' is recommended.
                   * Setting Shell executable to `/bin/bash` in 'Manage Jenkins > System' is recommended.
                */ 
                
            }
    post {
        cleanup {
            cleanWs()
        }
    }    
}

    
