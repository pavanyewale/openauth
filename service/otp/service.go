package otp

import (
	"context"
	"openauth/client/notifications"
	"openauth/models/dao"
	"openauth/models/filters"
)

type Service struct {
	cfg         config
	notifClient notifications.Client
	repo        Repository
}

type config interface {
	GetOTPConfig() *OTPConfig
	GetNotificationsConfig() *notifications.Config
}

func validate_config(cfg config) {
	c := cfg.GetOTPConfig()
	if c.ResendOTPInMins == 0 {
		panic("OTP Service : ResendOTPInMins should not be empty")
	}
	if c.OTPLength != 4 && c.OTPLength != 6 {
		panic("OTP Service : OTPLength should be 4 or 6")
	}
	if c.Email.BodyFormat == "" {
		panic("OTP Service : Email.BodyFormat should not be empty")
	}

	if c.Email.Subject == "" {
		panic("OTP Service : Email.Subject should not be empty")
	}

	if c.SMS.Format == "" {
		panic("OTP Service : SMS.Format should not be empty")
	}
}

type Repository interface {
	CreateOTP(context.Context, *dao.Otp) error
	GetLatestOTPByFilter(context.Context, *filters.OTPFilter) (*dao.Otp, error)
}

func NewService(cfg config, repo Repository) *Service {
	validate_config(cfg)
	return &Service{cfg: cfg, repo: repo, notifClient: notifications.NewNotificationClient(cfg.GetNotificationsConfig())}
}
