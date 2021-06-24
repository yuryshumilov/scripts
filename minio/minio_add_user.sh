#!/bin/bash

#Read variables
while getopts a:u:k:r:h:p:b: flag
do
    case "${flag}" in
        a) MINIO_ALIAS=${OPTARG};;
        u) MINIO_URL=${OPTARG};;
        k) MINIO_ACCESS_KEY=${OPTARG};;
        r) MINIO_SECRET_KEY=${OPTARG};;
        h) MINIO_NEW_USER=${OPTARG};;
        p) MINIO_NEW_USER_PASSWORD=${OPTARG};;
        b) MINIO_BUCKET_NAME=${OPTARG};;
    esac
done

#Prepare access-policy.json
export SED_VAR=$MINIO_BUCKET_NAME
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
