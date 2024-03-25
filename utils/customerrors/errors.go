package customerrors

import "fmt"

const (
	// error codes
	CODE_BAD_REQUEST_ERROR = 400
)

type Error struct {
	Message string
	Code    int
}

func (e *Error) Error() string {
	return fmt.Sprintf("Error: Code: %d , Message: %s", e.Code, e.Message)
}

var (
	ERROR_UNAUTHORISED        = &Error{Message: "unauthorised", Code: 401}
	ERROR_DATABASE            = &Error{Message: "database operation failed", Code: 502}
	ERROR_PERMISSION_DENIED   = &Error{Message: "permission denied", Code: 403}
	ERROR_DATABASE_UNIQUE_KEY = &Error{Message: "unique key failed", Code: 412}
)

func NewBadRequestError(message string, args ...any) *Error {
	return &Error{Code: CODE_BAD_REQUEST_ERROR, Message: fmt.Sprintf(message, args...)}
}
