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

type PermissionService interface {
	CreatePermission(ctx context.Context, req *dto.CreatePermissionRequest) (*dto.PermissionDetails, error)
	GetPermissionDetails(ctx context.Context, id int64) (*dto.PermissionDetails, error)
	GetAllPermissions(ctx context.Context, filter *filters.PermissionFilter, limit, offset int) ([]*dto.PermissionDetails, error)
	DeletePermissionById(ctx context.Context, req *dto.DeletePermissionRequest) error
	AddPermissionsToUser(ctx context.Context, req *dto.AddRemovePermissionsToUserRequest) error
	GetPermissionsByUserId(ctx context.Context, userId int64) ([]*dto.PermissionDetailsShort, error)
	RemovePermissionsOfUser(ctx context.Context, req *dto.AddRemovePermissionsToUserRequest) error
	AddPermissionsToGroup(ctx context.Context, req *dto.AddRemovePermissionsToGroupRequest) error
	RemovePermissionsOfGroup(ctx context.Context, req *dto.AddRemovePermissionsToGroupRequest) error
	GetPermissionsByGroupId(ctx context.Context, groupId int64) ([]*dto.PermissionDetails, error)
}

type PermissionsHandler struct {
	permissionService PermissionService
}

func NewPermissionHandler(permService PermissionService) *PermissionsHandler {
	return &PermissionsHandler{permissionService: permService}
}

func (ph *PermissionsHandler) Register(router gin.IRouter) {
	router.POST("/openauth/permissions", ph.CreatePermission)
	router.GET("/openauth/permissions", ph.GetAllPermissions)
	router.GET("/openauth/permissions/:id", ph.GetPermissionDetails)
	router.DELETE("/openauth/permissions", ph.DeletePermissionById)
	router.POST("/openauth/permissions/user/", ph.AddPermissionsToUser)
	router.GET("/openauth/permissions/user/", ph.GetPermissionsByUserId)
	router.DELETE("/openauth/permissions/user/", ph.RemovePermissionsOfUser)
	router.POST("/openauth/permissions/group/", ph.AddPermissionsToGroup)
	router.GET("/openauth/permissions/group/", ph.GetPermissionsByGroupId)
	router.DELETE("/openauth/permissions/group/", ph.RemovePermissionsOfGroup)
}

// @Summary Create a new permission
// @Description Create a new permission with the provided details
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param permission body dto.CreatePermissionRequest true "Permission details"
// @Success 201 {object} dto.PermissionDetails
// @Router /openauth/permissions [post]
func (ph *PermissionsHandler) CreatePermission(ctx *gin.Context) {
	// Get user ID and permissions from the context
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Validate user permissions for creating a permission
	permitted := utils.IsPermited(permissions, constants.EDIT_PERMISSIONS_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	// Bind request JSON to dto.CreateDeletePermissionRequest
	var req dto.CreatePermissionRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}

	err = req.Validate()
	if err != nil {
		WriteError(ctx, err)
		return
	}
	// Populate the UpdatedByUser field from the user ID obtained from the context
	req.UpdatedByUser = userId

	// Call the permission service to create the permission
	permission, err := ph.permissionService.CreatePermission(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return the created permission in the response
	WriteSuccess(ctx, permission)
}

// @Summary Get details of a permission
// @Description Get details of a permission by its ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param id path int64 true "Permission ID"
// @Success 200 {object} dto.PermissionDetails
// @Router /openauth/permissions/{id} [get]
func (ph *PermissionsHandler) GetPermissionDetails(ctx *gin.Context) {
	// Get permission ID from the request URL
	permissionID, err := strconv.ParseInt(ctx.Param("id"), 10, 64)
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid permission ID"))
		return
	}

	// Call the permission service to get permission details by ID
	permissionDetails, err := ph.permissionService.GetPermissionDetails(ctx, permissionID)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return the permission details in the response
	WriteSuccess(ctx, permissionDetails)
}

// @Summary Delete a permission
// @Description Delete a permission by its ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param permission body dto.DeletePermissionRequest true "Permission details"
// @Success 200 "Permission deleted successfully"
// @Router /openauth/permissions [delete]
func (ph *PermissionsHandler) DeletePermissionById(ctx *gin.Context) {
	// Get user ID and permissions from the context
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Validate user permissions for deleting a permission
	permitted := utils.IsPermited(permissions, constants.DELETE_PERMISSIONS_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	// Bind request JSON to dto.CreateDeletePermissionRequest
	var req dto.DeletePermissionRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}

	if err = req.Validate(); err != nil {
		WriteError(ctx, err)
		return
	}

	// Populate the UpdatedByUser field from the user ID obtained from the context
	req.UpdatedByUser = userId

	// Call the permission service to delete the permission by ID
	err = ph.permissionService.DeletePermissionById(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return success message in the response
	WriteSuccess(ctx, "Permission deleted successfully")
}

// @Summary Add permissions to a user
// @Description Add permissions to a user by user ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param permissions body dto.AddRemovePermissionsToUserRequest true "Permissions details"
// @Success 200 "Permissions added to user successfully"
// @Router /openauth/permissions/users [post]
func (ph *PermissionsHandler) AddPermissionsToUser(ctx *gin.Context) {
	// Get user ID and permissions from the context
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Validate user permissions for adding permissions to a user
	permitted := utils.IsPermited(permissions, constants.EDIT_USER_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	// Bind request JSON to dto.AddRemovePermissionsToUserRequest
	var req dto.AddRemovePermissionsToUserRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}

	if err = req.Validate(); err != nil {
		WriteError(ctx, err)
		return
	}

	// Populate the UpdatedByUser field from the user ID obtained from the context
	req.UpdatedbyUserId = userId

	// Call the permission service to add permissions to the user
	err = ph.permissionService.AddPermissionsToUser(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return success message in the response
	WriteSuccess(ctx, "Permissions added to user successfully")
}

// @Summary Get permissions of a user
// @Description Get permissions of a user by user ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param userId query int64 true "User ID"
// @Success 200 {array} dto.PermissionDetailsShort
// @Router /openauth/permissions/users [get]
func (ph *PermissionsHandler) GetPermissionsByUserId(ctx *gin.Context) {

	// Parse user ID from the query parameters
	userIdParam := ctx.Query("userId")
	if userIdParam == "" {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("userId parameter is required"))
		return
	}

	userId, err := strconv.ParseInt(userIdParam, 10, 64)
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid userId"))
		return
	}

	// Call the permission service to get permissions by user ID
	perms, err := ph.permissionService.GetPermissionsByUserId(ctx, userId)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return the permissions in the response
	WriteSuccess(ctx, perms)
}

// @Summary Remove permissions from a user
// @Description Remove permissions from a user by user ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param permissions body dto.AddRemovePermissionsToUserRequest true "Permissions details"
// @Success 200 "Permissions removed from user successfully"
// @Router /openauth/permissions/users [delete]
func (ph *PermissionsHandler) RemovePermissionsOfUser(ctx *gin.Context) {
	// Get user ID and permissions from the context
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Validate user permissions for removing permissions from a user
	permitted := utils.IsPermited(permissions, constants.EDIT_USER_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	// Bind request JSON to dto.RemovePermissionsFromUserRequest
	var req dto.AddRemovePermissionsToUserRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}

	if err = req.Validate(); err != nil {
		WriteError(ctx, err)
		return
	}

	// Populate the UpdatedByUser field from the user ID obtained from the context
	req.UpdatedbyUserId = userId

	// Call the permission service to remove permissions from a user
	err = ph.permissionService.RemovePermissionsOfUser(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return success in the response
	WriteSuccess(ctx, "Permissions removed from user successfully")
}

// @Summary Add permissions to a group
// @Description Add permissions to a group by group ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param permissions body dto.AddRemovePermissionsToGroupRequest true "Permissions details"
// @Success 200 "Permissions added to group successfully"
// @Router /openauth/permissions/group/ [post]
func (ph *PermissionsHandler) AddPermissionsToGroup(ctx *gin.Context) {
	// Get user ID and permissions from the context
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Validate user permissions for adding permissions to a group
	permitted := utils.IsPermited(permissions, constants.EDIT_GROUP_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	// Bind request JSON to dto.AddPermissionsToGroupRequest
	var req dto.AddRemovePermissionsToGroupRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}

	if err = req.Validate(); err != nil {
		WriteError(ctx, err)
		return
	}

	// Populate the UpdatedByUser field from the user ID obtained from the context
	req.UpdatedbyUserId = userId

	// Call the permission service to add permissions to a group
	err = ph.permissionService.AddPermissionsToGroup(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return success in the response
	WriteSuccess(ctx, "Permissions added to group successfully")
}

// @Summary Get permissions of a group
// @Description Get permissions of a group by group ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param groupId query int64 true "Group ID"
// @Success 200 {array} dto.PermissionDetails
// @Router /openauth/permissions/group/ [get]
func (ph *PermissionsHandler) GetPermissionsByGroupId(ctx *gin.Context) {
	// Parse user ID from the query parameters
	groupIdParam := ctx.Query("groupId")
	if groupIdParam == "" {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("groupId parameter is required"))
		return
	}

	// Parse group ID from the URL parameter
	groupID, err := strconv.ParseInt(groupIdParam, 10, 64)
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid group ID"))
		return
	}

	// Call the permission service to get permissions by group ID
	perms, err := ph.permissionService.GetPermissionsByGroupId(ctx, groupID)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return the permissions in the response
	WriteSuccess(ctx, perms)
}

// @Summary Remove permissions from a group
// @Description Remove permissions from a group by group ID
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param permissions body dto.AddRemovePermissionsToGroupRequest true "Permissions details"
// @Success 200 "Permissions removed from group successfully"
// @Router /openauth/permissions/group/ [delete]
func (ph *PermissionsHandler) RemovePermissionsOfGroup(ctx *gin.Context) {
	// Get user ID and permissions from the context
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Validate user permissions for removing permissions from a group
	permitted := utils.IsPermited(permissions, constants.EDIT_GROUP_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	// Bind request JSON to dto.RemovePermissionsFromGroupRequest
	var req dto.AddRemovePermissionsToGroupRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}

	err = req.Validate()
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Populate the UpdatedByUser field from the user ID obtained from the context
	req.UpdatedbyUserId = userId

	// Call the permission service to remove permissions from a group
	err = ph.permissionService.RemovePermissionsOfGroup(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return success message in the response
	WriteSuccess(ctx, "Permissions removed from group successfully")
}

// @Summary Get all permissions
// @Description Get a list of all permissions
// @Tags Permissions
// @Accept json
// @Produce json
// @Param AuthToken header string true "JWT Token"
// @Param limit query integer false "Limit the number of results (default 10)"
// @Param offset query integer false "Offset for pagination (default 0)"
// @Success 200 object dto.GetPermissionsResponse
// @Router /openauth/permissions [get]
func (ph *PermissionsHandler) GetAllPermissions(ctx *gin.Context) {
	var filter filters.PermissionFilter
	// Get limit and offset parameters from the query
	limit, err := strconv.Atoi(ctx.DefaultQuery("limit", "50"))
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid limit parameter"))
		return
	}

	offset, err := strconv.Atoi(ctx.DefaultQuery("offset", "0"))
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid offset parameter"))
		return
	}

	filter.Category = ctx.Query("category")
	filter.Name = ctx.Query("name")

	// Call the permission service to get all permissions with pagination
	allPermissions, err := ph.permissionService.GetAllPermissions(ctx, &filter, limit, offset)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	// Return the permissions in the response
	WriteSuccess(ctx, &dto.GetPermissionsResponse{Permissions: allPermissions})
}
