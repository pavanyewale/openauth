package dto

import "openauth/models/dao"

type UserDetails struct {
	ID             int64  `json:"id"`
	FirstName      string `json:"firstName"`
	MiddleName     string `json:"middleName"`
	LastName       string `json:"lastName"`
	Username       string `json:"username"`
	Bio            string `json:"bio"`
	Mobile         string `json:"mobile"`
	Email          string `json:"email"`
	MobileVerified bool   `json:"mobileVerified"`
	EmailVerified  bool   `json:"emailVerified"`
	CreatedByUser  int64  `json:"createdBy"`
	CreatedOn      int64  `json:"createdOn"`
	UpdatedOn      int64  `json:"updatedOn"`
	Deleted        bool   `json:"deleted"`
}

func (ud *UserDetails) FromUser(u *dao.User) *UserDetails {
	ud.ID = u.ID
	ud.FirstName = u.FirstName
	ud.MiddleName = u.MiddleName
	ud.LastName = u.LastName
	ud.Username = u.Username
	ud.Bio = u.Bio
	ud.Mobile = u.Mobile
	ud.Email = u.Email
	ud.MobileVerified = u.MobileVerified
	ud.EmailVerified = u.EmailVerified
	ud.CreatedByUser = u.CreatedByUser
	ud.CreatedOn = u.CreatedOn
	ud.UpdatedOn = u.UpdatedOn
	ud.Deleted = u.Deleted
	return ud
}

type CreateUpdateUserRequest struct {
	ID         int64  `json:"id"`
	FirstName  string `json:"firstName"`
	MiddleName string `json:"middleName"`
	LastName   string `json:"lastName"`
	Username   string `json:"username"`
	Bio        string `json:"bio"`
	Mobile     string `json:"mobile"`
	Email      string `json:"email"`
	MobileOTP  string `json:"mobileOTP"`
	EmailOTP   string `json:"emailOTP"`
}

func (ud *CreateUpdateUserRequest) ToUser() *dao.User {
	return &dao.User{
		ID:         ud.ID,
		FirstName:  ud.FirstName,
		MiddleName: ud.MiddleName,
		LastName:   ud.LastName,
		Bio:        ud.Bio,
		Mobile:     ud.Mobile,
		Email:      ud.Email,
	}
}
