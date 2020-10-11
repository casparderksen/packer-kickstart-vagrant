#!/bin/sh

S3_ENDPOINT=http://localhost:9000

# Init Git and DVC repo
git init
dvc init

git add .gitignore README.md example.sh scripts

# Add file to DVC
dvc add data.txt

# Create bucket for DVC data
mc mb minio/dvc

# Add remote storage and set it as default
dvc remote add -d dvcrepo s3://dvc

# Set remote storage URL
dvc remote modify dvcrepo endpointurl "${S3_ENDPOINT}"

# Create data pipeline
dvc run -n run -d data.txt -o out.txt scripts/run.sh data.txt out.txt
git add dvc.lock dvc.yaml

# Upload tracked file to remote storage
dvc push
