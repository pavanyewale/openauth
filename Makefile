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
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o application .

docker: build
	docker build -t openauth .

dockerrun:
    # run with container name
	docker container stop openauth
	docker container rm openauth
	docker run -p 8000:8000 -d --name openauth openauth