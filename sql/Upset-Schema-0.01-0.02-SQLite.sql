-- Convert schema 'sql/Upset-Schema-0.01-SQLite.sql' to 'sql/Upset-Schema-0.02-SQLite.sql':;

BEGIN;

ALTER TABLE user ADD COLUMN user_name TEXT;

CREATE UNIQUE INDEX user_name_unique02 ON user (user_name);


COMMIT;

