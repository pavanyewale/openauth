package controller

import (
	"context"
	"openauth/controller/grpc"
	"openauth/controller/http"
	"openauth/utils/logger"
)

const (
	GRPC = "GRPC"
	HTTP = "HTTP"
)

type Controller interface {
	Listen()
}

type Config struct {
	Name string
	HTTP http.Config
	GRPC grpc.Config
}

func NewController(ctx context.Context, conf *Config) Controller {
	switch conf.Name {
	case HTTP:
		return http.NewHTTPController(ctx, &conf.HTTP)
	case GRPC:
		return grpc.NewGRPCController(ctx, &conf.GRPC)
	default:
		logger.Panic(ctx, "invalid controller name : current:  %s, Expected : %s|%s", conf.Name, HTTP, GRPC)
	}
	return nil
}
