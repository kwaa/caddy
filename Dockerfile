FROM alpine:latest

ARG TARGETARCH

COPY caddy_${TARGETARCH} /usr/bin/caddy

ENTRYPOINT [ "/usr/bin/caddy", "run" ]

CMD ["--config", "/etc/caddy/Caddyfile"]