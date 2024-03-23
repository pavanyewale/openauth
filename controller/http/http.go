package http

import "context"

type Config struct {
}

type HTTPController struct {
}

func NewHTTPController(ctx context.Context, conf *Config) *HTTPController {
	return &HTTPController{}
}

func (ctrl *HTTPController) Listen() {

}
