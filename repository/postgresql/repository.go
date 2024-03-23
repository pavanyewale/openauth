package postgresql

import (
	"context"
	"database/sql"
	"openauth/utils/logger"
)

type PGSQLRepo struct {
	conn *sql.Conn
}

type Config struct {
	Host     string
	Username string
	Password string
	DBName   string
}

func NewPGQLRepository(ctx context.Context, conf *Config) *PGSQLRepo {
	if conf == nil {
		logger.Panic(ctx, "no config provided for PGSQL")
	}
	return &PGSQLRepo{conn: NewConnection(ctx, conf)}
}
