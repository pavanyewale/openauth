package dao

type Permission struct {
	ID            int64  `gorm:"primary_key;AUTO_INCREMENT"`
	Name          string `gorm:"unique;not null;type:varchar(30)"`
	Description   string
	CreatedByUser int64 `gorm:"foreignKey:UserID"`
	CreatedOn     int64 `gorm:"not null"`
	UpdatedOn     int64 `gorm:"not null"`
	Deleted       bool  `gorm:"not null"`
}

type UserPermission struct {
	Id            int64 `gorm:"primary_key;AUTO_INCREMENT"`
	UserId        int64 `gorm:"foreignKey:UserID;index:unique_user_permission,unique"`
	PermissionId  int64 `gorm:"foreignKey:PermissionID;index:unique_user_permission,unique"`
	CreatedByUser int64
	CreatedOn     int64
	UpdatedOn     int64
	Deleted       bool
}

type GroupPermission struct {
	ID            int64 `gorm:"primary_key;AUTO_INCREMENT"`
	GroupID       int64 `gorm:"foreignKey:GroupID;index:unique_group_permission,unique"`
	PermissionID  int64 `gorm:"foreignKey:PermissionID;index:unique_group_permission,unique"`
	CreatedByUser int64 `gorm:"foreignKey:UserID"`
	CreatedOn     int64 `gorm:"not null"`
	UpdatedOn     int64 `gorm:"not null"`
	Deleted       bool  `gorm:"not null"`
}
