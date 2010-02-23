CREATE TABLE message (
    id           INTEGER PRIMARY KEY,
    sender       TEXT NOT NULL,
    subject      TEXT NOT NULL,
    content      BIGTEXT NOT NULL,
    content_type TEXT,
    message_id   TEXT NOT NULL UNIQUE
);

CREATE TABLE subscriber (
    id         INTEGER PRIMARY KEY,
    message    INTEGER NOT NULL REFERENCES message (id),
    subscriber TEXT NOT NULL
);
