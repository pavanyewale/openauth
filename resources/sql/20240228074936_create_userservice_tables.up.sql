
CREATE TABLE IF NOT EXISTS users (
	id bigserial NOT NULL,
	first_name varchar(30) NOT NULL DEFAULT '',
	middle_name varchar(30) NOT NULL DEFAULT '',
	last_name varchar(30) NOT NULL DEFAULT '',
	username varchar(30) NOT NULL DEFAULT '',
	bio varchar(250) NOT NULL DEFAULT '',
	"password" varchar(250) NOT NULL DEFAULT '',
	mobile varchar(15) NOT NULL DEFAULT '',
	email varchar(50) NOT NULL DEFAULT '',
	mobile_verified bool NOT NULL DEFAULT false,
	email_verified bool NOT NULL DEFAULT false,
	created_by_user int8 NOT NULL DEFAULT 0,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	deleted bool NOT NULL DEFAULT false,
	CONSTRAINT users_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS sessions (
	id bigserial NOT NULL,
	user_id int8 NOT NULL,
	"token" varchar(300) NOT NULL,
	expriry_date timestamptz NOT NULL,
	logged_out bool NOT NULL DEFAULT false,
	permissions bool NOT null DEFAULT false,
	device_details varchar(255) NOT NULL default '',
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
	category varchar(30) NOT NULL,
	description text NULL,
	created_by_user int8 NULL,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	deleted bool NOT NULL default false, 
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
	deleted bool NOT null default false,
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
	deleted bool not null default FALSE,
	CONSTRAINT user_groups_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS group_permissions (
	id bigserial NOT NULL,
	group_id int8 NULL,
	permission_id int8 NULL,
	created_by_user int8 NULL,
	created_on int8 NOT NULL,
	updated_on int8 NOT NULL,
	deleted bool NOT NULL default false,
	CONSTRAINT group_permissions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS user_permissions (
	user_id int8 NULL,
	permission_id int8 NULL,
	created_by_user int8 NULL,
	created_on int8 NULL,
	updated_on int8 NULL,
	CONSTRAINT user_permissions_pkey PRIMARY KEY (user_id,permission_id)
);

CREATE TABLE IF NOT EXISTS history (
  id bigserial NOT NULL,
  operation VARCHAR(255) NOT NULL,
  data TEXT NOT NULL,
  created_by int8 NOT NULL,
  created_on int8 NOT NULL
  );

-- CREATE UNIQUE INDEX IF NOT EXISTS unique_user_permission ON user_permissions USING btree (user_id, permission_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_group_permission ON group_permissions USING btree (group_id, permission_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_user_group ON user_groups USING btree (user_id, group_id);
