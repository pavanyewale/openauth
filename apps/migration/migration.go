package migration

import (
	"context"
	"encoding/json"
	"openauth/config"
	"openauth/utils/logger"
)

type Config struct {
	config.Configurations
}

type MigrationScript struct {
	conf *Config
}

func NewMigrationApp(ctx context.Context, configfile string) *MigrationScript {
	var conf Config
	if err := config.ReadConfig(configfile, &conf); err != nil {
		logger.Panic(ctx, "failed to read config for MigrationScript, file: %s, Err: %s", configfile, err.Error())
	}
	bytes, _ := json.MarshalIndent(conf, "", "   ")
	logger.Debug(ctx, "MigrationScript config: %s", bytes)
	return &MigrationScript{conf: &conf}
}

func (app *MigrationScript) Start(ctx context.Context) {
	logger.Info(ctx, "MigrationScript started...")
}

func (app *MigrationScript) Shutdown(ctx context.Context) {
	logger.Info(ctx, "MigrationScript shutdown successful!")
}
