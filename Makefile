DB_URL=postgresql://postgres:1234@localhost:5430/simplebank?sslmode=disable

postgres:
	docker run --name postgres --network bank-network -p 5430:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=1234 -d postgres:14-alpine

mysql:
	docker run --name mysql8 -p 3306:3306  -e MYSQL_ROOT_PASSWORD=secret -d mysql:8

createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb simplebank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...