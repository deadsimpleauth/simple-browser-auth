#!/bin/sh
## Download nginx conf from S3 bucket
## Generate self-signed certificates for HTTPS listeners

openssl req -newkey rsa:2048 \
            -x509 \
            -sha256 \
            -days 365 \
            -nodes \
            -out  /etc/ssl/certs/nginx-selfsigned.crt\
            -keyout /etc/ssl/private/nginx-selfsigned.key \
            -subj "/C=US/ST=California/L=San Francisco/O=Security/OU=Security/CN=ecs-nginx.deadsimpleauth.com"


openssl req -x509 -nodes -days 365 -newkey rsa:2048  -out

## sync to /etc/nginx/conf.d must end in .conf
aws s3 sync s3://$DSA_S3_BUCKET/$DSA_CONFIG_S3_PATH /etc/nginx/conf.d/

## Test and Reload Config
nginx -t