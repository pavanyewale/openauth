INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on)
VALUES ('SUPER_USER', 'Permission to perform super user actions', 1, 0, 0);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on)
VALUES ('EDIT_USER', 'Permission to edit user details', 1, 0, 0);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on)
VALUES ('EDIT_PERMISSION', 'Permission to edit permissions', 1, 0, 0);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on)
VALUES ('EDIT_GROUP', 'Permission to edit groups', 1, 0, 0);

INSERT INTO permissions ("name", description, created_by_user, created_on, updated_on)
VALUES ('ASSIGN_GROUP_PERMISSION', 'Permission to assign permissions to groups', 1, 0, 0);

INSERT INTO users (first_name, last_name, username, "password", created_by_user, created_on, updated_on)
VALUES ('Root', 'User', 'root', '1234', 1, 0, 0);

INSERT INTO user_permissions (user_id, permission_id, created_by_user, created_on, updated_on)
SELECT u.id, p.id, 1, 0, 0
FROM users u
JOIN permissions p ON p.name = 'SUPER_USER'
WHERE u.username = 'root';
