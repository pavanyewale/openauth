package handlers

import (
	"net/http"
	"openauth/utils/customerrors"

	"github.com/gin-gonic/gin"
)

type Response struct {
	Message *string `json:"message"`
	Error   *string `json:"error"`
}

func WriteError(ctx *gin.Context, err error) {
	errStr := "something went wrong"
	if customErr, ok := err.(*customerrors.Error); ok {
		errStr = customErr.Error()
		ctx.JSON(customErr.Code, &Response{Error: &errStr})
		return
	}
	ctx.JSON(http.StatusInternalServerError, &Response{Error: &errStr})
}

func WriteSuccess(ctx *gin.Context, message string) {
	ctx.JSON(http.StatusOK, &Response{Message: &message})
}
