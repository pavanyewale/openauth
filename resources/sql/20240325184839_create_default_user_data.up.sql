INSERT INTO permissions ("name",category, description, created_by_user, created_on, updated_on)
VALUES ('SUPER_USER','default', 'Permission to perform super user actions', 1, 0, 0);

INSERT INTO permissions ("name",category, description, created_by_user, created_on, updated_on)
VALUES ('EDIT_USER','default', 'Permission to edit user details', 1, 0, 0);

INSERT INTO permissions ("name",category, description, created_by_user, created_on, updated_on)
VALUES ('EDIT_PERMISSION','default', 'Permission to edit permissions', 1, 0, 0);

INSERT INTO permissions ("name",category, description, created_by_user, created_on, updated_on)
VALUES ('EDIT_GROUP','default', 'Permission to edit groups', 1, 0, 0);

INSERT INTO permissions ("name",category, description, created_by_user, created_on, updated_on)
VALUES ('ASSIGN_GROUP_PERMISSION', 'default', 'Permission to assign permissions to groups', 1, 0, 0);

INSERT INTO users (first_name, last_name, username, "password", created_by_user, created_on, updated_on)
VALUES ('Root', 'User', 'root', '$2a$10$GddcnkEBI3nH8p6Nj/DLsuuOInH5Vx8IwDejzZzCUKqQdDUAjjm82', 1, 0, 0); 

-- hashed password for 1234

INSERT INTO user_permissions (user_id, permission_id, created_by_user, created_on, updated_on)
SELECT u.id, p.id, 1, 0, 0
FROM users u
JOIN permissions p ON p.name = 'SUPER_USER'
WHERE u.username = 'root';
