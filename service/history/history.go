package history

import (
	"context"
	"encoding/json"
	"openauth/constants"
	"openauth/models/dao"
	"openauth/models/dto"
	"openauth/utils/logger"
	"time"
)

type Reposiory interface {
	CreateHistory(ctx context.Context, history *dao.History) error
	GetHistory(ctx context.Context, startDate, endDate int64, limit, offset int64) ([]dao.History, error)
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

// GetHistory function

func (s *Service) GetHistory(ctx context.Context, req *dto.HistoryRequest) (*dto.HistoryResponse, error) {
	history, err := s.repo.GetHistory(ctx, req.StartDate, req.EndDate, req.Limit, req.Offset)
	if err != nil {
		return nil, err
	}
	var res dto.HistoryResponse
	res.History = make([]dto.History, 0)
	for _, h := range history {
		res.History = append(res.History, dto.History{
			ID:            h.ID,
			Operation:     h.Operation,
			Data:          h.Data,
			CreatedByUser: h.CreatedByUser,
			CreatedOn:     h.CreatedOn,
		})
	}
	return &res, nil
}
