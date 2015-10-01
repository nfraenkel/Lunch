CREATE TABLE IF NOT EXISTS users (
	user_id SERIAL PRIMARY KEY,
	user_email VARCHAR NOT NULL,
	user_first_name VARCHAR NOT NULL,
	user_last_name VARCHAR NOT NULL,
	user_photo VARCHAR NOT NULL,
	user_created TIMESTAMP without time zone default (now() at time zone 'utc')
);

CREATE TABLE IF NOT EXISTS venues (
	venue_id SERIAL PRIMARY KEY,
	venue_name VARCHAR NOT NULL,
	venue_type VARCHAR NOT NULL,
	venue_photo VARCHAR DEFAULT '',
	venue_location VARCHAR NOT NULL,
	venue_created TIMESTAMP without time zone default (now() at time zone 'utc')
);


CREATE TABLE IF NOT EXISTS choices (
	user_id int REFERENCES users ON DELETE CASCADE,
	venue_id int REFERENCES venues ON DELETE CASCADE,
	PRIMARY KEY(user_id, venue_id),
	choice_created TIMESTAMP without time zone default (now() at time zone 'utc')
);
