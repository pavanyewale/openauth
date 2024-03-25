package group

import (
	"context"
	"openauth/constants"
	"openauth/models/dao"
	"openauth/models/dto"
	"openauth/service/history"
	"openauth/utils/customerrors"
	"time"
)

type Repository interface {
	CreateGroup(ctx context.Context, group *dao.Group) error
	DeleteGroupById(ctx context.Context, id int64) error
	GetGroupById(ctx context.Context, id int64) (*dao.Group, error)
	GetAllGroups(ctx context.Context, limit, offset int) ([]*dao.Group, error)
	GetGroupsByUserId(ctx context.Context, userId int64) ([]*dao.Group, error)
	CreateUserGroups(ctx context.Context, userGroups []*dao.UserGroup) error
	DeleteUsersFromGroup(ctx context.Context, groupId int64, userIds []int64) error
}

type serviceFactory interface {
	GetHistoryService() *history.Service
}

type Service struct {
	serviceFactory serviceFactory
	repo           Repository
}

func NewService(sf serviceFactory, repo Repository) *Service {
	return &Service{serviceFactory: sf, repo: repo}
}

func (s *Service) CreateGroup(ctx context.Context, req *dto.CreateGroupRequest) (*dto.GroupDetails, error) {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_CREATE_GROUP, req, req.UpdatedbyUserId)

	var group dao.Group
	group.Name = req.Name
	group.Description = req.Description
	group.CreatedByUser = req.UpdatedbyUserId
	group.CreatedOn = time.Now().UnixMilli()
	group.UpdatedOn = time.Now().UnixMilli()
	err := s.repo.CreateGroup(ctx, &group)
	if err != nil {
		if err == customerrors.ERROR_DATABASE_UNIQUE_KEY {
			return nil, customerrors.BAD_REQUEST_ERROR("group already exists with given name.")
		}
		return nil, err
	}
	return (&dto.GroupDetails{}).FromGroup(&group), nil
}

func (s *Service) GetGroupDetails(ctx context.Context, groupId int64) (*dto.GroupDetails, error) {
	group, err := s.repo.GetGroupById(ctx, groupId)
	if err != nil {
		return nil, err
	}
	return (&dto.GroupDetails{}).FromGroup(group), nil
}

func (s *Service) DeleteGroup(ctx context.Context, req *dto.DeleteGroupRequest) error {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_DELETE_GROUP, req, req.UpdatedbyUserId)

	return s.repo.DeleteGroupById(ctx, req.GroupId)
}

func (s *Service) GetGroupsByUserId(ctx context.Context, userId int64) ([]*dto.GroupDetailsShort, error) {
	groups, err := s.repo.GetGroupsByUserId(ctx, userId)
	if err != nil {
		return nil, err
	}
	var userGroups []*dto.GroupDetailsShort = make([]*dto.GroupDetailsShort, len(groups))
	for i, group := range groups {
		userGroups[i] = &dto.GroupDetailsShort{
			ID:   group.ID,
			Name: group.Name,
		}
	}
	return userGroups, nil
}

func (s *Service) GetAllGroups(ctx context.Context, limit, offset int) ([]*dto.GroupDetailsShort, error) {
	groups, err := s.repo.GetAllGroups(ctx, limit, offset)
	if err != nil {
		return nil, err
	}
	var shortGroups []*dto.GroupDetailsShort
	for _, g := range groups {
		shortGroups = append(shortGroups, &dto.GroupDetailsShort{ID: g.ID, Name: g.Name})
	}
	return shortGroups, nil
}

func (s *Service) AddUsersToGroup(ctx context.Context, req *dto.AddRemoveUsersToGroupRequest) error {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_ADD_USER_TO_GROUP, req, req.UpdatedByUserId)

	var userGroups []*dao.UserGroup
	for _, userId := range req.UserIds {
		userGroups = append(userGroups, &dao.UserGroup{
			UserId:        userId,
			GroupId:       req.GroupId,
			CreatedByUser: req.UpdatedByUserId,
			CreatedOn:     time.Now().UnixMilli(),
			UpdatedOn:     time.Now().UnixMilli(),
		})
	}
	return s.repo.CreateUserGroups(ctx, userGroups)
}

func (s *Service) RemoveUsersFromGroup(ctx context.Context, req *dto.AddRemoveUsersToGroupRequest) error {
	go s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.OPERATION_REMOVE_USER_FROM_GROUP, req, req.UpdatedByUserId)

	return s.repo.DeleteUsersFromGroup(ctx, req.GroupId, req.UserIds)
}
