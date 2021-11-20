#!/bin/sh

ORG=hi1280
REPO=ecs-deployment-pipeline
BRANCH=main

DATA=`cat << EOS
{"ref":"${BRANCH}"}
EOS
`

RESULT=`curl \
  -X POST \
  -H "Authorization: token ${PERSONAL_ACCESS_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/${ORG}/${REPO}/actions/workflows/update-production.yml/dispatches \
  -d $DATA`

if [ "$RESULT" = "" ]; then
  echo "Start Deploy"
else
  echo "Failed to start deploy"
  echo $RESULT
fi
