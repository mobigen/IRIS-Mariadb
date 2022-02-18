/* NOTE: 본 SQL script는 맨처음 스키마 생성용으로 사용합니다. */

CREATE DATABASE IF NOT EXISTS jhm DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE USER 'jhm'@'%' IDENTIFIED BY 'hello.jhm';

GRANT ALL PRIVILEGES ON jhm.* TO 'jhm'@'%';
