package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"openauth/apps/migration"
	"openauth/apps/restapp"
	"openauth/config"

	"openauth/utils/logger"

	"github.com/gofreego/goutils/apputils"
)

var (
	env string
	app string
)

const (
	RESTAPP   = "RESTAPP"
	MIGRATION = "MIGRATION"
)

type Application interface {
	Name() string
	Start(ctx context.Context)
	Shutdown(ctx context.Context)
}

func main() {

	flag.StringVar(&env, "env", "dev", "env to run the application")
	flag.StringVar(&app, "app", "", "appname to start")
	flag.Parse()

	var conf config.Configurations
	ctx := context.Background()
	configfile := fmt.Sprintf("%s.yml", env)
	err := config.ReadConfig(configfile, &conf)
	if err != nil {
		logger.Panic(ctx, "failed to read config:file: %s, Err: %v", configfile, err.Error())
	}
	logger.Config{AppName: conf.Name, Build: conf.Build, Level: logger.LogLevel(conf.LogLevel)}.InitiateLogger()
	bytes, _ := json.MarshalIndent(conf, "", "   ")
	logger.Debug(ctx, "main config: %s", bytes)
	if app != "" {
		conf.App = app
	}
	var app Application
	switch conf.App {
	case "", RESTAPP:
		app = restapp.NewRestApp(ctx, configfile)
	case MIGRATION:
		app = migration.NewMigrationApp(ctx, configfile)
	default:
		logger.Panic(ctx, "invalid App, current: %s, Expected : %s | %s", conf.App, RESTAPP, MIGRATION)
	}
	go app.Start(ctx)

	apputils.GracefulShutdown(ctx, app)
}
