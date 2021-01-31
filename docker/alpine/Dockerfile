FROM nginx:alpine

ENTRYPOINT ["/docker-entrypoint.sh"]

RUN apk update && apk upgrade \
    # Install all patches and then install aws cli tools
    && apk add aws-cli

#TODO: Expose HTTPS
COPY ./docker/30-dead-simple-auth-download-config.sh /docker-entrypoint.d/

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]