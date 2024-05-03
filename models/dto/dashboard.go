package dto

type DashboardRequest struct {
}

type DashboardResponse struct {
	Dashboards []Count `json:"dashboards"`
}

type Count struct {
	Total int64  `json:"total"`
	Type  string `json:"type"`
	Key   string `json:"key"`
}
