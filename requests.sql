-- task 3
-- создание схемы
drop schema if exists rental_service cascade;
create schema rental_service;

set search_path = rental_service;

-- создание таблиц todo all foreign keys
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
    naming     varchar(50) not null,
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
    promotion_name    text    not null
);

drop table if exists address cascade;
create table address
(
    address_id   integer primary key,
    address_name varchar(50) not null
);

drop table if exists promotion_type cascade;
create table promotion_type
(
    promotion_type_id   integer primary key,
    promotion_type_name text not null
);

drop table if exists occasion_x_service cascade;
create table occasion_x_service
(
    occasion_id integer, --todo
    service_id  integer  --todo
);

drop table if exists address_x_promotion_type cascade;
create table address_x_promotion_type
(
    address_id        integer, --todo
    promotion_type_id integer  --todo
);

drop table if exists service_x_promotion_type cascade;
create table service_x_promotion_type
(
    service_id        integer, --todo
    promotion_type_id integer  --todo
);

drop table if exists client_x_promotion cascade;
create table client_x_promotion
(
    client_id    integer, --todo
    promotion_id integer  --todo
);

-- task 4
