FROM node:24-bookworm AS builder

WORKDIR /data

COPY ./ /data

RUN corepack enable pnpm && \
    pnpm install && \
    pnpm run generate

FROM caddy:alpine
COPY --from=builder /data/.output/public /usr/share/caddy
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
COPY <<"EOT" /etc/caddy/Caddyfile
https:// {
    root * /usr/share/caddy
    handle /ws* {
        reverse_proxy signaling:3000
    }
    handle {
        file_server
    }
    header /runtime-config.js Cache-Control "no-store"
    tls internal {
	    on_demand
    }
}
EOT
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
