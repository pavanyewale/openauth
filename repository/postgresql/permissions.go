package postgresql

import (
	"context"
	"openauth/models/dao"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
	"time"

	"github.com/lib/pq"
)

func (r *Repository) CreatePermission(ctx context.Context, permission *dao.Permission) error {
	_, err := r.conn.ExecContext(ctx, `
		INSERT INTO permissions (name, category, description, created_by_user, created_on, updated_on, deleted)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
	`, permission.Name, permission.Category, permission.Description, permission.CreatedBy, permission.CreatedOn, permission.UpdatedOn, permission.Deleted)

	if err != nil {
		logger.Error(ctx, "failed to create permission, Err: %v", err.Error())
		return customerrors.ERROR_DATABASE
	}
	return nil
}

func (r *Repository) GetPermissionById(ctx context.Context, id int64) (*dao.Permission, error) {
	var permission dao.Permission
	row := r.conn.QueryRowContext(ctx, `
		SELECT id, "name", category, description, created_by_user, created_on, updated_on, deleted
		FROM permissions
		WHERE id = $1
	`, id)
	// check if record not found
	if row.Err() != nil {
		logger.Error(ctx, "failed to get permission by id: %d, Err: %s", id, row.Err().Error())
		return nil, customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
	}
	err := row.Scan(&permission.ID, &permission.Name, &permission.Category, &permission.Description, &permission.CreatedBy, &permission.CreatedOn, &permission.UpdatedOn, &permission.Deleted)
	if err != nil {
		logger.Error(ctx, "failed to get permission by id: %d, Err: %s", id, err.Error())
		return nil, parseError(err)
	}
	return &permission, nil
}

func (r *Repository) GetPermissionByName(ctx context.Context, name string) (*dao.Permission, error) {
	var permission dao.Permission
	row := r.conn.QueryRowContext(ctx, `
		SELECT id, "name", category, description, created_by_user, created_on, updated_on, deleted
		FROM permissions
		WHERE "name" = $1
	`, name)

	err := row.Scan(&permission.ID, &permission.Name, &permission.Category, &permission.Description, &permission.CreatedBy, &permission.CreatedOn, &permission.UpdatedOn, &permission.Deleted)
	if err != nil {
		logger.Error(ctx, "failed to get permission by name: %s, Err: %s", name, err.Error())
		return nil, parseError(err)
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
		return parseError(err)
	}
	return nil
}

func (r *Repository) GetAllPermissions(ctx context.Context, limit, offset int) ([]*dao.Permission, error) {
	query := `
		SELECT id, "name", category, description, created_by_user, created_on, updated_on, deleted
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
		err := rows.Scan(&permission.ID, &permission.Name, &permission.Category, &permission.Description, &permission.CreatedBy, &permission.CreatedOn, &permission.UpdatedOn, &permission.Deleted)
		if err != nil {
			logger.Error(ctx, "failed to scan permission row: %s", err.Error())
			return nil, customerrors.ERROR_DATABASE
		}
		permissions = append(permissions, &permission)
	}

	return permissions, nil
}

func (r *Repository) CreateGroupPermissions(ctx context.Context, perms []*dao.GroupPermission) error {
	tx, err := r.conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	stmt, err := tx.PrepareContext(ctx, "INSERT INTO group_permissions (group_id, permission_id, created_by_user, created_on, updated_on) VALUES ($1, $2, $3, $4, $5)")
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, perm := range perms {
		_, err := stmt.ExecContext(ctx, perm.GroupID, perm.PermissionID, perm.CreatedByUser, time.Now().UnixMilli(), time.Now().UnixMilli())
		if err != nil {
			return err
		}
	}

	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}

func (r *Repository) GetPermissionsByGroupIds(ctx context.Context, groupIds []int64) ([]*dao.Permission, error) {
	query := `
        SELECT p.id, p.name, p.category, p.description, p.created_by_user, p.created_on, p.updated_on, p.deleted
        FROM permissions p
        JOIN group_permissions gp ON p.id = gp.permission_id
        WHERE gp.group_id = ANY($1)
    `
	rows, err := r.conn.QueryContext(ctx, query, pq.Array(groupIds))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var permissions []*dao.Permission
	for rows.Next() {
		var perm dao.Permission
		err := rows.Scan(&perm.ID, &perm.Name, &perm.Category, &perm.Description, &perm.CreatedBy, &perm.CreatedOn, &perm.UpdatedOn, &perm.Deleted)
		if err != nil {
			return nil, err
		}
		permissions = append(permissions, &perm)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return permissions, nil
}

func (r *Repository) CreateUserPermissions(ctx context.Context, perms []*dao.UserPermission) error {
	tx, err := r.conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	stmt, err := tx.PrepareContext(ctx, "INSERT INTO user_permissions (user_id, permission_id, created_by_user, created_on, updated_on) VALUES ($1, $2, $3, $4, $5)")
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, perm := range perms {
		_, err := stmt.ExecContext(ctx, perm.UserId, perm.PermissionId, perm.CreatedByUser, time.Now().UnixMilli(), time.Now().UnixMilli())
		if err != nil {
			return err
		}
	}

	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}
func (r *Repository) GetPermissionsByUserId(ctx context.Context, userId int64) ([]*dao.Permission, error) {
	query := `
		SELECT DISTINCT p.id, p.name,p.category, p.description, p.created_by_user, p.created_on, p.updated_on, p.deleted
		FROM permissions p
		JOIN user_permissions up ON p.id = up.permission_id
		WHERE up.user_id = $1
		UNION
		SELECT DISTINCT p.id, p.name,p.category, p.description, p.created_by_user, p.created_on, p.updated_on, p.deleted
		FROM permissions p
		JOIN group_permissions gp ON p.id = gp.permission_id
		JOIN user_groups ug ON gp.group_id = ug.group_id
		WHERE ug.user_id = $1
	`
	rows, err := r.conn.QueryContext(ctx, query, userId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var permissions []*dao.Permission
	for rows.Next() {
		var perm dao.Permission
		err := rows.Scan(&perm.ID, &perm.Name, &perm.Category, &perm.Description, &perm.CreatedBy, &perm.CreatedOn, &perm.UpdatedOn, &perm.Deleted)
		if err != nil {
			return nil, err
		}
		permissions = append(permissions, &perm)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return permissions, nil
}

func (r *Repository) DeleteGroupPermissions(ctx context.Context, groupId int64, permIds []int64) error {
	tx, err := r.conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.ExecContext(ctx, "DELETE FROM group_permissions WHERE group_id = $1 AND permission_id = ANY($2)", groupId, pq.Array(permIds))
	if err != nil {
		return err
	}

	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}

func (r *Repository) DeleteUserPermissions(ctx context.Context, userId int64, permIds []int64) error {
	tx, err := r.conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.ExecContext(ctx, "DELETE FROM user_permissions WHERE user_id = $1 AND permission_id = ANY($2)", userId, pq.Array(permIds))
	if err != nil {
		return err
	}

	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}

// get permissions count
func (r *Repository) GetTotalPermissionCount(ctx context.Context) (int64, error) {
	var count int64
	err := r.conn.QueryRowContext(ctx, "SELECT count(*) FROM permissions").Scan(&count)
	if err != nil {
		logger.Error(ctx, "failed to get permissions count: %v", err.Error())
		return 0, customerrors.ERROR_DATABASE
	}
	return count, nil
}
