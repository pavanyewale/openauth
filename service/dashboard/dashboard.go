package dashboard

import (
	"context"
	"openauth/models/dto"
	"openauth/utils/logger"
	"sync"
)

type Service struct {
	repo Repository
}

type Repository interface {
	GetTotalUserCount(ctx context.Context) (int64, error)
	GetTotalGroupCount(ctx context.Context) (int64, error)
	GetTotalPermissionCount(ctx context.Context) (int64, error)
}

func NewService(repo Repository) *Service {
	return &Service{repo: repo}
}

// GetDashboard function

func (s *Service) GetDashboard(ctx context.Context) (*dto.DashboardResponse, error) {
	wg := new(sync.WaitGroup)
	var userCount, groupCount, permissionCount int64
	wg.Add(3)
	var globalError error
	go func() {
		// Call to get user count
		count, err := s.repo.GetTotalUserCount(ctx)
		if err != nil {
			globalError = err
			logger.Error(ctx, "Error getting user count: %v", err.Error())
			return
		}
		userCount = count
		wg.Done()
	}()
	go func() {
		// Call to get group count
		count, err := s.repo.GetTotalGroupCount(ctx)
		if err != nil {
			globalError = err
			logger.Error(ctx, "Error getting group count: %v", err.Error())
			return
		}
		groupCount = count
		wg.Done()
	}()
	go func() {
		// Call to get permission count
		count, err := s.repo.GetTotalPermissionCount(ctx)
		if err != nil {
			globalError = err
			logger.Error(ctx, "Error getting permission count: %v", err.Error())
			return
		}
		permissionCount = count
		wg.Done()
	}()
	wg.Wait()
	if globalError != nil {
		return nil, globalError
	}

	return &dto.DashboardResponse{
		Dashboards: []dto.Count{{Total: userCount, Key: "Total Users", Type: "count"}, {Total: permissionCount, Key: "Total Permissions", Type: "count"}, {Key: "Total Groups", Total: groupCount, Type: "count"}},
	}, nil

}
