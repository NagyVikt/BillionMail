-- Create the BillionMail and Roundcube databases
CREATE DATABASE billionmail;
CREATE DATABASE roundcube;

-- Create the BillionMail user (skip if created by POSTGRES_USER env variable)
DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'billionmail') THEN
      CREATE ROLE billionmail WITH LOGIN PASSWORD 'NauF7ysRYyt9HTOiOn4JjIAL3QcRZnzj';
   END IF;
END
$$;

-- Grant all privileges to the user on both DBs
GRANT ALL PRIVILEGES ON DATABASE billionmail TO billionmail;
GRANT ALL PRIVILEGES ON DATABASE roundcube TO billionmail;

-- Now connect to the billionmail DB and create the required tables
\connect billionmail

-- Table: domain
CREATE TABLE IF NOT EXISTS domain (
    domain varchar(255) NOT NULL,
    a_record varchar(255) NOT NULL DEFAULT '',
    mailboxes int NOT NULL DEFAULT 50,
    mailbox_quota BIGINT NOT NULL DEFAULT 5368709120,
    quota BIGINT NOT NULL DEFAULT 10737418240,
    rate_limit INT DEFAULT 12,
    create_time INT NOT NULL default 0,
    active SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (domain)
);

-- Table: mailbox
CREATE TABLE IF NOT EXISTS mailbox (
    username varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    password_encode varchar(255) NOT NULL,
    full_name varchar(255) NOT NULL,
    is_admin smallint NOT NULL DEFAULT 0,
    maildir varchar(255) NOT NULL,
    quota bigint NOT NULL DEFAULT 0,
    local_part varchar(255) NOT NULL,
    domain varchar(255) NOT NULL,
    create_time int NOT NULL default 0,
    update_time int NOT NULL default 0,
    active SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (username)
);

-- Table: alias
CREATE TABLE IF NOT EXISTS alias (
    address varchar(255) NOT NULL,
    goto text NOT NULL,
    domain varchar(255) NOT NULL,
    create_time int NOT NULL default 0,
    update_time int NOT NULL default 0,
    active smallint NOT NULL DEFAULT 1,
    PRIMARY KEY (address)
);

-- Table: alias_domain
CREATE TABLE IF NOT EXISTS alias_domain (
    alias_domain varchar(255) NOT NULL, 
    target_domain varchar(255) NOT NULL,
    create_time int NOT NULL default 0,
    update_time int NOT NULL default 0,
    active smallint NOT NULL DEFAULT 1,
    PRIMARY KEY (alias_domain)
);

-- You can add further BillionMail tables here as needed...

-- Done! Don't add Roundcube schema here; the container will create its own in the roundcube DB.
