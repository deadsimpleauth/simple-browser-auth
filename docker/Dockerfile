FROM nginx:mainline

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]

RUN apt-get update && apt-get -y upgrade \
    # Install all patches and then install aws cli tools
    && apt-get install awscli -y

#TODO: Expose HTTPS
COPY ./docker/80-dead-simple-auth-download-config.sh /docker-entrypoint.d/
COPY ./docker/index.html /usr/share/nginx/html

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]