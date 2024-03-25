package authentication

import (
	"context"
	"time"
)

func (s *Service) Logout(ctx context.Context, token string) error {
	session, err := s.repo.GetSessionByToken(ctx, token)
	if err != nil {
		return err
	}
	session.LoggedOut = true
	session.UpdatedOn = time.Now().UnixMilli()
	err = s.repo.UpdateSession(ctx, session)
	if err != nil {
		return err
	}
	return nil
}
