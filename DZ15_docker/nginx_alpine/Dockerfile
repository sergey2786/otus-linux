FROM alpine

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories && \
    apk add --update nginx=1.8.1-r2 vim && \
    rm -rf /var/cache/apk/* && \
    chown -R nginx:www-data /var/lib/nginx 
        
COPY index.html /var/lib/nginx/index.html


EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
