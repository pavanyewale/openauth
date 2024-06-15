package migration

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"openauth/repository"
	"openauth/repository/postgresql"
	"openauth/utils/logger"

	"github.com/gofreego/goutils/configutils"
	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	"github.com/golang-migrate/migrate/v4/source/file"
)

const (
	ACTION_UP   = "UP"
	ACTION_DOWN = "DOWN"
)

type Config struct {
	Env          string
	Build        string
	ConfigReader configutils.Config
	Logger       logger.Config
	Repository   repository.Config
	Migration    struct {
		FilesPath string
		Action    string // UP | DOWN
	}
}

func (c *Config) GetReaderConfig() *configutils.Config {
	return &c.ConfigReader
}

func (c *Config) GetEnv() string {
	return c.Env
}

func (c *Config) GetServiceName() string {
	return "OpenauthMigrationScript"
}

type MigrationScript struct {
	conf *Config
	m    *migrate.Migrate
}

func NewMigrationApp(ctx context.Context, configfile string) *MigrationScript {
	var conf Config
	if err := configutils.ReadConfig(ctx, configfile, &conf); err != nil {
		logger.Panic(ctx, "failed to read config for MigrationScript, file: %s, Err: %s", configfile, err.Error())
	}
	bytes, _ := json.MarshalIndent(conf, "", "   ")
	logger.Debug(ctx, "MigrationScript config: %s", bytes)
	logger.Config{AppName: fmt.Sprintf("%s_%s", conf.GetServiceName(), conf.GetEnv()), Build: conf.Build, Level: logger.LogLevel(conf.Logger.Level)}.InitiateLogger()
	return &MigrationScript{conf: &conf}
}

func (app *MigrationScript) Start(ctx context.Context) {
	logger.Info(ctx, "MigrationScript started...")

	fileSource, err := (&file.File{}).Open(app.conf.Migration.FilesPath)
	if err != nil {
		logger.Panic(ctx, "error opening migration source: %v", err)
		return
	}
	defer fileSource.Close()
	conn, db, dbname := getDBDriver(ctx, &app.conf.Repository)
	if app.conf.Migration.Action == ACTION_DOWN {
		result, err := conn.Exec("update schema_migrations  set dirty  = false where dirty = true;")
		if err != nil {
			logger.Panic(ctx, "failed to set dirty false, Err: %s", err.Error())
		}
		_, err = result.RowsAffected()
		if err != nil {
			logger.Panic(ctx, "failed to retrive rows affected, Err: %s", err.Error())
		}
	}

	// Create a new migrate instance
	app.m, err = migrate.NewWithInstance("source", fileSource, dbname, db)
	if err != nil {
		logger.Panic(ctx, "error creating migrate instance: %v", err)
		return
	}

	switch app.conf.Migration.Action {
	case ACTION_UP:
		// Apply the migration
		if err := app.m.Up(); err != nil {
			if err == migrate.ErrNoChange {
				logger.Info(ctx, "no change")
				return
			}
			logger.Panic(ctx, "error applying up migration: %v", err)
			return
		}
	case ACTION_DOWN:
		if err := app.m.Down(); err != nil {
			if err == migrate.ErrNoChange {
				logger.Info(ctx, "no change")
				return
			}
			logger.Panic(ctx, "error applying down migration: %v", err)
			return
		}
	default:
		logger.Panic(ctx, "invalid action current: `%s` Expected : `%s` | `%s`", app.conf.Migration.Action, ACTION_UP, ACTION_DOWN)
	}
	fmt.Println("Migration applied successfully!")
}

func (app *MigrationScript) Shutdown(ctx context.Context) {
	logger.Info(ctx, "MigrationScript shutdown successful!")
	app.m.GracefulStop <- true
}

func getDBDriver(ctx context.Context, conf *repository.Config) (*sql.DB, database.Driver, string) {
	switch conf.Name {
	case repository.PGSQL:
		conn := postgresql.NewConnection(ctx, conf.PGSQL)
		driver, err := postgres.WithInstance(conn, &postgres.Config{DatabaseName: conf.PGSQL.Database})
		if err != nil {
			logger.Panic(ctx, "error creating postgres driver: %v", err)
		}
		return conn, driver, conf.PGSQL.Database
	}

	logger.Panic(ctx, "invalid repository name: current: %s , Expected: %s", conf.Name, repository.PGSQL)
	return nil, nil, ""
}

func (app *MigrationScript) Name() string {
	return "MigrationScript"
}
