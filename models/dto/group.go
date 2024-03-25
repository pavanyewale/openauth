package dto

import (
	"openauth/models/dao"
	"openauth/utils/customerrors"
)

type GroupDetails struct {
	ID            int64  `json:"id"`
	Name          string `json:"name"`
	Description   string `json:"description"`
	CreatedByUser int64  `json:"createdByUser"`
	CreatedOn     int64  `json:"createdOn"`
	UpdatedOn     int64  `json:"updatedOn"`
}

func (gd *GroupDetails) FromGroup(group *dao.Group) *GroupDetails {
	gd.ID = group.ID
	gd.Name = group.Name
	gd.Description = group.Description
	gd.CreatedByUser = group.CreatedByUser
	gd.CreatedOn = group.CreatedOn
	gd.UpdatedOn = group.UpdatedOn
	return gd
}

type GroupDetailsShort struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

type DeleteGroupRequest struct {
	GroupId         int64 `json:"groupId"`
	UpdatedbyUserId int64 `json:"-"`
}

type CreateGroupRequest struct {
	Name            string `json:"name"`
	Description     string `json:"description"`
	UpdatedbyUserId int64  `json:"-"`
}

func (c *CreateGroupRequest) Validate() error {
	if c.Name == "" {
		return customerrors.BAD_REQUEST_ERROR("name cannot be empty")
	}

	if c.Description == "" {
		return customerrors.BAD_REQUEST_ERROR("description cannot be empty")
	}

	return nil
}

func (c *DeleteGroupRequest) Validate() error {
	if c.GroupId <= 0 {
		return customerrors.BAD_REQUEST_ERROR("invalid groupId")
	}
	return nil
}

type AddRemoveUsersToGroupRequest struct {
	GroupId         int64   `json:"groupId"`
	UserIds         []int64 `json:"userIds"`
	UpdatedByUserId int64   `json:"-"`
}

func (c *AddRemoveUsersToGroupRequest) Validate() error {
	if c.GroupId <= 0 {
		return customerrors.BAD_REQUEST_ERROR("invalid groupId")
	}
	if len(c.UserIds) == 0 {
		return customerrors.BAD_REQUEST_ERROR("userIds are required")
	}
	return nil
}
