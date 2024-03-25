package customerrors

import "fmt"

const (
	// error codes
	BAD_REQUEST_ERROR_CODE   = 400
	DB_RECORD_NOT_FOUND_CODE = 40
)

type Error struct {
	Message string
	Code    int
}

func (e *Error) Error() string {
	return fmt.Sprintf("Error: Code: %d , Message: %s", e.Code, e.Message)
}

var (
	ERROR_UNAUTHORISED              = &Error{Message: "unauthorised", Code: 401}
	ERROR_DATABASE                  = &Error{Message: "database operation failed", Code: 502}
	ERROR_PERMISSION_DENIED         = &Error{Message: "permission denied", Code: 403}
	ERROR_DATABASE_UNIQUE_KEY       = &Error{Message: "unique key failed", Code: 412}
	ERROR_DATABASE_RECORD_NOT_FOUND = &Error{Message: "record not found", Code: DB_RECORD_NOT_FOUND_CODE}
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
