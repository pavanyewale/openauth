package handlers

import (
	"context"
	"openauth/constants"
	"openauth/models/dto"
	"openauth/models/filters"
	"openauth/utils"
	"openauth/utils/customerrors"
	"strconv"

	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	service service
}

type service interface {
	GetUserDetailsById(ctx context.Context, id int64) (*dto.UserDetails, error)
	GetUsersByFilter(ctx context.Context, filter *filters.UserFilter, limit, offset int) ([]*dto.UserDetails, error)
	DeleteUserById(ctx context.Context, id int64, deletedByUserId int64) error
	CreateUpdateUser(ctx context.Context, user *dto.CreateUpdateUserRequest, updatedByUserId int64) error
	VerifyAvailability(ctx context.Context, details *dto.VerifyAvailabilityRequest) (*dto.VerifyAvailabilityResponse, error)
}

func NewUserHandler(service service) *UserHandler {
	return &UserHandler{service: service}
}

func (ph *UserHandler) Register(router gin.IRouter) {
	router.GET("/openauth/user/:id", ph.GetUserDetailsById)
	router.GET("/openauth/user", ph.GetUsersByFilter)
	router.DELETE("/openauth/user/:id", ph.DeleteUserById)
	router.POST("/openauth/user", ph.CreateUpdateUser)
	router.PUT("/openauth/user/verify", ph.VerifyAvailability)
}

// GetUserDetailsById godoc
// @Summary Get user details by id
// @Description Get user details by id
// @ID get-user-details-by-id
// @Tags user
// @Accept  json
// @Produce  json
// @Param id path int true "User ID"
// @Success 200 {object} dto.UserDetails
// @Router /openauth/user/{id} [get]
func (ph *UserHandler) GetUserDetailsById(c *gin.Context) {
	id := c.Param("id")
	ctx := c.Request.Context()
	userID, err := strconv.ParseInt(id, 10, 64)
	if err != nil {
		WriteError(c, customerrors.BAD_REQUEST_ERROR("invalid user id"))
		return
	}
	user, err := ph.service.GetUserDetailsById(ctx, userID)
	if err != nil {
		WriteError(c, err)
		return
	}
	WriteSuccess(c, user)
}

// GetUsersByFilter godoc
// @Summary Get users by filter
// @Description Get users by filter
// @ID get-users-by-filter
// @Tags user
// @Accept  json
// @Produce  json
// @Param userId query int false "User ID"
// @Param username query string false "Username"
// @Param email query string false "Email"
// @Param mobile query string false "Mobile"
// @Param limit query int false "Limit"
// @Param offset query int false "Offset"
// @Success 200 {array} dto.UserDetails
// @Router /openauth/user [get]
func (ph *UserHandler) GetUsersByFilter(c *gin.Context) {
	filter := &filters.UserFilter{}
	if id, err := strconv.ParseInt(c.Query("userId"), 10, 64); err == nil {
		filter.UserId = id
	}
	if username := c.Query("username"); username != "" {
		filter.Username = username
	}
	if email := c.Query("email"); email != "" {
		filter.Email = email
	}
	if mobile := c.Query("mobile"); mobile != "" {
		filter.Mobile = mobile
	}
	limit, err := strconv.Atoi(c.Query("limit"))
	if err != nil || limit == 0 || limit > 100 {
		limit = 10
	}

	offset, err := strconv.Atoi(c.Query("offset"))
	if err != nil || offset < 0 {
		offset = 0
	}

	users, err := ph.service.GetUsersByFilter(c, filter, limit, offset)
	if err != nil {
		WriteError(c, err)
		return
	}
	WriteSuccess(c, users)
}

// DeleteUserById godoc
// @Summary Delete user by id
// @Description Delete user by id
// @ID delete-user-by-id
// @Tags user
// @Accept  json
// @Produce  json
// @Param id path int true "User ID"
// @Success 200 {object} Response
// @Router /openauth/user/{id} [delete]
func (ph *UserHandler) DeleteUserById(ctx *gin.Context) {
	id := ctx.Param("id")
	userID, err := strconv.ParseInt(id, 10, 64)
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid user id"))
		return
	}
	deletedByUserId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	// Check if the user has permission to delete user
	//validating permissions
	permitted := utils.IsPermited(permissions, constants.DELETE_USER_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	err = ph.service.DeleteUserById(ctx, userID, deletedByUserId)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, "User deleted successfully")
}

// CreateUpdateUser godoc
// @Summary Create/Update user
// @Description Create/Update user
// @ID create-update-user
// @Tags user
// @Accept  json
// @Produce  json
// @Param user body dto.CreateUpdateUserRequest true "User Details"
// @Success 200 {object} dto.UserDetails
// @Router /openauth/user [post]
func (ph *UserHandler) CreateUpdateUser(ctx *gin.Context) {
	var user dto.CreateUpdateUserRequest
	if err := ctx.ShouldBindJSON(&user); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid user details"))
		return
	}
	var updatedByUserId int64
	if user.ID != 0 {
		updatedByUserId, permissions, err := utils.Get_UserId_Permissions(ctx)
		if err != nil {
			WriteError(ctx, err)
			return
		}

		if user.ID != updatedByUserId {

			permitted := utils.IsPermited(permissions, constants.EDIT_USER_PERMISSIONS)
			if !permitted {
				WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
				return
			}
		}
	}

	err := ph.service.CreateUpdateUser(ctx, &user, updatedByUserId)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, user)
}

// VerifyAvailability godoc
// @Summary Verify availability of username, email, mobile
// @Description Verify availability of username, email, mobile
// @ID verify-availability
// @Tags user
// @Accept  json
// @Produce  json
// @Param details body dto.VerifyAvailabilityRequest true "Details"
// @Success 200 {object} dto.VerifyAvailabilityResponse
// @Router /openauth/user/verify [put]
func (ph *UserHandler) VerifyAvailability(ctx *gin.Context) {
	var details dto.VerifyAvailabilityRequest
	if err := ctx.ShouldBindJSON(&details); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body details"))
		return
	}
	response, err := ph.service.VerifyAvailability(ctx, &details)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, response)
}
