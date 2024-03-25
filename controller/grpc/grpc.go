package grpc

import (
	"context"
	"openauth/service"
	"openauth/utils/logger"
)

type Config struct {
}

type GRPCController struct {
	conf           *Config
	serviceFactory *service.ServiceFactory
}

func NewGRPCController(ctx context.Context, conf *Config, serviceFactory *service.ServiceFactory) *GRPCController {
	return &GRPCController{
		serviceFactory: serviceFactory,
		conf:           conf,
	}
}

func (ctrl *GRPCController) Listen(ctx context.Context) {
	logger.Panic(ctx, "GRPCController not implemented")
}

func (ctrl *GRPCController) Shutdown(ctx context.Context) {
	logger.Panic(ctx, "GRPCController not implemented")
}
