package controller

import (
	"context"
	"openauth/controller/grpc"
	"openauth/controller/http"
	"openauth/service"
	"openauth/utils/logger"
)

const (
	GRPC = "GRPC"
	HTTP = "HTTP"
)

type Controller interface {
	Listen(ctx context.Context)
	Shutdown(ctx context.Context)
}

type Config struct {
	Name string
	HTTP http.Config
	GRPC grpc.Config
}

func NewController(ctx context.Context, conf *Config, serviceFactory *service.ServiceFactory, jwtSecreteKey string) Controller {
	switch conf.Name {
	case HTTP:
		return http.NewHTTPController(ctx, &conf.HTTP, serviceFactory, jwtSecreteKey)
	case GRPC:
		return grpc.NewGRPCController(ctx, &conf.GRPC, serviceFactory)
	default:
		logger.Panic(ctx, "invalid controller name : current:  %s, Expected : %s|%s", conf.Name, HTTP, GRPC)
	}
	return nil
}
