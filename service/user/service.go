package user

import (
	"context"
	"openauth/models/dao"
	"openauth/models/dto"
	"openauth/models/filters"
	"openauth/service/otp"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

type Service struct {
	repo Repository
	sf   serviceFactory
}

type Repository interface {
	GetUserById(ctx context.Context, id int64) (*dao.User, error)
	GetUsersByFilter(ctx context.Context, filter *filters.UserFilter, limit, offset int) ([]*dao.User, error)
	GetUserByFilter(ctx context.Context, filter *filters.UserFilter) (*dao.User, error)
	UpdateUser(ctx context.Context, user *dao.User) error
	CreateUser(ctx context.Context, user *dao.User) error
}

type serviceFactory interface {
	GetOTPService() *otp.Service
}

func NewService(sf serviceFactory, repo Repository) *Service {
	return &Service{
		repo: repo,
		sf:   sf,
	}
}

// GetUserById fetches user by id
func (s *Service) GetUserDetailsById(ctx context.Context, id int64) (*dto.UserDetails, error) {
	user, err := s.repo.GetUserById(ctx, id)
	if err != nil {
		return nil, err
	}
	return (&dto.UserDetails{}).FromUser(user), nil
}

// GetUsersByFilter fetches users by filter
func (s *Service) GetUsersByFilter(ctx context.Context, filter *filters.UserFilter, limit, offset int) ([]*dto.ShortUserDetails, error) {
	users, err := s.repo.GetUsersByFilter(ctx, filter, limit, offset)
	if err != nil {
		return nil, err
	}
	userDetails := make([]*dto.ShortUserDetails, len(users))
	for i, u := range users {
		userDetails[i] = (&dto.ShortUserDetails{}).FromUser(u)
	}
	return userDetails, nil
}

func (s *Service) validateUsername(ctx context.Context, username string) error {
	_, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{Username: username})
	if err != nil {
		if err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
			return err
		}
	} else {
		return customerrors.BAD_REQUEST_ERROR("username already exists with another user")
	}
	return nil
}

// validateMobile validates mobile number , return true sends otp if otp is not provided
func (s *Service) validateMobile(ctx context.Context, mobile string, otp string) error {
	_, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{Mobile: mobile})
	if err != nil {
		if err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
			return err
		}
		// if user not found then send otp
		if otp == "" {
			_, err = s.sf.GetOTPService().SendOTPOnEmailOrMobile(ctx, mobile)
			return err
		} else {
			err = s.sf.GetOTPService().ValidateOtp(ctx, mobile, otp)
			if err != nil {
				return err
			}
			return nil
		}
	}
	return customerrors.BAD_REQUEST_ERROR("mobile already exists with another user")

}

func (s *Service) isValidEmail(ctx context.Context, email string, otp string) error {
	_, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{Email: email})
	if err != nil {
		if err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
			return err
		}
		// if user not found then send otp
		if otp == "" {
			_, err = s.sf.GetOTPService().SendOTPOnEmailOrMobile(ctx, email)
			return err
		} else {
			err = s.sf.GetOTPService().ValidateOtp(ctx, email, otp)
			if err != nil {
				return err
			}
			return nil
		}
	}
	return customerrors.BAD_REQUEST_ERROR("email already exists with another user")
}

func (s *Service) CreateUser(ctx context.Context, req *dto.CreateUpdateUserRequest, updatedByUserId int64) (*dto.UserDetails, error) {
	if req.Username != "" {
		err := s.validateUsername(ctx, req.Username)
		if err != nil {
			return nil, err
		}
	}

	if req.Mobile != "" {
		if req.MobileOTP == "" {
			return nil, customerrors.BAD_REQUEST_ERROR("mobile otp required")
		}
		err := s.validateMobile(ctx, req.Mobile, req.MobileOTP)
		if err != nil {
			return nil, err
		}
	}
	if req.Email != "" {
		if req.EmailOTP == "" {
			return nil, customerrors.BAD_REQUEST_ERROR("email otp required")
		}
		err := s.isValidEmail(ctx, req.Email, req.EmailOTP)
		if err != nil {
			return nil, err
		}
	}
	user := req.ToUser()
	user.CreatedByUser = updatedByUserId
	err := s.repo.CreateUser(ctx, user)
	if err != nil {
		return nil, err
	}
	return s.GetUserDetailsById(ctx, user.ID)
}

func (s *Service) UpdateUser(ctx context.Context, user *dto.CreateUpdateUserRequest, updatedByUserId int64) (*dto.UserDetails, error) {
	if user.ID == 0 {
		return nil, customerrors.BAD_REQUEST_ERROR("user id required")
	}
	dbUser, err := s.repo.GetUserById(ctx, user.ID)
	if err != nil {
		if err == customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
			return nil, customerrors.BAD_REQUEST_ERROR("user not found")
		}
		return nil, err
	}
	if user.Username != dbUser.Username {
		err := s.validateUsername(ctx, user.Username)
		if err != nil {
			return nil, err
		}
		dbUser.Username = user.Username
	}
	if user.Mobile != dbUser.Mobile {
		if user.MobileOTP == "" {
			return nil, customerrors.BAD_REQUEST_ERROR("mobile otp required")
		}
		err := s.validateMobile(ctx, user.Mobile, user.MobileOTP)
		if err != nil {
			return nil, err
		}
		dbUser.Mobile = user.Mobile
	}
	if user.Email != dbUser.Email {
		if user.EmailOTP == "" {
			return nil, customerrors.BAD_REQUEST_ERROR("email otp required")
		}
		err := s.isValidEmail(ctx, user.Email, user.EmailOTP)
		if err != nil {
			return nil, err
		}
		dbUser.Email = user.Email
	}
	dbUser.FirstName = user.FirstName
	dbUser.MiddleName = user.MiddleName
	dbUser.LastName = user.LastName
	dbUser.Bio = user.Bio
	err = s.repo.UpdateUser(ctx, dbUser)
	if err != nil {
		return nil, err
	}
	return (&dto.UserDetails{}).FromUser(dbUser), nil
}

// CreateUpdateUser creates or updates user
func (s *Service) CreateUpdateUser(ctx context.Context, user *dto.CreateUpdateUserRequest, updatedByUserId int64) (*dto.UserDetails, error) {
	if user.ID == 0 {
		return s.CreateUser(ctx, user, updatedByUserId)
	}
	return s.UpdateUser(ctx, user, updatedByUserId)
}

// VerifyDetails implements handlers.service.
func (s *Service) VerifyAvailability(ctx context.Context, details *dto.VerifyAvailabilityRequest) (*dto.VerifyAvailabilityResponse, error) {
	var res dto.VerifyAvailabilityResponse

	if details.Username != "" {
		_, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{Username: details.Username})
		if err != nil {
			if err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
				return nil, err
			}
		} else {
			res.UsernameErr = "username already exists"
		}
	}

	if details.Mobile != "" {
		_, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{Mobile: details.Mobile})
		if err != nil {
			if err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
				return nil, err
			}
		} else {
			res.MobileErr = "mobile already exists"
		}
	}

	if details.Email != "" {
		_, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{Email: details.Email})
		if err != nil {
			if err != customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
				return nil, err
			}
		} else {
			res.EmailErr = "email already exists"
		}
	}

	if details.SendOtp && (res.MobileErr == "" && res.EmailErr == "" && res.UsernameErr == "") {
		logger.Debug(ctx, "all availables so sending otp")
		// send otp
		if details.Mobile != "" {
			_, err := s.sf.GetOTPService().SendOTPOnEmailOrMobile(ctx, details.Mobile)
			if err != nil {
				return nil, err
			}
		}
		if details.Email != "" {
			otpRes, err := s.sf.GetOTPService().SendOTPOnEmailOrMobile(ctx, details.Email)
			if err != nil {
				return nil, err
			}
			res.OtpExpriry = otpRes.Expriry
		}
	}
	return &res, nil

}
