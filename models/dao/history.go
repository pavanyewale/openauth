package dao

type History struct {
	ID            int64  `gorm:"primary_key;AUTO_INCREMENT"`
	Operation     string `gorm:"size:30"`
	Data          string `gorm:"type:varchar(255);not null"`
	CreatedByUser int64  `gorm:"not null"`
	CreatedOn     int64  `gorm:"not null"`
}
