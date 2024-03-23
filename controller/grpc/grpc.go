package grpc

import "context"

type Config struct {
}

type GRPCController struct {
}

func NewGRPCController(ctx context.Context, conf *Config) *GRPCController {
	return &GRPCController{}
}

func (ctrl *GRPCController) Listen() {

}
