package http

import (
	"context"
	"fmt"
	"net/http"
	"openauth/controller/http/handlers"
	"openauth/service"
	"openauth/utils"
	"openauth/utils/logger"

	"github.com/gin-gonic/gin"
)

type Config struct {
	Port    int
	GinMode string
}

func (c *Config) validate(ctx context.Context) {
	if c.Port == 0 {
		logger.Panic(ctx, "port cannot be empty for HTTP")
	}
	if c.GinMode == "" {
		c.GinMode = "release"
	}
}

type HTTPController struct {
	conf           *Config
	serviceFactory *service.ServiceFactory
	jwtSecreteKey  string
	server         *http.Server
}

func NewHTTPController(ctx context.Context, conf *Config, serviceFactory *service.ServiceFactory, jwtSecreteKey string) *HTTPController {
	conf.validate(ctx)
	return &HTTPController{
		conf:           conf,
		serviceFactory: serviceFactory,
		jwtSecreteKey:  jwtSecreteKey,
	}
}

func (ctrl *HTTPController) Listen(ctx context.Context) {
	gin.SetMode(ctrl.conf.GinMode)
	router := utils.GetHTTPRouter()
	router.Use(utils.JWTMiddleware(ctrl.jwtSecreteKey))

	//registering handlers
	handlers.NewPingHandler(ctrl.serviceFactory.GetPingService()).Register(router)
	handlers.NewGroupHandler(ctrl.serviceFactory.GetGroupService()).Register(router)
	handlers.NewPermissionHandler(ctrl.serviceFactory.GetPermissionService()).Register(router)
	handlers.NewSwaggerHandler().Register(router)

	//listening on port
	logger.Info(ctx, "🌏 swagger 🌎 -> http://localhost:%d/openauth/swagger/index.html", ctrl.conf.Port)

	ctrl.server = &http.Server{
		Addr:    fmt.Sprintf(":%d", ctrl.conf.Port),
		Handler: router,
	}
	err := ctrl.server.ListenAndServe()
	if err != nil && err != http.ErrServerClosed {
		logger.Panic(ctx, "Failed to start server : %v", err)
	}
}

func (ctrl *HTTPController) Shutdown(ctx context.Context) {
	if err := ctrl.server.Shutdown(ctx); err != nil {
		logger.Error(ctx, "failed to shutdown the http server, %v", err.Error())
	}
}
