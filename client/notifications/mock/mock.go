package mock

import (
	"context"
	"openauth/utils/logger"
)

type client struct {
}

func NewClient() *client {
	return &client{}
}

func (c *client) SendSMS(ctx context.Context, to []string, body string) error {
	logger.Debug(ctx, "sending sms to: %s body: %s", to, body)
	return nil
}
func (c *client) SendEmail(ctx context.Context, to []string, subject string, body string) error {
	logger.Debug(ctx, "sending email to: %s subject: %s body: %s", to, subject, body)
	return nil
}
