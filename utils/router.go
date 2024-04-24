package utils

import (
	"fmt"
	"net/http"
	"openauth/utils/logger"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func GetHTTPRouter() *gin.Engine {
	engine := gin.New()
	engine.Use(RequestTimeMiddleware)
	engine.Use(RequestIDMiddleware)
	engine.Use(OptionRequestMiddleware)
	return engine

}

func OptionRequestMiddleware(c *gin.Context) {
	if c.Request.Method == "OPTIONS" {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		c.AbortWithStatus(http.StatusOK)
		return
	}
}

func RequestTimeMiddleware(c *gin.Context) {
	start := time.Now()
	c.Next()
	field := &logger.Fields{}
	field.AddField("totalTime", time.Since(start).Milliseconds())
	logger.Infof(c, fmt.Sprintf("%s %s request end ", c.Request.Method, c.Request.URL.Path), field)

}

func RequestIDMiddleware(c *gin.Context) {
	// Set the request ID in the context
	c.Set("requestId", uuid.New().String())
	// Pass control to the next middleware or route handler
	c.Next()
}
