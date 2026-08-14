# reverse-proxy-bench

Companion repository for the article **[Nginx, Caddy, Traefik, or HAProxy: How to Pick the Right Reverse Proxy for Your Stack (2026)](https://dev.to/shinagawa-web/nginx-caddy-traefik-or-haproxy-how-to-pick-the-right-reverse-proxy-for-your-stack-2026-2doj)**.

Each directory contains a config file and a `docker-compose.yml` for one proxy, all routing to the same Go backend.

## Structure

```
├── backend/      # Go HTTP server — /ping (200 OK) and /slow (100ms delay)
├── nginx/        # nginx.conf + docker-compose.yml
├── caddy/        # Caddyfile + docker-compose.yml
├── traefik/      # traefik.yml + routes.yml + docker-compose.yml
├── haproxy/      # haproxy.cfg + docker-compose.yml
└── bench/        # k6 load test script (VU 20, 60s)
```

## Run locally

Requires Docker and [k6](https://k6.io/docs/get-started/installation/).

```sh
make bench-nginx
make bench-caddy
make bench-traefik
make bench-haproxy
make bench        # run all four in sequence
```

## CI benchmark

Every pull request runs a 60-second load test against each proxy and posts results as a PR comment.
