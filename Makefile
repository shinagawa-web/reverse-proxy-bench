WAIT = for i in $$(seq 30); do curl -sf http://localhost:8080/ping > /dev/null && break || sleep 1; done

.PHONY: build bench-nginx bench-caddy bench-traefik bench-haproxy bench

build:
	docker build -t backend ./backend

bench-nginx: build
	docker compose -f nginx/docker-compose.yml up -d
	$(WAIT)
	k6 run -e PROXY=nginx -e TARGET_URL=http://localhost:8080 bench/load.js
	docker compose -f nginx/docker-compose.yml down -v

bench-caddy: build
	docker compose -f caddy/docker-compose.yml up -d
	$(WAIT)
	k6 run -e PROXY=caddy -e TARGET_URL=http://localhost:8080 bench/load.js
	docker compose -f caddy/docker-compose.yml down -v

bench-traefik: build
	docker compose -f traefik/docker-compose.yml up -d
	$(WAIT)
	k6 run -e PROXY=traefik -e TARGET_URL=http://localhost:8080 bench/load.js
	docker compose -f traefik/docker-compose.yml down -v

bench-haproxy: build
	docker compose -f haproxy/docker-compose.yml up -d
	$(WAIT)
	k6 run -e PROXY=haproxy -e TARGET_URL=http://localhost:8080 bench/load.js
	docker compose -f haproxy/docker-compose.yml down -v

bench: build bench-nginx bench-caddy bench-traefik bench-haproxy
