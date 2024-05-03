package authentication

import (
	"context"
	"openauth/constants"
	"openauth/models/dto"
	"openauth/utils/customerrors"
	"openauth/utils/logger"

	"golang.org/x/crypto/bcrypt"
)

func (s *Service) ResetPassword(ctx context.Context, req *dto.ResetPasswordRequest) error {

	user, err := s.repo.GetUserById(ctx, req.UserId)
	if err != nil {
		if err == customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
			return customerrors.BAD_REQUEST_ERROR("invalid user id")
		}
		return err
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		logger.Error(ctx, "error hashing password: %s", err.Error())
		return customerrors.ERROR_INTERNAL_SERVER_ERROR
	}
	s.serviceFactory.GetHistoryService().AddLogAsync(ctx, constants.RESET_PASSWORD, req, req.UpdatedBy)
	user.Password = string(hashedPassword)
	return s.repo.UpdateUser(ctx, user)
}
