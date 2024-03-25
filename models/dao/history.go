package dao

type History struct {
	ID            int64
	Operation     string
	Data          string
	CreatedByUser int64
	CreatedOn     int64
}
