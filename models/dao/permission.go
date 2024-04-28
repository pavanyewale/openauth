package dao

type Permission struct {
	ID          int64
	Name        string
	Category    string
	Description string
	CreatedBy   int64
	CreatedOn   int64
	UpdatedOn   int64
	Deleted     bool
}

type UserPermission struct {
	Id            int64
	UserId        int64
	PermissionId  int64
	CreatedByUser int64
	CreatedOn     int64
	UpdatedOn     int64
	Deleted       bool
}

type GroupPermission struct {
	ID            int64
	GroupID       int64
	PermissionID  int64
	CreatedByUser int64
	CreatedOn     int64
	UpdatedOn     int64
	Deleted       bool
}
