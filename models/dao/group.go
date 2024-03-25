package dao

type Group struct {
	ID            int64
	Name          string
	Description   string
	CreatedByUser int64
	CreatedOn     int64
	UpdatedOn     int64
	Deleted       bool
}

type UserGroup struct {
	Id            int64
	UserId        int64
	GroupId       int64
	CreatedByUser int64
	CreatedOn     int64
	UpdatedOn     int64
	Deleted       bool
}
