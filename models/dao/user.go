package dao

type User struct {
	ID             int64
	FirstName      string
	MiddleName     string
	LastName       string
	Username       string
	ProfilePic     string
	Bio            string
	Password       string
	Mobile         string
	Email          string
	MobileVerified bool
	EmailVerified  bool
	CreatedByUser  int64
	CreatedOn      int64
	UpdatedOn      int64
	Deleted        bool
}
