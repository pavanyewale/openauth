package dao

type Group struct {
	ID            int64  `gorm:"primary_key;AUTO_INCREMENT"`
	Name          string `gorm:"unique;not null;type:varchar(50)"`
	Description   string `gorm:"type:varchar(255);not null"`
	CreatedByUser int64  `gorm:"foreignKey:UserID"`
	CreatedOn     int64  `gorm:"not null"`
	UpdatedOn     int64  `gorm:"not null"`
	Deleted       bool   `gorm:"not null"`
}

type UserGroup struct {
	Id            int64 `gorm:"primary_key;AUTO_INCREMENT"`
	UserId        int64 `gorm:"foreignKey:UserID;index:unique_user_group,unique"`
	GroupId       int64 `gorm:"foreignKey:GroupID;index:unique_user_group,unique"`
	CreatedByUser int64 `gorm:"foreignKey:UserID"`
	CreatedOn     int64
	UpdatedOn     int64
	Deleted       bool
}
