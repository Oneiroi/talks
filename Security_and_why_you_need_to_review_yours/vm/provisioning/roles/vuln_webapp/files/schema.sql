-- Copyright 2013 Percona LLC / David Busby
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT(11) AUTO_INCREMENT,
    name VARCHAR(20),
    password VARCHAR(12),
    PRIMARY KEY(id));
INSERT INTO users VALUES (DEFAULT, 'joe', 'Password1'), (DEFAULT, 'chip', 'a');
