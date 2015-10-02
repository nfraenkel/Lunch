CREATE TABLE IF NOT EXISTS history (
	history_id SERIAL PRIMARY KEY,
	venue_id int REFERENCES venues ON DELETE CASCADE,
	history_text VARCHAR,
	history_created TIMESTAMP without time zone default (now() at time zone 'utc')	
);
