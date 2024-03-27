package main

import (
	"context"
	"fmt"
	"openauth/utils/logger"

	"golang.org/x/crypto/bcrypt"
)

func main() {
	password := "1234"
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		fmt.Println("Error hashing password:", err)
		return
	}
	logger.Info(context.TODO(), "'%s'", hashedPassword)
}
