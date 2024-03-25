package handlers

import (
	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	service openauth
}

type openauth interface {
}

func NewUserHandler(service openauth) *UserHandler {
	return &UserHandler{service: service}
}

func (ph *UserHandler) Register(router gin.IRouter) {
	// router.GET("/openauth/ping", ph.Ping)
}
