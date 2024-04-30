package postgresql

import (
	"context"
	"openauth/models/dao"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

func (r *Repository) CreateHistory(ctx context.Context, history *dao.History) error {
	_, err := r.conn.ExecContext(ctx, `
		INSERT INTO history (operation, data, created_by, created_on)
		VALUES ($1, $2, $3, $4)
	`, history.Operation, history.Data, history.CreatedByUser, history.CreatedOn)
	if err != nil {
		logger.Error(ctx, "failed to create history record, Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}

func (r *Repository) GetHistory(ctx context.Context, startDate, endDate, limit, offset int64) ([]dao.History, error) {
	rows, err := r.conn.QueryContext(ctx, `
		SELECT id, operation, data, created_by, created_on FROM history
		WHERE created_on >= $1 AND created_on <= $2 ORDER BY created_on DESC LIMIT $3 OFFSET $4
	`, startDate, endDate, limit, offset)
	if err != nil {
		logger.Error(ctx, "failed to get history records, Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer rows.Close()
	var history []dao.History
	for rows.Next() {
		var h dao.History
		err = rows.Scan(&h.ID, &h.Operation, &h.Data, &h.CreatedByUser, &h.CreatedOn)
		if err != nil {
			logger.Error(ctx, "failed to scan history record, Err: %s", err.Error())
			return nil, customerrors.ERROR_DATABASE
		}
		history = append(history, h)
	}
	return history, nil
}
