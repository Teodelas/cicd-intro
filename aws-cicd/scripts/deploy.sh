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

helm upgrade -i $EKS_CODEBUILD_APP_NAME-$ENV helm_charts/$EKS_CODEBUILD_APP_NAME -f helm_charts/$EKS_CODEBUILD_APP_NAME/values.$ENV.yaml --set image.repository=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME --set image.tag=$CODEBUILD_RESOLVED_SOURCE_VERSION