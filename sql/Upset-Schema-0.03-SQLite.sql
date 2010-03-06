-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Mar  6 00:49:26 2010
-- 


BEGIN TRANSACTION;

--
-- Table: list
--
DROP TABLE list;

CREATE TABLE list (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL
);

CREATE UNIQUE INDEX name_unique ON list (name);

--
-- Table: user
--
DROP TABLE user;

CREATE TABLE user (
  url VARCHAR(255) NOT NULL,
  realname VARCHAR(100),
  nick VARCHAR(15),
  roles TEXT NOT NULL DEFAULT 'user',
  PRIMARY KEY (url)
);

CREATE UNIQUE INDEX user_nick_unique ON user (nick);

--
-- Table: event
--
DROP TABLE event;

CREATE TABLE event (
  id INTEGER PRIMARY KEY NOT NULL,
  user_url VARCHAR(255) NOT NULL,
  datetime datetime NOT NULL,
  duration INTEGER
);

CREATE INDEX event_idx_user_url ON event (user_url);

--
-- Table: message
--
DROP TABLE message;

CREATE TABLE message (
  id INTEGER PRIMARY KEY NOT NULL,
  date datetime NOT NULL,
  list INTEGER NOT NULL,
  author TEXT NOT NULL,
  subject TEXT NOT NULL,
  content BIGTEXT NOT NULL,
  content_type TEXT,
  message_id TEXT NOT NULL
);

CREATE INDEX message_idx_list ON message (list);

CREATE UNIQUE INDEX message_id_unique ON message (message_id);

COMMIT;
