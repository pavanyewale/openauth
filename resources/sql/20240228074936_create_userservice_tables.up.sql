
CREATE TABLE IF NOT EXISTS users (
	id bigserial NOT NULL,
	first_name varchar(30) NULL,
	middle_name varchar(30) NULL,
	last_name varchar(30) NULL,
	username varchar(30) NULL,
	bio varchar(250) NULL,
	"password" varchar(250) NULL,
	mobile varchar(15) NULL,
	email varchar(50) NULL,
	mobile_verified bool NULL,
	email_verified bool NULL,
	created_by_user int8 NULL,
	created_on int8 NULL,
	updated_on int8 NULL,
	deleted bool NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id),
	CONSTRAINT users_username_key UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS sessions (
	id bigserial NOT NULL,
	user_id int8 NOT NULL,
	"token" varchar(300) NOT NULL,
	expriry_date timestamptz NOT NULL,
	logged_out bool NOT NULL,
	permissions bool NOT NULL,
	device_details varchar(255) NOT NULL,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	CONSTRAINT sessions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS otps (
	id bigserial NOT NULL,
	sent_to varchar(50) NOT NULL,
	otp varchar(6) NOT NULL,
	expriry int8 NOT NULL,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	CONSTRAINT otps_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS permissions (
	id bigserial NOT NULL,
	"name" varchar(30) NOT NULL,
	description text NULL,
	created_by_user int8 NULL,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	deleted bool NOT NULL,
	CONSTRAINT permissions_name_key UNIQUE (name),
	CONSTRAINT permissions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "groups" (
	id bigserial NOT NULL,
	"name" varchar(50) NOT NULL,
	description varchar(255) NOT NULL,
	created_by_user int8 NULL,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	deleted bool NOT NULL,
	CONSTRAINT groups_name_key UNIQUE (name),
	CONSTRAINT groups_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS user_groups (
	id bigserial NOT NULL,
	user_id int8 NULL,
	group_id int8 NULL,
	created_by_user int8 NULL,
	created_on int8 NULL,
	updated_on int8 NULL,
	deleted bool NULL,
	CONSTRAINT user_groups_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS group_permissions (
	id bigserial NOT NULL,
	group_id int8 NULL,
	permission_id int8 NULL,
	created_by_user int8 NULL,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	deleted bool NOT NULL,
	CONSTRAINT group_permissions_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS user_permissions (
	id bigserial NOT NULL,
	user_id int8 NULL,
	permission_id int8 NULL,
	created_by_user int8 NULL,
	created_on int8 NULL,
	updated_on int8 NULL,
	deleted bool NULL,
	CONSTRAINT user_permissions_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IF NOT EXISTS unique_user_permission ON user_permissions USING btree (user_id, permission_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_group_permission ON group_permissions USING btree (group_id, permission_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_user_group ON user_groups USING btree (user_id, group_id);
