#!/bin/bash
#!/bin/bash
ASSUME_ROLE_ARN="arn:aws:iam::533267025020:role/CodeBuildAdmin"
TEMP_ROLE=$(aws sts assume-role --role-arn $ASSUME_ROLE_ARN --role-session-name test)
export TEMP_ROLE
export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')
export PC_SAAS_API_ENDPOINT="https://app0.cloud.twistlock.com/app0-93081645"
export PC_ACCESS_KEY=$(echo $AWS_KEY_ID | jq '.prisma_key' | tr -d '"')
export PC_SECRET_KEY=$(echo $AWS_KEY_ID | jq '.prisma_secret' | tr -d '"')
docker_username=$(echo $AWS_KEY_ID | jq '.docker_username' | tr -d '"')
docker_pass=$(echo $AWS_KEY_ID | jq '.docker_pass' | tr -d '"')
export AWS_REGION=$AWS_DEFAULT_REGION
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
cd app
docker login -u ${docker_username} -p ${docker_pass}
docker pull maven:3-jdk-11
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
echo "AWS Access key:" $AWS_ACCESS_KEY_ID
echo "AWS Account ID:" $AWS_ACCOUNT_ID
docker build . -t $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION --build-arg AWS_REGION=$AWS_REGION -f Dockerfile
curl -k \
    -u $PC_ACCESS_KEY:$PC_SECRET_KEY \
    -X GET -o twistcli \
"https://app0.cloud.twistlock.com/app0-93081645/api/v1/util/twistcli"
chmod +x twistcli
ls -l
./twistcli images scan --address https://app0.cloud.twistlock.com/app0-93081645 -u $PC_ACCESS_KEY -p $PC_SECRET_KEY --details --details $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION
docker tag $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION
docker tag $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
docker logout
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
