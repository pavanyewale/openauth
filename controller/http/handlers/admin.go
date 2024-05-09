package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type AdminUIHandler struct {
}

func NewAdminUIHandler() *AdminUIHandler {
	return &AdminUIHandler{}
}

func (auh *AdminUIHandler) Register(router gin.IRouter) {
	router.StaticFS("/openauth/admin", http.Dir("./admin/build/web"))
}
