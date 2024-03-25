package service

import (
	"context"
	"openauth/service/ping"
)

type ServiceFactory struct {
	PingService *ping.Service
}

type Config struct {
}

type Repository interface {
	ping.Repository
}

func NewServiceFactory(ctx context.Context, conf *Config, repo Repository) *ServiceFactory {
	return &ServiceFactory{
		PingService: ping.NewService(ctx, repo),
	}
}
