package handlers

import (
	"context"
	"net/http"
	"openauth/constants"
	"openauth/models/dto"
	"openauth/utils"
	"openauth/utils/customerrors"
	"strconv"

	"github.com/gin-gonic/gin"
)

type GroupService interface {
	CreateGroup(ctx context.Context, req *dto.CreateGroupRequest) (*dto.GroupDetails, error)
	GetGroupDetails(ctx context.Context, groupId int64) (*dto.GroupDetails, error)
	DeleteGroup(ctx context.Context, req *dto.DeleteGroupRequest) error
	GetGroupsByUserId(ctx context.Context, userId int64) ([]*dto.GroupDetailsShort, error)
	AddUsersToGroup(ctx context.Context, req *dto.AddRemoveUsersToGroupRequest) error
	RemoveUsersFromGroup(ctx context.Context, req *dto.AddRemoveUsersToGroupRequest) error
	GetAllGroups(ctx context.Context, limit, offset int) ([]*dto.GroupDetailsShort, error)
}

type GroupHandler struct {
	groupService GroupService
}

func NewGroupHandler(groupService GroupService) *GroupHandler {
	return &GroupHandler{groupService: groupService}
}

func (lh *GroupHandler) Register(router gin.IRouter) {
	router.POST("/openauth/group", lh.CreateGroup)
	router.DELETE("/openauth/group", lh.DeleteGroup)
	router.GET("/openauth/group/:id", lh.GetGroupDetails)
	router.GET("/openauth/group", lh.GetAllGroups)
	router.POST("/openauth/group/user", lh.AddUsersToGroup)
	router.GET("/openauth/group/user", lh.GetGroupsByUserId)
	router.DELETE("/openauth/group/user", lh.RemoveUserFromGroups)
}

// @Summary Create a new group
// @Description Create a new group with the specified details
// @Tags Groups
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Param group body dto.CreateGroupRequest true "Group details"
// @Success 201 {object} dao.Group
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/group [post]
func (lh *GroupHandler) CreateGroup(ctx *gin.Context) {

	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	//validating permissions
	permitted := utils.IsPermited(permissions, constants.EDIT_GROUP_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	var req dto.CreateGroupRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}

	err = req.Validate()
	if err != nil {
		WriteError(ctx, err)
		return
	}
	req.UpdatedbyUserId = userId

	group, err := lh.groupService.CreateGroup(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	ctx.JSON(http.StatusCreated, group)
}

// @Summary Delete a group
// @Description Delete a group by providing the group ID
// @Tags Groups
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Param group body dto.DeleteGroupRequest true "Group details"
// @Success 200 {object} Response
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/group [delete]
func (lh *GroupHandler) DeleteGroup(ctx *gin.Context) {
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	permitted := utils.IsPermited(permissions, constants.DELETE_GROUP_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	var req dto.DeleteGroupRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}
	err = req.Validate()
	if err != nil {
		WriteError(ctx, err)
		return
	}
	req.UpdatedbyUserId = userId

	err = lh.groupService.DeleteGroup(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, "Group deleted successfully")
}

// @Summary Get group details
// @Description Get details of a group by providing the group ID
// @Tags Groups
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Param id path int64 true "Group ID"
// @Success 200 {object} dao.Group
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 404 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/group/{id} [get]
func (lh *GroupHandler) GetGroupDetails(ctx *gin.Context) {

	groupID, err := strconv.ParseInt(ctx.Param("id"), 10, 64)
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid group ID"))
		return
	}

	group, err := lh.groupService.GetGroupDetails(ctx, groupID)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	ctx.JSON(http.StatusOK, group)
}

// @Summary Add users to a group
// @Description Add users to a group by providing the group ID and user IDs
// @Tags Groups
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Param group body dto.AddRemoveUsersToGroupRequest true "Add users to group details"
// @Success 200 {object} Response
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/group/user [post]
func (lh *GroupHandler) AddUsersToGroup(ctx *gin.Context) {
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	permitted := utils.IsPermited(permissions, constants.EDIT_GROUP_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	var req dto.AddRemoveUsersToGroupRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}
	err = req.Validate()
	if err != nil {
		WriteError(ctx, err)
		return
	}
	req.UpdatedByUserId = userId

	err = lh.groupService.AddUsersToGroup(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	WriteSuccess(ctx, "Users added to group successfully")
}

// @Summary Remove users from a group
// @Description Remove users from a group by providing the groupID and userIDs
// @Tags Groups
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Param group body dto.AddRemoveUsersToGroupRequest true "Remove users from group details"
// @Success 200 {object} Response
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/group/user [delete]
func (lh *GroupHandler) RemoveUserFromGroups(ctx *gin.Context) {
	userId, permissions, err := utils.Get_UserId_Permissions(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	permitted := utils.IsPermited(permissions, constants.EDIT_GROUP_PERMISSIONS)
	if !permitted {
		WriteError(ctx, customerrors.ERROR_PERMISSION_DENIED)
		return
	}

	var req dto.AddRemoveUsersToGroupRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid body"))
		return
	}
	err = req.Validate()
	if err != nil {
		WriteError(ctx, err)
		return
	}
	req.UpdatedByUserId = userId

	err = lh.groupService.RemoveUsersFromGroup(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	WriteSuccess(ctx, "Users removed from group successfully")
}

// @Summary Get groups by user ID
// @Description Get groups associated with a user by providing the user ID
// @Tags Groups
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Param userId query int64 true "User ID"
// @Success 200 {array} dto.GroupDetailsShort
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/group/user [get]
func (lh *GroupHandler) GetGroupsByUserId(ctx *gin.Context) {
	userId, err := strconv.ParseInt(ctx.Query("userId"), 10, 64)
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid userId"))
		return
	}
	groups, err := lh.groupService.GetGroupsByUserId(ctx, userId)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	ctx.JSON(http.StatusOK, groups)
}

// @Summary Get all groups
// @Description Get a list of all groups with optional limit and offset parameters
// @Tags Groups
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Param limit query int64 false "Limit (default 50)"
// @Param offset query int64 false "Offset (default 0)"
// @Success 200 {array} dto.GroupDetails
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/group [get]
func (lh *GroupHandler) GetAllGroups(ctx *gin.Context) {

	// Extract limit and offset from query parameters
	limit, err := strconv.Atoi(ctx.Query("limit"))
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid limit"))
		return
	}

	//setting max limit to 50
	if limit > 50 {
		limit = 50
	}

	offset, err := strconv.Atoi(ctx.Query("offset"))
	if err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR("invalid offset"))
		return
	}

	if offset < 0 {
		offset = 0
	}

	groups, err := lh.groupService.GetAllGroups(ctx, limit, offset)
	if err != nil {
		WriteError(ctx, err)
		return
	}

	ctx.JSON(http.StatusOK, groups)
}
