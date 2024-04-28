package postgresql

import (
	"database/sql"
	"openauth/utils/customerrors"
)

func parseError(err error) error {
	if err == sql.ErrNoRows {
		return customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
	}
	return customerrors.ERROR_DATABASE
}
