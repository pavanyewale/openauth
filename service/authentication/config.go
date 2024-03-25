package authentication

import (
	"context"
	"openauth/constants"
	"openauth/utils/logger"
)

type Config struct {
	AuthTokenExpriryInDays int
	TokenType              string
	JWTSecretekey          string
}

func (c *Config) validate(ctx context.Context) {
	if c.AuthTokenExpriryInDays <= 0 {
		logger.Panic(ctx, "AuthTokenExpriryInDays should not be <= 0")
	}

	if c.TokenType == constants.TOKEN_TYPE_JWT && c.JWTSecretekey == "" {
		logger.Panic(ctx, "if TokenType is JWT then JWTSecretekey should not be empty")
	}

	if c.TokenType == "" {
		logger.Info(ctx, "AuthType is empty , using default auth type as UUID")
	}
}
