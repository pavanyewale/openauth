package postgresql

import (
	"context"
	"database/sql"
	"openauth/utils/logger"
)

type Repository struct {
	conn *sql.DB
}

func NewRepository(ctx context.Context, conf *Config) *Repository {
	if conf == nil {
		logger.Panic(ctx, "no config provided for PGSQL")
	}
	return &Repository{conn: NewConnection(ctx, conf)}
}
