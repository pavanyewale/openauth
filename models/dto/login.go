package dto

type LoginRequest struct {
	Username      string `json:"username"`
	Password      string `json:"password"`
	OTP           string `json:"otp"`
	DeviceDetails string `json:"deviceDetails"`
	Permissions   bool   `json:"permissions"`
}

type LoginResponse struct {
	UserId  int64  `json:"userId"`
	Token   string `json:"token"`
	Message string `json:"message"`
}
