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
                sh 'git checkout -b main || git checkout main'
            }
        }
        
        stage('Deploy and update YAML manifest') {
            steps {
                sh ''' 
                    echo $SERVICE_NAME
                    cd k8s/${SERVICE_NAME}
                    sed -i "s|image: .*|image: $IMAGE_FULL_NAME_PARAM|" netflix-catalog.yml
                    git add "netflix-catalog.yml"
                    git commit -m "Jenkins deploy and update $SERVICE_NAME $IMAGE_FULL_NAME_PARAM"
                '''
            }
        }
        
        stage('Push to GitHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
                    sh 'git push https://$GITHUB_TOKEN@github.com/keretdodor/netflix-infra.git'
                }
            }
        }


    }
    
    post {
        cleanup {
            cleanWs()
        }
    }
}
