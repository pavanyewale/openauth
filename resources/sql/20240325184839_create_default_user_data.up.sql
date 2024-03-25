INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on, deleted)
VALUES ('SUPER_USER', 'Permission to perform super user actions', 1, 0, 0, false);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on, deleted)
VALUES ('EDIT_USER', 'Permission to edit user details', 1, 0, 0, false);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on, deleted)
VALUES ('EDIT_PERMISSION', 'Permission to edit permissions', 1, 0, 0, false);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on, deleted)
VALUES ('EDIT_GROUP', 'Permission to edit groups', 1, 0, 0, false);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on, deleted)
VALUES ('ASSIGN_GROUP_PERMISSION', 'Permission to assign permissions to groups', 1, 0, 0, false);

INSERT INTO users (first_name, last_name, username, "password", mobile_verified, email_verified, created_by_user, created_on, updated_on, deleted)
VALUES ('Root', 'User', 'root', '1234', false, false, 1, 0, 0, false);

INSERT INTO user_permissions (user_id, permission_id, created_by_user, created_on, updated_on, deleted)
SELECT u.id, p.id, 1, 0, 0, false
FROM users u
JOIN permissions p ON p.name = 'SUPER_USER'
WHERE u.username = 'root';
