MAKE := make --no-print-directory

dev_up: deps
	docker-compose -f docker-compose.dev.yml up -d

dev_down:
	docker-compose -f docker-compose.dev.yml down

test_up: deps
	docker-compose -f docker-compose.test.yml up -d

test_down:
	docker-compose -f docker-compose.test.yml down
