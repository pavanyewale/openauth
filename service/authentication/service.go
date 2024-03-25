package authentication

import (
	"context"
	"openauth/models/dao"
	"openauth/models/filters"
	"openauth/service/otp"
	"openauth/service/permissions"
)

type Service struct {
	cfg            *Config
	repo           Repository
	serviceFactory serviceFactory
}

type Repository interface {
	CreateUser(context.Context, *dao.User) error
	GetUserByFilter(context.Context, *filters.UserFilter) (*dao.User, error)
	GetSessionByToken(ctx context.Context, token string) (*dao.Session, error)
	UpdateSession(ctx context.Context, session *dao.Session) error
	CreateSession(ctx context.Context, session *dao.Session) error
}

type serviceFactory interface {
	GetOTPService() *otp.Service
	GetPermissionService() *permissions.Service
}

func NewService(ctx context.Context, cfg *Config, repo Repository, serviceFactory serviceFactory) *Service {
	cfg.validate(ctx)
	return &Service{cfg: cfg, repo: repo, serviceFactory: serviceFactory}
}
