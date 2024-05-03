package service

import (
	"context"
	"openauth/service/authentication"
	"openauth/service/dashboard"
	"openauth/service/group"
	"openauth/service/history"
	"openauth/service/otp"
	"openauth/service/permissions"
	"openauth/service/ping"
	"openauth/service/user"
)

type ServiceFactory struct {
	pingService       *ping.Service
	otpService        *otp.Service
	permissionService *permissions.Service
	groupService      *group.Service
	authService       *authentication.Service
	historyService    *history.Service
	userService       *user.Service
	dashboardService  *dashboard.Service
}

func (s *ServiceFactory) GetOTPService() *otp.Service {
	return s.otpService
}

func (s *ServiceFactory) GetAuthService() *authentication.Service {
	return s.authService
}

func (s *ServiceFactory) GetPingService() *ping.Service {
	return s.pingService
}

func (s *ServiceFactory) GetPermissionService() *permissions.Service {
	return s.permissionService
}

func (s *ServiceFactory) GetGroupService() *group.Service {
	return s.groupService
}

func (s *ServiceFactory) GetHistoryService() *history.Service {
	return s.historyService
}

func (s *ServiceFactory) GetUserService() *user.Service {
	return s.userService
}

func (s *ServiceFactory) GetDashboardService() *dashboard.Service {
	return s.dashboardService
}

type Config struct {
	OTP  otp.Config
	Auth authentication.Config
}

type Repository interface {
	ping.Repository
	history.Reposiory
	otp.Repository
	group.Repository
	permissions.Repository
	authentication.Repository
	user.Repository
	dashboard.Repository
}

func NewServiceFactory(ctx context.Context, conf *Config, repo Repository) *ServiceFactory {
	serviceFactory := new(ServiceFactory)
	serviceFactory.pingService = ping.NewService(ctx, repo)
	serviceFactory.historyService = history.NewService(repo)
	serviceFactory.otpService = otp.NewService(&conf.OTP, repo)
	serviceFactory.groupService = group.NewService(serviceFactory, repo)
	serviceFactory.permissionService = permissions.NewService(serviceFactory, repo)
	serviceFactory.authService = authentication.NewService(ctx, &conf.Auth, repo, serviceFactory)
	serviceFactory.groupService = group.NewService(serviceFactory, repo)
	serviceFactory.userService = user.NewService(serviceFactory, repo)
	serviceFactory.dashboardService = dashboard.NewService(repo)
	return serviceFactory
}
