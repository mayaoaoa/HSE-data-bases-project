-- task 3
-- создание схемы
drop schema if exists rental_service cascade;
create schema rental_service;

set search_path = rental_service;

-- создание таблиц
drop table if exists client cascade;
create table client
(
    client_id  integer primary key,
    address_id integer     not null,
    name       varchar(50) not null,
    surname    varchar(50),
    birthday   date,
    phone      varchar(20) unique
);

drop table if exists service cascade;
create table service
(
    service_id integer primary key,
    name       varchar(50) not null,
    price      integer     not null
);

drop table if exists occasion cascade;
create table occasion
(
    occasion_id integer primary key,
    client_id   integer   not null,
    datetime    timestamp not null
);

drop table if exists promotion cascade;
create table promotion
(
    promotion_id      integer primary key,
    client_id         integer not null,
    service_id        integer not null,
    promotion_type_id integer not null,
    begin_t           timestamp,
    end_t             timestamp,
    promotion_name    text
);


-- task 4
