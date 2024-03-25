package utils

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"openauth/constants"
	"openauth/models/dto"
	"openauth/utils/logger"
	"strings"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

// RetrieveUserDetailsFromToken retrieves user details from a JWT token.
func RetrieveUserDetailsFromToken(ctx context.Context, tokenString string, secretKey string) (*dto.AuthenticationResponse, error) {
	// Parse the JWT token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Check the signing method
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		// Return the secret key
		return []byte(secretKey), nil
	})

	if err != nil {
		return nil, err
	}

	// Check if the token is valid
	if !token.Valid {
		return nil, errors.New("invalid token")
	}

	// Extract claims
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return nil, errors.New("invalid claims format")
	}

	userDetailsStr, ok := claims["userDetails"].(string)
	if !ok {
		return &dto.AuthenticationResponse{}, nil
	}
	var authRes dto.AuthenticationResponse
	json.Unmarshal([]byte(userDetailsStr), &authRes)
	return &authRes, nil
}

// Middleware function to extract and validate JWT token from the request header.
func JWTMiddleware(secretKey string) gin.HandlerFunc {

	return func(c *gin.Context) {
		defer c.Next()
		// Extract the token from the Authorization header
		authHeader := c.GetHeader(constants.AUTH_TOKEN)
		if authHeader == "" {
			logger.Debug(c, "%s not present in header", constants.AUTH_TOKEN)
			return
		}

		// Retrieve user details from the token
		userDetails, err := RetrieveUserDetailsFromToken(c.Request.Context(), authHeader, secretKey)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}
		c.Request.Header.Add(constants.USER_ID, fmt.Sprintf("%d", userDetails.UserId))
		c.Request.Header.Add(constants.PERMISSIONS, strings.Join(userDetails.Permissions, ","))
		// Continue with the next middleware or route handler
		c.Next()
	}
}
