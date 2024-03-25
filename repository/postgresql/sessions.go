package postgresql

import (
	"context"
	"database/sql"
	"errors"
	"openauth/models/dao"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

func (r *Repository) GetSessionByToken(ctx context.Context, token string) (*dao.Session, error) {
	var session dao.Session
	row := r.conn.QueryRowContext(ctx, `
		SELECT id, user_id, token, expriry_date, logged_out, permissions, device_details, created_on, updated_on
		FROM sessions
		WHERE token = $1
	`, token)
	err := row.Scan(&session.ID, &session.UserID, &session.Token, &session.ExpriryDate, &session.LoggedOut, &session.Permissions, &session.DeviceDetails, &session.CreatedOn, &session.UpdatedOn)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
		}
		logger.Error(ctx, "failed to get session by token: %s, Err: %s", token, err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	return &session, nil
}

func (r *Repository) UpdateSession(ctx context.Context, session *dao.Session) error {
	_, err := r.conn.ExecContext(ctx, `
		UPDATE sessions
		SET user_id = $1, token = $2, expriry_date = $3, logged_out = $4, permissions = $5, device_details = $6, created_on = $7, updated_on = $8
		WHERE id = $9
	`, session.UserID, session.Token, session.ExpriryDate, session.LoggedOut, session.Permissions, session.DeviceDetails, session.CreatedOn, session.UpdatedOn, session.ID)
	if err != nil {
		logger.Error(ctx, "failed to update session with ID %d, Err: %s", session.ID, err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}

func (r *Repository) CreateSession(ctx context.Context, session *dao.Session) error {
	_, err := r.conn.ExecContext(ctx, `
		INSERT INTO sessions (user_id, token, expriry_date, logged_out, permissions, device_details, created_on, updated_on)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`, session.UserID, session.Token, session.ExpriryDate, session.LoggedOut, session.Permissions, session.DeviceDetails, session.CreatedOn, session.UpdatedOn)
	if err != nil {
		logger.Error(ctx, "failed to create session, Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}
