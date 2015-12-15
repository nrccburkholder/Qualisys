CREATE TABLE version (
	version_id VARCHAR(20) NOT NULL,
	url VARCHAR(1024) NOT NULL,
	file_name VARCHAR(50) NOT NULL,
	checksum VARCHAR(100) NOT NULL,
	created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (version_id)
);

CREATE TABLE version_request (
	client_id VARCHAR(50) NOT NULL,
	client_version VARCHAR(20) NOT NULL,
	provided_version VARCHAR(20) NOT NULL,
	request_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
