package dao

import "time"

type Session struct {
	ID            int64
	UserID        int64
	Token         string
	ExpriryDate   time.Time
	LoggedOut     bool
	Permissions   bool
	DeviceDetails string
	CreatedOn     int64
	UpdatedOn     int64
}
