DELETE FROM users WHERE username = 'root';

DELETE FROM permissions WHERE "name" = 'SUPER_USER';
DELETE FROM permissions WHERE "name" = 'EDIT_USER';
DELETE FROM permissions WHERE "name" = 'EDIT_PERMISSION';
DELETE FROM permissions WHERE "name" = 'EDIT_GROUP';
DELETE FROM permissions WHERE "name" = 'ASSIGN_GROUP_PERMISSION';