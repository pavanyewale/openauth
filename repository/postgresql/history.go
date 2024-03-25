package postgresql

import (
	"context"
	"openauth/models/dao"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

func (r *Repository) CreateHistory(ctx context.Context, history *dao.History) error {
	_, err := r.conn.ExecContext(ctx, `
		INSERT INTO history (operation, data, created_by_user, created_on)
		VALUES ($1, $2, $3, $4)
	`, history.Operation, history.Data, history.CreatedByUser, history.CreatedOn)
	if err != nil {
		logger.Error(ctx, "failed to create history record, Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}
