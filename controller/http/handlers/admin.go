package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type AdminConfig struct {
	UIFiesPath string
}

type AdminUIHandler struct {
	conf *AdminConfig
}

func NewAdminUIHandler(conf *AdminConfig) *AdminUIHandler {
	return &AdminUIHandler{
		conf: conf,
	}
}

func (auh *AdminUIHandler) Register(router gin.IRouter) {
	router.StaticFS("/openauth/admin", http.Dir(auh.conf.UIFiesPath))
}
