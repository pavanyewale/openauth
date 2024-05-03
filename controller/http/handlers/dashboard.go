package handlers

import (
	"context"
	"openauth/models/dto"

	"github.com/gin-gonic/gin"
)

type DashboardHandler struct {
	service DashboardService
}

type DashboardService interface {
	GetDashboard(ctx context.Context) (*dto.DashboardResponse, error)
}

func NewDashboardHandler(service DashboardService) *DashboardHandler {
	return &DashboardHandler{service: service}
}

func (lh *DashboardHandler) Register(router gin.IRouter) {
	router.GET("/openauth/dashboard", lh.GetDashboard)
}

// @Summary Get dashboard details
// @Description Get dashboard details like total users, groups, permissions
// @Tags Dashboard
// @Accept json
// @Produce json
// @Param AuthToken header string true "Bearer {token}"
// @Success 200 {object} dto.DashboardResponse
// @Failure 400 {object} Response
// @Failure 401 {object} Response
// @Failure 403 {object} Response
// @Failure 404 {object} Response
// @Failure 500 {object} Response
// @Router /openauth/dashboard [get]
func (lh *DashboardHandler) GetDashboard(ctx *gin.Context) {
	dashboard, err := lh.service.GetDashboard(ctx)
	if err != nil {
		WriteError(ctx, err)
		return
	}
	WriteSuccess(ctx, dashboard)
}
