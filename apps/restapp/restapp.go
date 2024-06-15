package restapp

import (
	"context"
	"encoding/json"
	"openauth/controller"
	"openauth/repository"
	"openauth/service"
	"openauth/utils/logger"

	"github.com/gofreego/goutils/configutils"
)

type Config struct {
	Env          string
	ConfigReader configutils.Config
	CTRL         controller.Config
	Service      service.Config
	Repository   repository.Config
}

func (c *Config) GetReaderConfig() *configutils.Config {
	return &c.ConfigReader
}

func (c *Config) GetEnv() string {
	return c.Env
}

func (c *Config) GetServiceName() string {
	return "OpenAuthService"
}

type RestApp struct {
	conf       *Config
	controller controller.Controller
}

func NewRestApp(ctx context.Context, configfile string) *RestApp {
	var conf Config
	if err := configutils.ReadConfig(ctx, configfile, &conf); err != nil {
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
	app.controller = controller.NewController(ctx, &app.conf.CTRL, service, app.conf.Service.Auth.JWTSecretekey)
	app.controller.Listen(ctx)
}

func (app *RestApp) Shutdown(ctx context.Context) {
	app.controller.Shutdown(ctx)
	logger.Info(ctx, "RestApp shutdown successful!")
}

func (app *RestApp) Name() string {
	return "RestApp"
}
