-- migrate:up

CREATE TABLE artist (
  artist_id serial PRIMARY KEY,
  email text
);

-- migrate:down

DROP TABLE artist;