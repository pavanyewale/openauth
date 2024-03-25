package utils

import (
	"fmt"
	"openauth/utils/logger"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func GetHTTPRouter() *gin.Engine {
	engine := gin.New()
	engine.Use(RequestTimeMiddleware())
	engine.Use(RequestIDMiddleware())
	return engine

}

func RequestTimeMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		c.Next()
		field := &logger.Fields{}
		field.AddField("totalTime", time.Since(start).Milliseconds())
		logger.Infof(c, fmt.Sprintf("%s %s request end ", c.Request.Method, c.Request.URL.Path), field)
	}
}

func RequestIDMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Set the request ID in the context
		c.Set("requestId", uuid.New().String())
		// Pass control to the next middleware or route handler
		c.Next()
	}
}
