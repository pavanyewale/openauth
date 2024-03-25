package otp

import "openauth/client/notifications"

type Config struct {
	OTPService         OTPConfig
	NotificationClient notifications.Config
}

type OTPConfig struct {
	// we will allow next otp after some configured mins
	ResendOTPInMins int64
	// 4 or 6 digit
	OTPLength int
	//if otp needs to hash
	HashOTP bool
	Email   Email
	SMS     SMS
}

type Email struct {
	//email otp subject
	Subject string
	//email body format with otp placeholder using %s
	BodyFormat string
}

type SMS struct {
	//sms body format with otp placeholder using %s
	Format string
}

func (c *Config) GetOTPConfig() *OTPConfig {
	return &c.OTPService
}
func (c *Config) GetNotificationsConfig() *notifications.Config {
	return &c.NotificationClient
}
