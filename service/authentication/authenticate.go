package authentication

import (
	"context"
	"openauth/models/dto"
	"openauth/models/filters"
	"openauth/utils/customerrors"
	"time"
)

func (s *Service) Authenticate(ctx context.Context, req *dto.AuthRequest) (*dto.AuthenticationResponse, error) {
	session, err := s.repo.GetSessionByToken(ctx, req.Token)
	if err != nil {
		return nil, err
	}
	if session.LoggedOut {
		return nil, customerrors.ERROR_UNAUTHORISED
	}
	user, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{UserId: session.UserID})
	if err != nil {
		return nil, err
	}

	authResponse := dto.AuthenticationResponse{UserId: user.ID, Username: user.Username, FirstName: user.FirstName, LastName: user.LastName}
	if req.Permissions {
		permissions, err := s.serviceFactory.GetPermissionService().GetPermissionsByUserId(ctx, session.UserID)
		if err != nil {
			return nil, err
		}
		var perms []string = make([]string, len(permissions))
		for i, p := range permissions {
			perms[i] = p.Name
		}
		authResponse.Permissions = perms
	}
	return &authResponse, nil
}

func (s *Service) RefreshToken(ctx context.Context, token string) (string, error) {
	session, err := s.repo.GetSessionByToken(ctx, token)
	if err != nil {
		return "", err
	}
	if session.LoggedOut {
		return "", customerrors.ERROR_UNAUTHORISED
	}
	user, err := s.repo.GetUserByFilter(ctx, &filters.UserFilter{UserId: session.UserID})
	if err != nil {
		return "", err
	}
	session.LoggedOut = true
	session.UpdatedOn = time.Now().UnixMilli()
	err = s.repo.UpdateSession(ctx, session)
	if err != nil {
		return "", err
	}
	res, err := s.generateTokenAndLoginResponse(ctx, user, session.DeviceDetails, session.Permissions)
	if err != nil {
		return "", err
	}
	return res.Token, nil
}
