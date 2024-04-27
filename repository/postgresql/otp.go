package postgresql

import (
	"context"
	"database/sql"
	"openauth/models/dao"
	"openauth/models/filters"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

func (r *Repository) CreateOTP(ctx context.Context, otp *dao.Otp) error {
	query := "INSERT INTO public.otps (sent_to, otp, expriry, created_on, updated_on) VALUES ($1, $2, $3, $4, $5)"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	_, err = stmt.ExecContext(ctx, otp.SentTo, otp.OTP, otp.Expriry, otp.CreatedOn, otp.UpdatedOn)
	if err != nil {
		logger.Error(ctx, "failed to execute query: %s Err: %s", query, err.Error())
		return customerrors.ERROR_DATABASE
	}

	return nil
}

func (r *Repository) GetLatestOTPByFilter(ctx context.Context, filter *filters.OTPFilter) (*dao.Otp, error) {
	query := "SELECT sent_to, otp, expriry, created_on, updated_on FROM public.otps WHERE sent_to = $1 ORDER BY created_on DESC LIMIT 1"
	row := r.conn.QueryRowContext(ctx, query, filter.To)

	otp := &dao.Otp{}
	err := row.Scan(&otp.SentTo, &otp.OTP, &otp.Expriry, &otp.CreatedOn, &otp.UpdatedOn)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
		}
		logger.Error(ctx, "failed to scan OTP row: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}

	return otp, nil
}
