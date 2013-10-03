DROP TABLE IF EXISTS users;
CREATE TABLE user (
    id INT(11) AUTO_INCREMENT,
    name VARCHAR(20),
    password VARCHAR(12),
    PRIMARY KEY(id));
INSERT INTO user VALUES (DEFAULT, 'joe', 'Password1'), (DEFAULT, 'chip', 'a');
