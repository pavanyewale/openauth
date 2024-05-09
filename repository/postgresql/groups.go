package postgresql

import (
	"context"
	"database/sql"
	"openauth/models/dao"
	"openauth/models/filters"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
	"time"
)

func (r *Repository) CreateGroup(ctx context.Context, group *dao.Group) error {
	group.CreatedOn = time.Now().UnixMilli()
	group.UpdatedOn = time.Now().UnixMilli()
	// Prepare the SQL statement
	query := "INSERT INTO groups (name, description, created_by_user, created_on, updated_on, deleted) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	res := stmt.QueryRowContext(ctx, group.Name, group.Description, group.CreatedByUser, group.CreatedOn, group.UpdatedOn, group.Deleted)
	if res.Err() != nil {
		logger.Error(ctx, "failed to execute query: Err: %s", res.Err().Error())
		return customerrors.ERROR_DATABASE
	}

	// Get the ID of the newly inserted group
	err = res.Scan(&group.ID)
	if err != nil {
		logger.Error(ctx, "failed to scan records: Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}

	return nil
}

func (r *Repository) DeleteGroupById(ctx context.Context, id int64) error {
	// Prepare the SQL statement
	query := "DELETE FROM groups WHERE id = $1"
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
	query := "SELECT id, name, description, created_by_user, created_on, updated_on, deleted FROM groups WHERE id = $1"
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

func (r *Repository) GetGroupsByFilter(ctx context.Context, filter *filters.GroupFilter, limit, offset int) ([]*dao.Group, error) {
	// Prepare the SQL statement
	query := "SELECT id, name, description, created_by_user, created_on, updated_on, deleted FROM groups WHERE 1=1"
	if filter.Name != "" {
		query += " AND name like '%" + filter.Name + "%'"
	}
	query += " LIMIT $1 OFFSET $2"
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
	query := "INSERT INTO user_groups (user_id, group_id, created_by_user, created_on, updated_on, deleted) VALUES ($1, $2, $3, $4, $5, $6)"
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
	query := "DELETE FROM user_groups WHERE group_id = $1 AND user_id = $2"
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

// get count of groups
func (r *Repository) GetTotalGroupCount(ctx context.Context) (int64, error) {
	var count int64
	err := r.conn.QueryRowContext(ctx, "SELECT count(*) FROM groups").Scan(&count)
	if err != nil {
		logger.Error(ctx, "failed to get groups count: %v", err.Error())
		return 0, customerrors.ERROR_DATABASE
	}
	return count, nil
}

// get group by filter

func (r *Repository) GetGroupByFilter(ctx context.Context, filter *filters.GroupFilter) (*dao.Group, error) {
	// Prepare the SQL statement
	query := "SELECT id, name, description, created_by_user, created_on, updated_on, deleted FROM groups WHERE 1=1"
	if filter.Name != "" {
		query += " AND name ='" + filter.Name + "'"
	}
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	row := stmt.QueryRowContext(ctx)

	// Create a new Group struct to store the result
	group := &dao.Group{}

	// Scan the row into the Group struct
	err = row.Scan(&group.ID, &group.Name, &group.Description, &group.CreatedByUser, &group.CreatedOn, &group.UpdatedOn, &group.Deleted)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, customerrors.ERROR_DATABASE_RECORD_NOT_FOUND
		}
		logger.Error(ctx, "failed to scan records: Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}

	return group, nil
}

// update group
func (r *Repository) UpdateGroup(ctx context.Context, group *dao.Group) error {
	group.UpdatedOn = time.Now().UnixMilli()
	// Prepare the SQL statement
	query := "UPDATE groups SET name=$1, description=$2, created_by_user=$3, created_on=$4, updated_on=$5, deleted=$6 WHERE id=$7"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	_, err = stmt.ExecContext(ctx, group.Name, group.Description, group.CreatedByUser, group.CreatedOn, group.UpdatedOn, group.Deleted, group.ID)
	if err != nil {
		logger.Error(ctx, "failed to execute query: Err: %s", err.Error())
		return customerrors.ERROR_DATABASE
	}

	return nil
}

// GetUsersByGroupId implements repository.Repository.
func (r *Repository) GetUsersByGroupId(ctx context.Context, groupId int64) ([]*dao.User, error) {
	// Prepare the SQL statement
	query := "SELECT u.id, first_name, middle_name, last_name, username, bio, password, mobile, email, mobile_verified, email_verified, u.created_by_user, u.created_on, u.updated_on ,u.deleted FROM users u INNER JOIN user_groups ug ON u.id = ug.user_id WHERE ug.group_id = $1"
	stmt, err := r.conn.PrepareContext(ctx, query)
	if err != nil {
		logger.Error(ctx, "failed to prepare the statements: query: %s, Err: %s ", query, err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer stmt.Close()

	// Execute the SQL statement
	rows, err := stmt.QueryContext(ctx, groupId)
	if err != nil {
		logger.Error(ctx, "failed to execute query: Err: %s", err.Error())
		return nil, customerrors.ERROR_DATABASE
	}
	defer rows.Close()

	// Iterate over the rows and scan each row into a User struct
	users := make([]*dao.User, 0)
	for rows.Next() {
		var user dao.User
		err := rows.Scan(&user.ID, &user.FirstName, &user.MiddleName, &user.LastName, &user.Username, &user.Bio, &user.Password, &user.Mobile, &user.Email, &user.MobileVerified, &user.EmailVerified, &user.CreatedByUser, &user.CreatedOn, &user.UpdatedOn, &user.Deleted)
		if err != nil {
			logger.Error(ctx, "failed to get user by groupId, Err: %s", err.Error())
			return nil, customerrors.ERROR_DATABASE
		}
		users = append(users, &user)
	}
	return users, nil
}
