-- task 3
-- создание схемы
drop schema if exists rental_service cascade;
create schema rental_service;

set search_path = rental_service;

-- создание таблиц
drop table if exists client cascade;
create table client (
    client_id integer primary key,
    address_id integer not null,
    name varchar(50) not null,
    surname varchar(50),
    birthday date,
    phone varchar(20)
);

-- task 4
