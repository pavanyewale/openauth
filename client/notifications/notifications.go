package notifications

import (
	"context"
	"openauth/client/notifications/mock"
)

type Client interface {
	SendSMS(ctx context.Context, to []string, body string) error
	SendEmail(ctx context.Context, to []string, subject string, body string) error
}

func NewNotificationClient(cfg *Config) Client {
	cfg.validate()
	return mock.NewClient()
}
