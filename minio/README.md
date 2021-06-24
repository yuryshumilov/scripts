# Adding a new user with rights to one repository

Flag | Value
------------ | -------------
ALIAS | Name for set alias in configuration file
URL | Minio URL. Example: https://minio.example.com
ACCESS_KEY | User with administrator rights
SECRET_KEY | Password for user with administrator rights
NEW_USER | Name for new minio user
NEW_USER_PASSWORD | Password for new minio user
BUCKET | Bucket to give access to

How to run script:

```
/bin/bash minio_add_user.sh -a ALIAS -u URL -k ACCESS_KEY -r SECRET_KEY -h NEW_USER -p NEW_USER_PASSWORD -b BUCKET
```
