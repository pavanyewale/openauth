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

// Repository is the postgresql repository for user
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

// GetUserByFilter fetches single user by filter
func (r *Repository) GetUserByFilter(ctx context.Context, filter *filters.UserFilter) (*dao.User, error) {
	var user dao.User
	var query string

	query = "SELECT id, first_name, middle_name, last_name, username, bio, password, mobile, email, mobile_verified, email_verified, created_by_user, created_on, updated_on, deleted FROM users WHERE 1=1"
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
	err := row.Scan(&user.ID, &user.FirstName, &user.MiddleName, &user.LastName, &user.Username, &user.Bio, &user.Password, &user.Mobile, &user.Email, &user.MobileVerified, &user.EmailVerified, &user.CreatedByUser, &user.CreatedOn, &user.UpdatedOn, &user.Deleted)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
		}
		logger.Error(ctx, "failed to get user by filter, Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	return &user, nil
}

// GetUsersByFilter fetches multiple users by filter
func (r *Repository) GetUsersByFilter(ctx context.Context, filter *filters.UserFilter, limit, offset int) ([]*dao.User, error) {
	var query string

	query = "SELECT id, first_name, middle_name, last_name, username, bio, password, mobile, email, mobile_verified, email_verified, created_by_user, created_on, updated_on, deleted FROM users WHERE 1=1"
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
	rows, err := r.conn.QueryContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to get user by filter, Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer rows.Close()
	users := make([]*dao.User, 0)
	for rows.Next() {
		var user dao.User
		err := rows.Scan(&user.ID, &user.FirstName, &user.MiddleName, &user.LastName, &user.Username, &user.Bio, &user.Password, &user.Mobile, &user.Email, &user.MobileVerified, &user.EmailVerified, &user.CreatedByUser, &user.CreatedOn, &user.UpdatedOn, &user.Deleted)
		if err != nil {
			logger.Error(ctx, "failed to get user by filter, Err: %s", err.Error())
			return nil, customerrors.ERROR_DATABASE
		}
		users = append(users, &user)
	}
	return users, nil
}

// GetUserById fetches user by id
func (r *Repository) GetUserById(ctx context.Context, id int64) (*dao.User, error) {
	var user dao.User
	row := r.conn.QueryRowContext(ctx, `
		SELECT id, first_name, middle_name, last_name, username, bio, password, mobile, email, mobile_verified, email_verified, created_by_user, created_on, updated_on ,deleted
		FROM users WHERE id = $1
	`, id)
	err := row.Scan(&user.ID, &user.FirstName, &user.MiddleName, &user.LastName, &user.Username, &user.Bio, &user.Password, &user.Mobile, &user.Email, &user.MobileVerified, &user.EmailVerified, &user.CreatedByUser, &user.CreatedOn, &user.UpdatedOn, &user.Deleted)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
		}
		logger.Error(ctx, "failed to get user by id, Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	return &user, nil
}

// UpdateUser updates user
func (r *Repository) UpdateUser(ctx context.Context, user *dao.User) error {
	_, err := r.conn.ExecContext(ctx, `
		UPDATE users SET first_name = $1, middle_name = $2, last_name = $3, username = $4, bio = $5, password = $6, mobile = $7, email = $8, mobile_verified = $9, email_verified = $10, created_by_user = $11, created_on = $12, updated_on = $13, deleted = $14
		WHERE id = $15
	`, user.FirstName, user.MiddleName, user.LastName, user.Username, user.Bio, user.Password, user.Mobile, user.Email, user.MobileVerified, user.EmailVerified, user.CreatedByUser, user.CreatedOn, user.UpdatedOn, user.Deleted, user.ID)
	if err != nil {
		logger.Error(ctx, "failed to update user, Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}
