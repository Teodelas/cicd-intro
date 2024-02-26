#!/bin/bash
ASSUME_ROLE_ARN="arn:aws:iam::533267025020:role/CodeBuildAdmin"
TEMP_ROLE=$(aws sts assume-role --role-arn $ASSUME_ROLE_ARN --role-session-name test)
export TEMP_ROLE
echo "Temp role:"
echo $TEMP_ROLE
export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')
export AWS_REGION=$AWS_DEFAULT_REGION
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
aws sts get-caller-identity
export EKS_CODEBUILD_ROLE_ARN=`aws sts get-caller-identity | jq -r '.Arn'`
helm version
mkdir ~/.kube/
echo "starting update-kubeconfig"
aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
echo "starting kubectl version"
kubectl version --output=json
kubectl get pods
echo "Setup Done !!"