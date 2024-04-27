package customerrors

import (
	"fmt"
	"net/http"
)

const (
	// error codes
	BAD_REQUEST_ERROR_CODE   = 400
	DATABASE_ERROR_CODE      = 40
	DB_RECORD_NOT_FOUND_CODE = 41
)

type Error struct {
	Message string
	Code    int
}

func (e *Error) Error() string {
	return e.Message
}

var (
	ERROR_UNAUTHORISED              = &Error{Message: "unauthorised", Code: http.StatusUnauthorized}
	ERROR_DATABASE                  = &Error{Message: "database operation failed", Code: http.StatusFailedDependency}
	ERROR_PERMISSION_DENIED         = &Error{Message: "permission denied", Code: http.StatusForbidden}
	ERROR_DATABASE_UNIQUE_KEY       = &Error{Message: "unique key failed", Code: http.StatusBadRequest}
	ERROR_DATABASE_RECORD_NOT_FOUND = &Error{Message: "record not found", Code: http.StatusNotFound}
)

func BAD_REQUEST_ERROR(message string, args ...any) *Error {
	return &Error{Code: BAD_REQUEST_ERROR_CODE, Message: fmt.Sprintf(message, args...)}
}

func RECORD_NOT_FOUND_ERROR(message string) error {
	return &Error{Message: message, Code: DB_RECORD_NOT_FOUND_CODE}
}

func IS_RECORD_NOT_FOUND_ERROR(err error) bool {
	if customErr, ok := err.(*Error); ok && customErr.Code == DB_RECORD_NOT_FOUND_CODE {
		return true
	}
	return false
}
