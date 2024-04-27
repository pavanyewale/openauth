package dto

import (
	"openauth/models/dao"
	"openauth/utils/customerrors"
)

type PermissionDetails struct {
	ID            int64  `json:"id"`
	Name          string `json:"name"`
	Description   string `json:"description"`
	CreatedByUser int64  `json:"createdByUser"`
	CreatedOn     int64  `json:"createdOn"`
	UpdatedOn     int64  `json:"updatedOn"`
}

type GetPermissionsResponse struct {
	Permissions []*PermissionDetails `json:"permissions"`
}

func (pd *PermissionDetails) FromPermission(perm *dao.Permission) *PermissionDetails {
	pd.ID = perm.ID
	pd.Name = perm.Name
	pd.Description = perm.Description
	pd.CreatedByUser = perm.CreatedByUser
	pd.CreatedOn = perm.CreatedOn
	pd.UpdatedOn = perm.UpdatedOn
	return pd
}

type PermissionDetailsShort struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

type CreatePermissionRequest struct {
	Name          string `json:"name"`
	Description   string `json:"description"`
	UpdatedByUser int64  `json:"-"`
}

func (c *CreatePermissionRequest) Validate() error {
	if c.Name == "" {
		return customerrors.BAD_REQUEST_ERROR("name is required")
	}
	if c.Description == "" {
		return customerrors.BAD_REQUEST_ERROR("description is required")
	}
	return nil
}

type DeletePermissionRequest struct {
	PermissionId  int64 `json:"permId"`
	UpdatedByUser int64 `json:"-"`
}

func (c *DeletePermissionRequest) Validate() error {
	if c.PermissionId <= 0 {
		return customerrors.BAD_REQUEST_ERROR("invalid permission id")
	}
	return nil
}

type AddRemovePermissionsToUserRequest struct {
	UserId          int64   `json:"userId"`
	PermissionIDs   []int64 `json:"permIds"`
	UpdatedbyUserId int64   `json:"-"`
}

func (c *AddRemovePermissionsToUserRequest) Validate() error {
	if c.UserId <= 0 {
		return customerrors.BAD_REQUEST_ERROR("invalid userId")
	}
	if len(c.PermissionIDs) == 0 {
		return customerrors.BAD_REQUEST_ERROR("permissionIds are required")
	}
	return nil
}

type AddRemovePermissionsToGroupRequest struct {
	GroupId         int64   `json:"groupId"`
	PermissionIDs   []int64 `json:"permIds"`
	UpdatedbyUserId int64   `json:"-"`
}

func (c *AddRemovePermissionsToGroupRequest) Validate() error {
	if c.GroupId <= 0 {
		return customerrors.BAD_REQUEST_ERROR("invalid groupId")
	}
	if len(c.PermissionIDs) == 0 {
		return customerrors.BAD_REQUEST_ERROR("permissionIds are required")
	}
	return nil
}
