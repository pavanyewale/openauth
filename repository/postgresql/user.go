package postgresql

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"openauth/models/dao"
	"openauth/models/filters"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

func (r *Repository) CreateUser(ctx context.Context, user *dao.User) error {
	_, err := r.conn.ExecContext(ctx, `
		INSERT INTO users (first_name, middle_name, last_name, username, bio, password, mobile, email, mobile_verified, email_verified, created_by_user, created_on, updated_on)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
	`, user.FirstName, user.MiddleName, user.LastName, user.Username, user.Bio, user.Password, user.Mobile, user.Email, user.MobileVerified, user.EmailVerified, user.CreatedByUser, user.CreatedOn, user.UpdatedOn)
	if err != nil {
		logger.Error(ctx, "failed to create user, Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}

func (r *Repository) GetUserByFilter(ctx context.Context, filter *filters.UserFilter) (*dao.User, error) {
	var user dao.User
	var query string

	query = "SELECT id, first_name, middle_name, last_name, username, bio, password, mobile, email, mobile_verified, email_verified, created_by_user, created_on, updated_on FROM users WHERE 1=1"
	if filter.UserId != 0 {
		query += fmt.Sprintf(" AND id = %d", filter.UserId)
	}

	if filter.Username != "" {
		query += fmt.Sprintf(" AND username = '%s'", filter.Username)
	}

	if filter.Email != "" {
		query += fmt.Sprintf(" AND email = '%s'", filter.Email)
	}

	if filter.Mobile != "" {
		query += fmt.Sprintf(" AND mobile = '%s'", filter.Mobile)
	}
	logger.Debug(ctx, "query: %s", query)
	row := r.conn.QueryRowContext(ctx, query)
	err := row.Scan(&user.ID, &user.FirstName, &user.MiddleName, &user.LastName, &user.Username, &user.Bio, &user.Password, &user.Mobile, &user.Email, &user.MobileVerified, &user.EmailVerified, &user.CreatedByUser, &user.CreatedOn, &user.UpdatedOn)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
		}
		logger.Error(ctx, "failed to get user by filter, Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	return &user, nil
}
