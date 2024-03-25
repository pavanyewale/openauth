package postgresql

import (
	"context"
	"openauth/models/dao"
)

func (r *Repository) CreateHistory(ctx context.Context, history *dao.History) error {
	// Implement your logic to create a history record in the database
	return nil
}
