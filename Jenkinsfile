pipeline {
   agent any
   environment {
      AWS_REGION = 'us-east-1'
      ECR_REPOSITORY = '811604303985.dkr.ecr.us-east-1.amazonaws.com/code2cloud-ecr'
      CONTAINER_NAME = 'code2cloud'
   }
    stages {
        stage('Build') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                  sh ''' 
                  docker ps
                  aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY:$CONTAINER_NAME
                  echo "Building the Docker image..."
                  docker build -t $ECR_REPOSITORY:$CONTAINER_NAME ./app/
                  docker image  prune -f
                  docker image ls
                  '''
               }
            }
        }
        stage('Artifactory Deploy') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                  sh ''' 
                  docker ps
                  $(aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email)
                  echo "Image push into registry"
                  docker push $ECR_REPOSITORY:$CONTAINER_NAME
                  '''
               }
            }
        }
        stage('Server Deploy') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                sh '''
                    aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY:$CONTAINER_NAME
                    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o ./docker-compose                    
                    echo "ECR_REPOSITORY=$ECR_REPOSITORY 
                    CONTAINER_NAME=$CONTAINER_NAME" >> .env

                    docker image  prune -f
                    chmod +x docker-compose
                    ./docker-compose --env-file=.env pull && ./docker-compose --env-file=.env up -d
                '''
                }
            }
        }
    }
}