package main

import (
	"context"

	"openauth/utils/logger"
)

func main() {

	logger.Config{AppName: "Test App", Build: "dev"}.InitiateLogger()
	ctx := context.Background()
	logger.AddMiddleLayers(logger.RequestMiddleLayer)
	ctx = context.WithValue(ctx, logger.RequestContextKey, &logger.RequestContext{RequestID: "134234", UserID: "456", IP: "196.1.100.23", URI: "/test/ping", ClientAppID: "RUMMY"})
	logger.Info(ctx, "info level message")
	logger.Warn(ctx, "warn message")
	logger.Debug(ctx, "debug message")
	logger.Error(ctx, "error message")
	fields := &logger.Fields{}
	fields.AddField("time_taken", 49856)
	logger.Infow(ctx, "Request end", fields)
}
