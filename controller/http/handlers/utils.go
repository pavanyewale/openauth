package handlers

import (
	"net/http"
	"openauth/utils/customerrors"

	"github.com/gin-gonic/gin"
)

type Response struct {
	Message *string `json:"message,omitempty"`
	Error   *string `json:"error,omitempty"`
	Code    int     `json:"code"`
	Data    any     `json:"data,omitempty"`
}

func WriteError(ctx *gin.Context, err error) {
	errStr := "something went wrong"
	if customErr, ok := err.(*customerrors.Error); ok {
		errStr = customErr.Error()
		ctx.JSON(customErr.Code, &Response{Error: &errStr, Code: customErr.Code})
		return
	}
	ctx.JSON(http.StatusInternalServerError, &Response{Error: &errStr, Code: http.StatusInternalServerError})
}

func WriteSuccess(ctx *gin.Context, data any) {
	if msg, ok := data.(string); ok {
		ctx.JSON(http.StatusOK, &Response{Message: &msg, Code: http.StatusOK})
		return
	}
	ctx.JSON(http.StatusOK, &Response{Data: data, Code: http.StatusOK})
}
