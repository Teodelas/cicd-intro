#!/bin/bash
#!/bin/bash
key_id=$(echo $AWS_KEY_ID | jq '.aws_key_id' | tr -d '"') 
key_secret=$(echo $AWS_KEY_ID | jq '.aws_key_secret' | tr -d '"')
docker_username=$(echo $AWS_KEY_ID | jq '.docker_username' | tr -d '"')
docker_pass=$(echo $AWS_KEY_ID | jq '.docker_pass' | tr -d '"')
export AWS_ACCESS_KEY_ID=$key_id
export AWS_SECRET_ACCESS_KEY=$key_secret
export AWS_REGION=$AWS_DEFAULT_REGION
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
cd app
docker login -u ${docker_username} -p ${docker_pass}
docker pull maven:3-jdk-11
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
echo "AWS Access key:" $AWS_ACCESS_KEY_ID
echo "AWS Account ID:" $AWS_ACCOUNT_ID
docker build . -t $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION --build-arg AWS_REGION=$AWS_REGION -f Dockerfile
docker tag $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION
docker tag $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
docker logout
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
