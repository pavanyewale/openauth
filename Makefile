setup: 
	go mod tidy
	go install github.com/golang-migrate/migrate/v4/cmd/migrate@latest
run:
	go run main.go -env=local
migrate:
	go run main.go -env=local -app=MIGRATION
clean:
	rm -f application
build: clean
	go build -o application .