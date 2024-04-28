package permissions

import (
	"context"
	"openauth/constants"
	"openauth/models/dao"
	"openauth/models/dto"
	"openauth/service/group"
	"openauth/service/history"
	"openauth/utils/customerrors"
	"time"
)

type Service struct {
	serviceFactory serviceFactory
	repo           Repository
}

func NewService(sf serviceFactory, r Repository) *Service {
	return &Service{serviceFactory: sf, repo: r}
}

type Repository interface {
	CreatePermission(ctx context.Context, permission *dao.Permission) error
	GetPermissionById(ctx context.Context, id int64) (*dao.Permission, error)
	GetPermissionByName(ctx context.Context, name string) (*dao.Permission, error)
	DeletePermissionById(ctx context.Context, id int64) error
	CreateGroupPermissions(ctx context.Context, perms []*dao.GroupPermission) error
	GetPermissionsByGroupIds(ctx context.Context, groupIds []int64) ([]*dao.Permission, error)
	CreateUserPermissions(ctx context.Context, perms []*dao.UserPermission) error
	GetPermissionsByUserId(ctx context.Context, userIds int64) ([]*dao.Permission, error)
	GetAllPermissions(ctx context.Context, limit, offset int) ([]*dao.Permission, error)
	DeleteGroupPermissions(ctx context.Context, groupId int64, permIds []int64) error
	DeleteUserPermissions(ctx context.Context, userId int64, permIds []int64) error
}

type serviceFactory interface {
	GetGroupService() *group.Service
	GetHistoryService() *history.Service
}

func (s *Service) GetPermissionsByGroupId(ctx context.Context, groupId int64) ([]*dto.PermissionDetailsShort, error) {
	perms, err := s.repo.GetPermissionsByGroupIds(ctx, []int64{groupId})
	if err != nil {
		return nil, err
	}
	shortPerms := make([]*dto.PermissionDetailsShort, len(perms))
	for i, p := range perms {
		shortPerms[i] = &dto.PermissionDetailsShort{ID: p.ID, Name: p.Name}
	}
	return shortPerms, nil
}

func (s *Service) GetPermissionsByUserId(ctx context.Context, userId int64) ([]*dto.PermissionDetailsShort, error) {
	groups, err := s.serviceFactory.GetGroupService().GetGroupsByUserId(ctx, userId)
	if err != nil {
		return nil, err
	}
	var groupIds []int64 = make([]int64, len(groups))
	for i, g := range groups {
		groupIds[i] = g.ID
	}
	groupPermissions, err := s.repo.GetPermissionsByGroupIds(ctx, groupIds)
	if err != nil {
		return nil, err
	}
	userPermissions, err := s.repo.GetPermissionsByUserId(ctx, userId)
	if err != nil {
		return nil, err
	}
	return uniqueShortPermissions(groupPermissions, userPermissions), nil
}

func (s *Service) GetAllPermissions(ctx context.Context, limit, offset int) ([]*dto.PermissionDetails, error) {
	perms, err := s.repo.GetAllPermissions(ctx, limit, offset)
	if err != nil {
		return nil, err
	}
	shortPerms := make([]*dto.PermissionDetails, len(perms))
	for i, p := range perms {
		shortPerms[i] = &dto.PermissionDetails{
			ID:          p.ID,
			Name:        p.Name,
			Category:    p.Category,
			Description: p.Description,
			CreatedBy:   p.CreatedBy,
			CreatedOn:   p.CreatedOn,
			UpdatedOn:   p.UpdatedOn,
		}
	}

	return shortPerms, nil
}

func (s *Service) CreatePermission(ctx context.Context, req *dto.CreatePermissionRequest) (*dto.PermissionDetails, error) {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_CREATE_PERMISSION, req, req.UpdatedByUser)
	perm, err := s.repo.GetPermissionByName(ctx, req.Name)
	if err != nil && err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
		return nil, err
	}
	if perm != nil {
		return nil, customerrors.BAD_REQUEST_ERROR("permission already exists")
	}
	perm = new(dao.Permission)
	perm.Name = req.Name
	perm.Category = req.Category
	perm.Description = req.Description
	perm.CreatedBy = req.UpdatedByUser
	perm.CreatedOn = time.Now().UnixMilli()
	perm.UpdatedOn = time.Now().UnixMilli()
	err = s.repo.CreatePermission(ctx, perm)
	if err != nil {
		return nil, err
	}
	return (&dto.PermissionDetails{}).FromPermission(perm), nil
}

func (s *Service) GetPermissionDetails(ctx context.Context, id int64) (*dto.PermissionDetails, error) {
	permission, err := s.repo.GetPermissionById(ctx, id)
	if err != nil {
		return nil, err
	}
	return (&dto.PermissionDetails{}).FromPermission(permission), nil
}

func (s *Service) AddPermissionsToUser(ctx context.Context, req *dto.AddRemovePermissionsToUserRequest) error {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_ADD_PERMISSIONS_TO_USER, req, req.UpdatedbyUserId)

	var perms []*dao.UserPermission
	for _, permId := range req.PermissionIDs {
		var userPerm dao.UserPermission
		userPerm.UserId = req.UserId
		userPerm.PermissionId = permId
		userPerm.CreatedByUser = req.UpdatedbyUserId
		userPerm.CreatedOn = time.Now().UnixMilli()
		userPerm.UpdatedOn = time.Now().UnixMilli()
		perms = append(perms, &userPerm)
	}
	return s.repo.CreateUserPermissions(ctx, perms)
}

func (s *Service) RemovePermissionsOfUser(ctx context.Context, req *dto.AddRemovePermissionsToUserRequest) error {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_REMOVE_PERMISSIONS_OF_USER, req, req.UpdatedbyUserId)

	return s.repo.DeleteUserPermissions(ctx, req.UserId, req.PermissionIDs)
}

func (s *Service) DeletePermissionById(ctx context.Context, req *dto.DeletePermissionRequest) error {
	perm, err := s.repo.GetPermissionById(ctx, req.PermissionId)
	if err != nil {
		if err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
			return customerrors.BAD_REQUEST_ERROR("invalid permission id")
		}
		return err
	}
	if perm.Category == "default" {
		return customerrors.BAD_REQUEST_ERROR("default permission cannot be deleted")
	}
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_DELETE_PERMISSION, req, req.UpdatedByUser)

	return s.repo.DeletePermissionById(ctx, req.PermissionId)
}

func (s *Service) AddPermissionsToGroup(ctx context.Context, req *dto.AddRemovePermissionsToGroupRequest) error {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_ADD_PERMISSIONS_TO_GROUP, req, req.UpdatedbyUserId)

	var perms []*dao.GroupPermission
	for _, permId := range req.PermissionIDs {
		var groupPerm dao.GroupPermission
		groupPerm.GroupID = req.GroupId
		groupPerm.PermissionID = permId
		groupPerm.CreatedByUser = req.UpdatedbyUserId
		groupPerm.CreatedOn = time.Now().UnixMilli()
		groupPerm.UpdatedOn = time.Now().UnixMilli()
		perms = append(perms, &groupPerm)
	}
	return s.repo.CreateGroupPermissions(ctx, perms)
}

func (s *Service) RemovePermissionsOfGroup(ctx context.Context, req *dto.AddRemovePermissionsToGroupRequest) error {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_REMOVE_PERMISSIONS_OF_GROUP, req, req.UpdatedbyUserId)

	return s.repo.DeleteGroupPermissions(ctx, req.GroupId, req.PermissionIDs)
}
