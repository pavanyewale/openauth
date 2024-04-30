package handlers

import (
	"context"
	"openauth/models/dto"
	"openauth/utils/customerrors"
	"time"

	"github.com/gin-gonic/gin"
)

type HistoryHandler struct {
	service HistoryService
}

type HistoryService interface {
	GetHistory(ctx context.Context, req *dto.HistoryRequest) (*dto.HistoryResponse, error)
}

func NewHistoryHandler(service HistoryService) *HistoryHandler {
	return &HistoryHandler{service: service}
}

func (hh *HistoryHandler) Register(router gin.IRouter) {
	router.GET("/openauth/history", hh.getHistory)
}

// @Summary Get History
// @Description Get history of user
// @Tags History
// @Accept json
// @Produce json
// @Param request query string false "startDate"
// @Param request query string false "endDate"
// @Param request query string false "limit"
// @Param request query string false "offset"
// @Success 200 {object} dto.HistoryResponse
// @Failure 400 {object} Response
// @Failure 402 {object} Response
// @Router /openauth/history [get]
func (hh *HistoryHandler) getHistory(ctx *gin.Context) {
	var req dto.HistoryRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		WriteError(ctx, customerrors.BAD_REQUEST_ERROR(err.Error()))
		return
	}
	if req.StartDate == 0 {
		req.StartDate = time.Now().Add(-time.Hour * 24 * 7).UnixMilli()
	}
	if req.EndDate == 0 {
		req.EndDate = time.Now().UnixMilli()
	}
	if req.Limit == 0 || req.Limit > 50 {
		req.Limit = 10
	}
	res, err := hh.service.GetHistory(ctx, &req)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, res)
}
