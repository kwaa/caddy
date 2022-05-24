FROM alpine:latest

ARG TARGETARCH

COPY caddy_${TARGETARCH} /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]

CMD ["run", "--config", "/etc/caddy/Caddyfile"]
