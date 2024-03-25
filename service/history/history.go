package history

import (
	"context"
	"encoding/json"
	"openauth/constants"
	"openauth/models/dao"
	"openauth/utils/logger"
	"time"
)

type Reposiory interface {
	CreateHistory(ctx context.Context, history *dao.History) error
}

type Service struct {
	repo Reposiory
}

func NewService(r Reposiory) *Service {
	return &Service{repo: r}
}

func (s *Service) AddLogAsync(ctx context.Context, operation constants.Operation, data any, createdByUser int64) {
	s.AddLog(ctx, operation, data, createdByUser)
}

func (s *Service) AddLog(ctx context.Context, operation constants.Operation, data any, createdByUser int64) error {
	var history dao.History
	bytes, err := json.Marshal(data)
	if err != nil {
		logger.Error(ctx, "marshaling data in history :%v", err.Error())
	}
	history.Data = string(bytes)
	history.CreatedOn = time.Now().UnixMilli()
	history.Operation = string(operation)
	history.CreatedByUser = createdByUser
	return s.repo.CreateHistory(ctx, &history)

}
