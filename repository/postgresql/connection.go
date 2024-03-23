package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"openauth/utils/logger"

	_ "github.com/lib/pq" // import the PostgreSQL driver
)

type Config struct {
	Host     string
	Port     int
	Username string
	Password string
	Database string
	SSLMode  string // disable/require/verify-ca/verify-full  ## Note: disable by default
}

func NewConnection(ctx context.Context, conf *Config) *sql.DB {
	if conf.SSLMode == "" {
		conf.SSLMode = "disable"
	}
	// Create the connection string
	connString := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		conf.Host, conf.Port, conf.Username, conf.Password, conf.Database, conf.SSLMode)

	// Open a new database connection
	db, err := sql.Open("postgres", connString)
	if err != nil {
		logger.Panic(ctx, "failed to open connection to postgresql: Err: %s", err.Error())
	}

	// Ping the database to check the connection
	err = db.PingContext(ctx)
	if err != nil {
		logger.Panic(ctx, "failed to ping to database: Err: %s", err.Error())
	}

	return db
}
