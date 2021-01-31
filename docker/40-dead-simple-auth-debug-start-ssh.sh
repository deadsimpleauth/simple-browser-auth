#!/bin/sh
/etc/init.d/ssh start

# Share credential URI with interactive shells
echo "export AWS_CONTAINER_CREDENTIALS_RELATIVE_URI=$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI" >> /root/.profile

# Shove ENV creds into file
env > ~/env-dump