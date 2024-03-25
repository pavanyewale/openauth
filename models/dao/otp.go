package dao

type Otp struct {
	ID        int64
	SentTo    string
	OTP       string
	Expriry   int64
	CreatedOn int64
	UpdatedOn int64
}
