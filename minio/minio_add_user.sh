#!/bin/bash

#Read variables
$MINIO_ALIAS=$1
$MINIO_URL=$2
$MINIO_ACCESS_KEY=$3
$MINIO_SECRET_KEY=$4
$MINIO_NEW_USER=$5
$MINIO_NEW_USER_PASSWORD=$6
$MINIO_BUCKET_NAME=$1

#Prepare access-policy.json
export SED_VAR=$1
envsubst < "access-policy.json" > "$MINIO_NEW_USER-access-policy.json"
cat $MINIO_NEW_USER-access-policy.json

#Set alias
mc alias set $MINIO_ALIAS $MINIO_URL $MINIO_ACCESS_KEY $MINIO_SECRET_KEY --api "s3v4" --path "auto"

#Create user
mc admin user add $MINIO_ALIAS $MINIO_NEW_USER $MINIO_NEW_USER_PASSWORD

#Create policy from access-policy.json
mc admin policy add $MINIO_ALIAS $MINIO_NEW_USER-policy $MINIO_NEW_USER-access-policy.json

#Apply policy for new MINIO_NEW_USER
mc admin policy set $MINIO_ALIAS $MINIO_NEW_USER-policy user=$MINIO_NEW_USER

#Clear directory
rm $MINIO_NEW_USER-access-policy.json
