package handlers

import (
	"context"
	"fmt"
	"openauth/constants"
	"openauth/models/dto"
	"openauth/utils/customerrors"

	"github.com/gin-gonic/gin"
)

type LoginHandler struct {
	service AuthService
}

type AuthService interface {
	Login(ctx context.Context, req *dto.LoginRequest) (*dto.LoginResponse, error)
	Authenticate(ctx context.Context, req *dto.AuthRequest) (*dto.AuthenticationResponse, error)
	RefreshToken(ctx context.Context, token string) (*dto.RefreshTokenResponse, error)
	Logout(ctx context.Context, token string) error
}

func NewLoginHandler(service AuthService) *LoginHandler {
	return &LoginHandler{service: service}
}

func (lh *LoginHandler) Register(router gin.IRouter) {
	router.POST("/openauth/login", lh.login)
	router.PUT("/openauth/logout", lh.logout)
	router.GET("/openauth/authenticate", lh.authenticate)
	router.PUT("/openauth/authenticate/refresh", lh.authRefresh)
	router.PUT("/openauth/authenticate/resetpassword", lh.resetPassword)
}

// @Summary User Login
// @Description Log in a user with username, password, OTP, and device details (username can be mobile,email or username).
// @Tags Login
// @Accept json
// @Produce json
// @Param request body dto.LoginRequest true "Login Request"
// @Success 200 {object} dto.LoginResponse
// @Failure 400 {object} Response
// @Failure 402 {object} Response
// @Router /openauth/login [post]
func (lh *LoginHandler) login(ctx *gin.Context) {
	var req dto.LoginRequest
	if err := ctx.BindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}
	res, err := lh.service.Login(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, res)
}

// logout godoc
// @Summary marks the session as logged out
// @Description marks the session as logged out.
// @Tags Login
// @ID logout
// @Accept  json
// @Produce  json
// @Param AuthToken header string true "Authentication Token"
// @Success 200 {object} dto.RefreshTokenResponse
// @Failure 400 {object} Response
// @Router /openauth/logout [put]
func (lh *LoginHandler) logout(ctx *gin.Context) {
	token := ctx.Request.Header.Get(constants.AUTH_TOKEN)
	if token == "" {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR(fmt.Sprintf("%s missing in header", constants.AUTH_TOKEN)))
	}
	err := lh.service.Logout(ctx, token)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, "logged out successfully")
}

// authenticate godoc
// @Summary validates the auth token and returns user details
// @Description validates the auth token and returns the user details
// @Tags Authentication
// @ID authenticate
// @Accept  json
// @Produce  json
// @Param permissions query boolean false "User permissions to be added in token"
// @Param AuthToken header string true "Authentication Token"
// @Success 200 {object} dto.AuthenticationResponse
// @Failure 400 {object} Response
// @Router /openauth/authenticate [get]
func (lh *LoginHandler) authenticate(ctx *gin.Context) {
	token := ctx.Request.Header.Get(constants.AUTH_TOKEN)
	if token == "" {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR(fmt.Sprintf("%s missing in header", constants.AUTH_TOKEN)))
	}
	var req dto.AuthRequest
	req.Permissions = ctx.Query("permissions") == "true"
	req.Token = token
	res, err := lh.service.Authenticate(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, res)
}

// authRefresh godoc
// @Summary Refresh authentication token
// @Description Refreshes the authentication token.
// @Tags Authentication
// @ID refreshAuthToken
// @Accept  json
// @Produce  json
// @Param AuthToken header string true "Authentication Token"
// @Success 200 {object} dto.RefreshTokenResponse
// @Failure 400 {object} Response
// @Router /openauth/authenticate/refresh [put]
func (lh *LoginHandler) authRefresh(ctx *gin.Context) {
	token := ctx.Request.Header.Get(constants.AUTH_TOKEN)
	if token == "" {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR(fmt.Sprintf("%s missing in header", constants.AUTH_TOKEN)))
	}
	res, err := lh.service.RefreshToken(ctx, token)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, res)
}

func (lh *LoginHandler) resetPassword(ctx *gin.Context) {
	//todo
}
