#!/bin/bash
ASSUME_ROLE_ARN="arn:aws:iam::533267025020:role/CodeBuildAdmin"
TEMP_ROLE=$(aws sts assume-role --role-arn $ASSUME_ROLE_ARN --role-session-name test)
export TEMP_ROLE
export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')
export AWS_REGION=$AWS_DEFAULT_REGION
export ENV="dev"
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
bash -c "if [ /"$CODEBUILD_BUILD_SUCCEEDING/" == /"0/" ]; then exit 1; fi"
sleep 60
JAVA_APP_ENDPOINT=`kubectl get svc $EKS_CODEBUILD_APP_NAME-$ENV -o jsonpath="{.status.loadBalancer.ingress[*].hostname}"`
echo -e "\nThe Java application can be accessed nw via http://$JAVA_APP_ENDPOINT"