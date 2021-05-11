FROM alpine:latest

COPY caddy /usr/bin/

EXPOSE 80 443 2019

ENTRYPOINT [ "/usr/bin/caddy", "run" ]

CMD ["--config", "/etc/caddy/Caddyfile"]