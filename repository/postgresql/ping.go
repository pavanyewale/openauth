package postgresql

import "context"

func (r *Repository) Ping(ctx context.Context) error {
	// need to complete this
	return r.conn.PingContext(ctx)
}
