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
func IsPermited(userPerms []string, permsNeeded map[constants.Permission]bool) bool {
	for _, perm := range userPerms {
		if permsNeeded[constants.Permission(perm)] {
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
