package filters

type GroupFilter struct {
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
