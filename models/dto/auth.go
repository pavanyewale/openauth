package dto

type AuthResponse struct {
	Token   string `json:"token"`
	Message string `json:"message"`
}

type AuthRequest struct {
	Permissions bool   `json:"permissions"`
	Token       string `json:"-"`
	SessionID   int64  `json:"-"`
}

type AuthenticationResponse struct {
	UserId      int64    `json:"userId"`
	Username    string   `json:"username"`
	FirstName   string   `json:"firstName"`
	LastName    string   `json:"lastName"`
	Permissions []string `json:"permissions"`
}

type RefreshTokenResponse struct {
	Token string `json:"token"`
}
