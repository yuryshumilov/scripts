# Run script:

Flag | Value
------------ | -------------
ALIAS | gazprom
URL | https://minio.example.com
ACCESS_KEY | user with administrator rights
SECRET_KEY | password for user with administrator rights
NEW_USER | New minio user
NEW_USER_PASSWORD | New minio user password
BUCKET | bucket to give access to

How to run script example:

```
/bin/bash minio_add_user.sh -a ALIAS -u URL -k ACCESS_KEY -r SECRET_KEY -h NEW_USER -p NEW_USER_PASSWORD -b BUCKET
```
