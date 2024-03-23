package repository

import "context"

type Config struct {
}

type Repository interface {
}

func NewRepository(ctx context.Context, conf *Config) Repository {
	return nil
}
