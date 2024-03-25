package handlers

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
)

type PingHandler struct {
	service Service
}

type Service interface {
	Ping(ctx context.Context) error
}

func NewPingHandler(service Service) *PingHandler {
	return &PingHandler{service: service}
}

func (ph *PingHandler) Register(router gin.IRouter) {
	router.GET("/openauth/ping", ph.Ping)
}

// Ping godoc
// @Summary Ping the server
// @Description Pings the server and returns "Everything is working fine."
// @Tags Ping
// @ID ping-endpoint
// @Produce json
// @Success 200 {object} string "Everything is working fine."
// @Failure 500 {object} Response
// @Router /openauth/ping [get]
func (ph *PingHandler) Ping(ctx *gin.Context) {
	if err := ph.service.Ping(ctx); err != nil {
		WriteError(ctx, err)
		return
	}
	ctx.JSON(http.StatusOK, "Everything is working fine.")
}
