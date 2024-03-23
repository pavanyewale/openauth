setup: 
	go mod tidy
run:
	go run main.go -env=local
clean:
	rm -f application
build: clean
	go build -o application .