server {
    listen 80;
    server_name ${nginx_server_name};

    location / {
        proxy_set_header HOST ${origin_dns_domain};
        proxy_ssl_server_name on;
        proxy_ssl_protocols TLSv1.2 TLSv1.3;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_pass https://${origin_dns_domain};
    }
}