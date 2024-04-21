package postgresql

import (
	"context"
	"openauth/models/dao"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
)

func (r *Repository) CreateGroup(ctx context.Context, group *dao.Group) error {
	// Prepare the SQL statement
	query := "INSERT INTO groups (name, description, created_by_user, created_on, updated_on, deleted) VALUES (?, ?, ?, ?, ?, ?)"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	_, err = stmt.ExecContext(ctx, group.Name, group.Description, group.CreatedByUser, group.CreatedOn, group.UpdatedOn, group.Deleted)
	if err != nil {
		logger.Error(ctx, "failed to execute query: Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}

	return nil
}

func (r *Repository) DeleteGroupById(ctx context.Context, id int64) error {
	// Prepare the SQL statement
	query := "DELETE FROM groups WHERE id = ?"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	_, err = stmt.ExecContext(ctx, id)
	if err != nil {
		logger.Error(ctx, "failed to execute query: Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}

	return nil
}

func (r *Repository) GetGroupById(ctx context.Context, id int64) (*dao.Group, error) {
	// Prepare the SQL statement
	query := "SELECT id, name, description, created_by_user, created_on, updated_on, deleted FROM groups WHERE id = ?"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	row := stmt.QueryRowContext(ctx, id)

	// Create a new Group struct to store the result
	group := &dao.Group{}

	// Scan the row into the Group struct
	err = row.Scan(&group.ID, &group.Name, &group.Description, &group.CreatedByUser, &group.CreatedOn, &group.UpdatedOn, &group.Deleted)
	if err != nil {
		logger.Error(ctx, "failed to scan records: Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}

	return group, nil
}

func (r *Repository) GetAllGroups(ctx context.Context, limit, offset int) ([]*dao.Group, error) {
	// Prepare the SQL statement
	query := "SELECT id, name, description, created_by_user, created_on, updated_on, deleted FROM groups LIMIT ? OFFSET ?"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	rows, err := stmt.QueryContext(ctx, limit, offset)
	if err != nil {
		logger.Error(ctx, "failed to execute query: Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer rows.Close()

	// Iterate over the rows and scan each row into a Group struct
	groups := []*dao.Group{}
	for rows.Next() {
		group := &dao.Group{}
		err := rows.Scan(&group.ID, &group.Name, &group.Description, &group.CreatedByUser, &group.CreatedOn, &group.UpdatedOn, &group.Deleted)
		if err != nil {
			return nil, err
		}
		groups = append(groups, group)
	}

	return groups, nil
}

func (r *Repository) GetGroupsByUserId(ctx context.Context, userId int64) ([]*dao.Group, error) {
	// Prepare the SQL statement
	query := "SELECT g.id, g.name, g.description, g.created_by_user, g.created_on, g.updated_on, g.deleted FROM groups g INNER JOIN user_groups ug ON g.id = ug.group_id WHERE ug.user_id = $1"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	rows, err := stmt.QueryContext(ctx, userId)
	if err != nil {
		logger.Error(ctx, "failed to execute query: Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer rows.Close()

	// Iterate over the rows and scan each row into a Group struct
	groups := []*dao.Group{}
	for rows.Next() {
		group := &dao.Group{}
		err := rows.Scan(&group.ID, &group.Name, &group.Description, &group.CreatedByUser, &group.CreatedOn, &group.UpdatedOn, &group.Deleted)
		if err != nil {
			return nil, err
		}
		groups = append(groups, group)
	}

	return groups, nil
}

func (r *Repository) CreateUserGroups(ctx context.Context, userGroups []*dao.UserGroup) error {
	// Start a transaction
	tx, err := r.conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// Prepare the SQL statement for inserting user groups
	query := "INSERT INTO user_groups (user_id, group_id, created_by_user, created_on, updated_on, deleted) VALUES (?, ?, ?, ?, ?, ?)"
	stmt, err := tx.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Insert each user group
	for _, userGroup := range userGroups {
		_, err := stmt.ExecContext(ctx, userGroup.UserId, userGroup.GroupId, userGroup.CreatedByUser, userGroup.CreatedOn, userGroup.UpdatedOn, userGroup.Deleted)
		if err != nil {
			logger.Error(ctx, "failed to execute query: Err: %s", err.Error())
			return customerrors.ERROR_DATABASE
		}
	}

	// Commit the transaction
	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}

func (r *Repository) DeleteUsersFromGroup(ctx context.Context, groupId int64, userIds []int64) error {
	// Start a transaction
	tx, err := r.conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// Prepare the SQL statement for deleting user group entries
	query := "DELETE FROM user_groups WHERE group_id = ? AND user_id = ?"
	stmt, err := tx.PrepareContext(ctx, query)
	if err != nil {
		return err
	}
	defer stmt.Close()

	// Delete each user from the group
	for _, userId := range userIds {
		_, err := stmt.ExecContext(ctx, groupId, userId)
		if err != nil {
			return err
		}
	}

	// Commit the transaction
	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}
