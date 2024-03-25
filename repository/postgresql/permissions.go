package postgresql

import (
	"context"
	"openauth/models/dao"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

func (r *Repository) CreatePermission(ctx context.Context, permission *dao.Permission) error {
	_, err := r.conn.ExecContext(ctx, `
		INSERT INTO permissions (name, description, created_by_user, created_on, updated_on, deleted)
		VALUES ($1, $2, $3, $4, $5, $6)
	`, permission.Name, permission.Description, permission.CreatedByUser, permission.CreatedOn, permission.UpdatedOn, permission.Deleted)
	if err != nil {
		logger.Error(ctx, "failed to create permission, Err: %v", err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}

func (r *Repository) GetPermissionById(ctx context.Context, id int64) (*dao.Permission, error) {
	var permission dao.Permission
	row := r.conn.QueryRowContext(ctx, `
		SELECT id, "name", description, created_by_user, created_on, updated_on, deleted
		FROM permissions
		WHERE id = $1
	`, id)
	err := row.Scan(&permission.ID, &permission.Name, &permission.Description, &permission.CreatedByUser, &permission.CreatedOn, &permission.UpdatedOn, &permission.Deleted)
	if err != nil {
		logger.Error(ctx, "failed to get permission by id: %d, Err: %s", id, err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	return &permission, nil
}

func (r *Repository) DeletePermissionById(ctx context.Context, id int64) error {
	_, err := r.conn.ExecContext(ctx, `
		DELETE FROM permissions
		WHERE id = $1
	`, id)
	if err != nil {
		logger.Error(ctx, "failed to delete permission by id:%d, Err: %s", id, err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}

func (r *Repository) GetAllPermissions(ctx context.Context, limit, offset int) ([]*dao.Permission, error) {
	query := `
		SELECT id, "name", description, created_by_user, created_on, updated_on, deleted
		FROM permissions
		LIMIT $1 OFFSET $2
	`
	rows, err := r.conn.QueryContext(ctx, query, limit, offset)
	if err != nil {
		logger.Error(ctx, "failed to get all permissions: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer rows.Close()

	var permissions []*dao.Permission
	for rows.Next() {
		var permission dao.Permission
		err := rows.Scan(&permission.ID, &permission.Name, &permission.Description, &permission.CreatedByUser, &permission.CreatedOn, &permission.UpdatedOn, &permission.Deleted)
		if err != nil {
			logger.Error(ctx, "failed to scan permission row: %s", err.Error())
			return nil, customerrors.ERROR_DATABASE
		}
		permissions = append(permissions, &permission)
	}

	return permissions, nil
}

func (r *Repository) CreateGroupPermissions(ctx context.Context, perms []*dao.GroupPermission) error {
	// Implement your logic to create group permissions in the database
	return nil
}

func (r *Repository) GetPermissionsByGroupIds(ctx context.Context, groupIds []int64) ([]*dao.Permission, error) {
	// Implement your logic to get permissions by group IDs from the database
	return nil, nil
}

func (r *Repository) CreateUserPermissions(ctx context.Context, perms []*dao.UserPermission) error {
	// Implement your logic to create user permissions in the database
	return nil
}

func (r *Repository) GetPermissionsByUserId(ctx context.Context, userId int64) ([]*dao.Permission, error) {
	// Implement your logic to get permissions by user ID from the database
	return nil, nil
}

func (r *Repository) DeleteGroupPermissions(ctx context.Context, groupId int64, permIds []int64) error {
	// Implement your logic to delete group permissions from the database
	return nil
}

func (r *Repository) DeleteUserPermissions(ctx context.Context, userId int64, permIds []int64) error {
	// Implement your logic to delete user permissions from the database
	return nil
}
