FROM alpine:latest

COPY caddy /usr/bin/

ENTRYPOINT [ "/usr/bin/caddy", "run" ]

CMD ["--config", "/etc/caddy/Caddyfile"]