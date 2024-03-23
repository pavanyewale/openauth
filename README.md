# openauth
Highly scallable User Management application written in golang.

## How to start 
1. ```make setup``` it will fetch all the dependancies. 
2. copy ```resources/configs/local.yml``` file into main directory
3. edit as per your local configurations
4. run migrate for migrations ```make migrate```
5. fire below command ```make run```
6. if you want to connect to any other env create a env.yml file where env is your env name and run following command ```go run main.go -env=qa8```

Note: if you want to run it on server you can create a binary using ```make build``` it will build the binary then copy it to server and your configuration file and run it.  using ```./application```

## adding new migrations
Setup migrate command using 
```
make setup
```
Then using following cmd create a new migration file 
```
migrate create -dir sql/migrations -ext sql create_userservice_tables
``` 
For applying migrations use following command
```
make migrate
```
