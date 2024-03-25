package restapp

import (
	"context"
	"encoding/json"
	"openauth/config"
	"openauth/controller"
	"openauth/repository"
	"openauth/service"
	"openauth/utils/logger"
)

type Config struct {
	CTRL          controller.Config
	Service       service.Config
	Repository    repository.Config
	JWTSecretekey string
}

type RestApp struct {
	conf       *Config
	controller controller.Controller
}

func NewRestApp(ctx context.Context, configfile string) *RestApp {
	var conf Config
	if err := config.ReadConfig(configfile, &conf); err != nil {
		logger.Panic(ctx, "failed to read config for RestApp, file: %s, Err: %s", configfile, err.Error())
	}
	bytes, _ := json.MarshalIndent(conf, "", "   ")
	logger.Debug(ctx, "RestApp config: %s", bytes)
	return &RestApp{conf: &conf}
}

func (app *RestApp) Start(ctx context.Context) {
	logger.Info(ctx, "starting RestApp...")
	repo := repository.NewRepository(ctx, &app.conf.Repository)
	service := service.NewServiceFactory(ctx, &app.conf.Service, repo)
	app.controller = controller.NewController(ctx, &app.conf.CTRL, service, app.conf.JWTSecretekey)
	app.controller.Listen(ctx)
}

func (app *RestApp) Shutdown(ctx context.Context) {
	app.controller.Shutdown(ctx)
	logger.Info(ctx, "RestApp shutdown successful!")
}
