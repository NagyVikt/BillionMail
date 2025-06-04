-- ~/BillionMail/init.sql

-- 1) Create the “billionmail” role
CREATE ROLE billionmail WITH LOGIN SUPERUSER PASSWORD 'NauF7ysRYyt9HTOiOn4JjIAL3QcRZnzj';

-- 2) Create the “billionmail” database owned by that role
CREATE DATABASE billionmail OWNER billionmail;

-- 3) Switch into “billionmail” DB
\connect billionmail

-- 4) Create the four tables your app needs:
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

CREATE TABLE IF NOT EXISTS alias (
    address varchar(255) NOT NULL,
    goto text NOT NULL,
    domain varchar(255) NOT NULL,
    create_time int NOT NULL default 0,
    update_time int NOT NULL default 0,
    active smallint NOT NULL DEFAULT 1,
    PRIMARY KEY (address)
);

CREATE TABLE IF NOT EXISTS alias_domain (
    alias_domain varchar(255) NOT NULL,
    target_domain varchar(255) NOT NULL,
    create_time int NOT NULL default 0,
    update_time int NOT NULL default 0,
    active smallint NOT NULL DEFAULT 1,
    PRIMARY KEY (alias_domain)
);
