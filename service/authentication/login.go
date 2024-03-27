package authentication

import (
	"context"
	"encoding/json"
	"openauth/constants"
	"openauth/models/dao"
	"openauth/models/dto"
	"openauth/models/filters"
	"openauth/utils"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

func (s *Service) getUserByMobileOrEmailOrUsername(value string) (*dao.User, error) {

	if utils.IsMobile(value) {
		return s.repo.GetUserByFilter(context.Background(), &filters.UserFilter{Mobile: value})

	} else if utils.IsEmail(value) {
		return s.repo.GetUserByFilter(context.Background(), &filters.UserFilter{Email: value})
	} else {
		return s.repo.GetUserByFilter(context.Background(), &filters.UserFilter{Username: value})
	}
}

func (s *Service) generateToken(ctx context.Context, user *dao.User, permissions bool) (string, error) {
	//todo
	if s.cfg.TokenType == constants.TOKEN_TYPE_JWT {
		// Create a new JWT token
		token := jwt.New(jwt.SigningMethodHS256)

		// Set claims
		claims := token.Claims.(jwt.MapClaims)
		auth := dto.AuthenticationResponse{
			UserId:    user.ID,
			Username:  user.Username,
			FirstName: user.FirstName,
			LastName:  user.LastName,
		}
		if permissions {
			permissions, err := s.serviceFactory.GetPermissionService().GetPermissionsByUserId(ctx, user.ID)
			if err != nil {
				return "", err
			}
			perms := make([]string, len(permissions))
			for i, p := range permissions {
				perms[i] = p.Name
			}
			auth.Permissions = perms
		}
		bytes, _ := json.Marshal(auth)
		claims["userDetails"] = string(bytes)

		claims["exp"] = time.Now().Add(time.Hour * 24 * time.Duration(s.cfg.AuthTokenExpriryInDays)).UnixMilli()

		// Sign the token with the secret key
		tokenString, err := token.SignedString([]byte(s.cfg.JWTSecretekey))
		if err != nil {
			logger.Error(ctx, "singing jwt token : %v", err.Error())
			return "", err
		}

		return tokenString, nil
	}
	// returnning uuid as a token
	return uuid.New().String(), nil
}

func (s *Service) generateTokenAndLoginResponse(ctx context.Context, user *dao.User, deviceDetails string, permissions bool) (*dto.LoginResponse, error) {

	authToken, err := s.generateToken(ctx, user, permissions)
	if err != nil {
		return nil, err
	}
	session := &dao.Session{
		UserID:        user.ID,
		Token:         authToken,
		ExpriryDate:   time.Now().Add(time.Hour * 24 * time.Duration(s.cfg.AuthTokenExpriryInDays)),
		DeviceDetails: deviceDetails,
		CreatedOn:     time.Now().UnixMilli(),
		UpdatedOn:     time.Now().UnixMilli(),
	}
	err = s.repo.CreateSession(ctx, session)
	if err != nil {
		return nil, err
	}

	return &dto.LoginResponse{UserId: user.ID, Token: session.Token, Message: "logged in successfully!!"}, nil
}

func addMobileEmailOrUsername(user *dao.User, value string) {
	if utils.IsMobile(value) {
		user.Mobile = value
		return
	}
	if utils.IsEmail(value) {
		user.Email = value
		return
	}
	user.Username = value

}

func (s *Service) Login(ctx context.Context, req *dto.LoginRequest) (*dto.LoginResponse, error) {
	if req.Password != "" {
		user, err := s.getUserByMobileOrEmailOrUsername(req.Username)
		if err != nil {
			if customerrors.IS_RECORD_NOT_FOUND_ERROR(err) {
				return nil, customerrors.BAD_REQUEST_ERROR("invalid username or password")
			}
			return nil, err
		}

		err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password))
		if err != nil {
			return nil, customerrors.BAD_REQUEST_ERROR("invalid username or password")
		}
		return s.generateTokenAndLoginResponse(ctx, user, req.DeviceDetails, req.Permissions)

	} else if req.OTP != "" {
		//validate otp
		if err := s.serviceFactory.GetOTPService().ValidateOtp(ctx, req.Username, req.OTP); err != nil {
			return nil, err
		}
		user, err := s.getUserByMobileOrEmailOrUsername(req.Username)
		if err != nil {
			if !customerrors.IS_RECORD_NOT_FOUND_ERROR(err) {
				return nil, err
			}
			//create new user
			user = &dao.User{CreatedOn: time.Now().UnixMilli(), UpdatedOn: time.Now().UnixMilli()}
			addMobileEmailOrUsername(user, req.Username)
			err = s.repo.CreateUser(ctx, user)
			if err != nil {
				return nil, err
			}
		}
		return s.generateTokenAndLoginResponse(ctx, user, req.DeviceDetails, req.Permissions)
	} else {
		//send otp
		err := s.serviceFactory.GetOTPService().SendOTPOnEmailOrMobile(ctx, req.Username)
		if err != nil {
			return nil, err
		}
		return &dto.LoginResponse{Message: "otp sent to email/mobile"}, nil
	}
}
