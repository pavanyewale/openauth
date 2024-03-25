package repository

import (
	"context"
	"openauth/repository/postgresql"
	"openauth/service"
	"openauth/utils/logger"
)

const (
	PGSQL = "PGSQL"
)

type Config struct {
	Name  string
	PGSQL *postgresql.Config
}

type Repository interface {
	service.Repository
}

func NewRepository(ctx context.Context, conf *Config) Repository {
	switch conf.Name {
	case PGSQL:
		return postgresql.NewRepository(ctx, conf.PGSQL)
	default:
		logger.Panic(ctx, "invalid repository name : Current: %s, Expected: %s", conf.Name, PGSQL)
	}
	return nil
}
