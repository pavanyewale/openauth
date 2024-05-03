package dto

type LoginRequest struct {
	Username      string `json:"username"`
	Password      string `json:"password"`
	OTP           string `json:"otp"`
	DeviceDetails string `json:"deviceDetails"`
	Permissions   bool   `json:"permissions"`
}

type LoginResponse struct {
	UserId     int64  `json:"userId"`
	Token      string `json:"token"`
	OtpExpriry int64  `json:"otpExpriry"`
	Message    string `json:"message"`
}

type ResetPasswordRequest struct {
	UserId      int64  `json:"userId"`
	NewPassword string `json:"newPassword"`
	UpdatedBy   int64  `json:"-"`
}
