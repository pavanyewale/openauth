package user

import (
	"context"
	"openauth/utils/customerrors"
)

// DeleteUserById deletes user by id
func (s *Service) DeleteUserById(ctx context.Context, id int64, deletedByUserId int64) error {
	user, err := s.repo.GetUserById(ctx, id)
	if err != nil {
		if err == customerrors.ERROR_DATABASE_RECORD_NOT_FOUND {
			return customerrors.BAD_REQUEST_ERROR("user not found")
		}
		return err
	}
	if user.Username == "admin" {
		return customerrors.BAD_REQUEST_ERROR("cannot delete admin user")
	}
	if user.Deleted {
		return customerrors.BAD_REQUEST_ERROR("user already deleted")
	}

	user.Deleted = true
	return s.repo.UpdateUser(ctx, user)
}
