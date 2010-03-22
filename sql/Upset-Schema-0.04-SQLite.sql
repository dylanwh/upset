-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Mar 21 21:21:16 2010
-- 


BEGIN TRANSACTION;

--
-- Table: meeting_calendar
--
DROP TABLE meeting_calendar;

CREATE TABLE meeting_calendar (
  meeting_calendar_id INTEGER PRIMARY KEY NOT NULL,
  year INTEGER NOT NULL,
  month INTEGER NOT NULL
);

CREATE UNIQUE INDEX year_month ON meeting_calendar (year, month);

--
-- Table: meeting_note_type
--
DROP TABLE meeting_note_type;

CREATE TABLE meeting_note_type (
  meeting_note_type_id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL
);

--
-- Table: meeting_type
--
DROP TABLE meeting_type;

CREATE TABLE meeting_type (
  meeting_type_id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  short_name VARCHAR(20) NOT NULL,
  rule text NOT NULL
);

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
-- Table: message
--
DROP TABLE message;

CREATE TABLE message (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id varchar(255) NOT NULL,
  parent_id integer,
  create_date datetime NOT NULL,
  text varchar(140) NOT NULL
);

CREATE INDEX message_idx_parent_id ON message (parent_id);

CREATE INDEX message_idx_user_id ON message (user_id);

--
-- Table: meeting
--
DROP TABLE meeting;

CREATE TABLE meeting (
  meeting_id INTEGER PRIMARY KEY NOT NULL,
  meeting_calendar_id INTEGER NOT NULL,
  meeting_type_id INTEGER NOT NULL,
  location TEXT NOT NULL,
  summary TEXT NOT NULL,
  time VARCHAR(255) NOT NULL
);

CREATE INDEX meeting_idx_meeting_calendar_id ON meeting (meeting_calendar_id);

CREATE INDEX meeting_idx_meeting_type_id ON meeting (meeting_type_id);

--
-- Table: meeting_note
--
DROP TABLE meeting_note;

CREATE TABLE meeting_note (
  meeting_note_id INTEGER PRIMARY KEY NOT NULL,
  meeting_id INTEGER NOT NULL,
  meeting_note_type_id INTEGER NOT NULL,
  content TEXT NOT NULL
);

CREATE INDEX meeting_note_idx_meeting_id ON meeting_note (meeting_id);

CREATE INDEX meeting_note_idx_meeting_note_type_id ON meeting_note (meeting_note_type_id);

COMMIT;
