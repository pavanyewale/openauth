package utils

import (
	"openauth/constants"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)

// returns true if any string from permsNeeded exists in userPerms
func IsPermited(userPerms []string, permsNeeded []constants.Permission) bool {
	// Convert userPerms to a map for faster lookups
	userPermsMap := make(map[string]struct{})
	for _, perm := range userPerms {
		userPermsMap[perm] = struct{}{}
	}

	// Check if any permission in permsNeeded exists in userPerms
	for _, permNeeded := range permsNeeded {
		if _, exists := userPermsMap[string(permNeeded)]; exists {
			return true
		}
	}
	return false
}

func Get_UserId_Permissions(ctx *gin.Context) (int64, []string, error) {
	userIdStr := ctx.Request.Header.Get(constants.USER_ID)
	if userIdStr == "" {
		return 0, nil, customerrors.ERROR_UNAUTHORISED
	}

	userId, err := strconv.ParseInt(userIdStr, 10, 64)
	if err != nil {
		logger.Error(ctx, "converting header userId to int64 : %v", err.Error())
		return 0, nil, customerrors.ERROR_UNAUTHORISED
	}

	permissions := ctx.Request.Header.Get(constants.PERMISSIONS)
	if permissions != "" {
		return userId, strings.Split(permissions, ","), nil
	}
	return userId, nil, nil

}
