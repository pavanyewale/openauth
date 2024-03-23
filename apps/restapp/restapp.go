package restapp

import (
	"context"
	"openauth/config"
	"openauth/utils/logger"
)

type Config struct {
	config.Configurations
}

type RestApp struct {
	conf *Config
}

func NewRestApp(ctx context.Context, configfile string) *RestApp {
	var conf Config
	if err := config.ReadConfig(configfile, &conf); err != nil {
		logger.Panic(ctx, "failed to read config for RestApp, file: %s, Err: %s", configfile, err.Error())
	}
	return &RestApp{conf: &conf}
}

func (app *RestApp) Start(ctx context.Context) {
	logger.Info(ctx, "RestApp started...")
}

func (app *RestApp) Shutdown(ctx context.Context) {
	logger.Info(ctx, "RestApp shutdown successful!")

}
