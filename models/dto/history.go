package dto

// HistoryRequest struct

type HistoryRequest struct {
	//quuery params tags
	StartDate int64 `query:"startDate"`
	EndDate   int64 `query:"endDate"`
	Limit     int64 `query:"limit"`
	Offset    int64 `query:"offset"`
}

// History struct

type History struct {
	ID            int64  `json:"id"`
	Operation     string `json:"operation"`
	Data          string `json:"data"`
	CreatedByUser int64  `json:"createdByUser"`
	CreatedOn     int64  `json:"createdOn"`
}

type HistoryResponse struct {
	History []History `json:"history"`
}
