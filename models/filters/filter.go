package filters

type UserFilter struct {
	UserId   int64
	Username string
	Email    string
	Mobile   string
	Limit    int
	Offset   int
}

type GroupFilter struct {
	UserId int64
	Limit  int
	Offset int
}

type PermissionFilter struct {
	UserId int64
	Limit  int
	Offset int
}

type OTPFilter struct {
	To string
}

type AuthFilter struct {
	Token string
}
