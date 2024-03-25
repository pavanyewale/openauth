package handlers

import (
	_ "openauth/docs"

	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

type SwaggerHandler struct {
}

func NewSwaggerHandler() *SwaggerHandler {
	return &SwaggerHandler{}
}

func (sh *SwaggerHandler) Register(router gin.IRouter) {
	router.GET("/openauth/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
}
