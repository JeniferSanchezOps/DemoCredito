# Makefile para cliente-personas-service

build:
	docker build -t cliente-personas-service .

run:
	docker run --env-file .env -p 8080:8080 --name cliente-app cliente-personas-service

stop:
	docker stop cliente-app || true
	docker rm cliente-app || true

compose-up:
	docker compose up --build

compose-down:
	docker compose down

logs:
	docker logs -f cliente-app

deploy-ec2:
	./install-and-deploy.sh