-- task 3
-- создание схемы
drop schema if exists rental_service cascade;
create schema rental_service;

set search_path = rental_service, public;

-- создание таблиц
drop table if exists address cascade;
create table address
(
    address_id   integer primary key,
    address_name varchar(50) not null
);

drop table if exists service cascade;
create table service
(
    service_id integer primary key,
    naming     varchar(50) not null,
    price      integer     not null
);

drop table if exists client cascade;
create table client
(
    client_id  integer primary key,
    address_id integer     not null,
    name       varchar(50) not null,
    surname    varchar(50),
    birthday   date,
    phone      varchar(20) unique,

    foreign key (address_id) references address (address_id) on delete cascade
);

drop table if exists occasion cascade;
create table occasion
(
    occasion_id integer primary key,
    client_id   integer   not null,
    datetime    timestamp not null,

    foreign key (client_id) references client (client_id) on delete cascade
);

drop table if exists promotion_type cascade;
create table promotion_type
(
    promotion_type_id   integer primary key,
    promotion_type_name text not null
);

drop table if exists promotion cascade;
create table promotion
(
    promotion_id      integer primary key,
    promotion_type_id integer not null,
    begin_t           date,
    end_t             date,
    promotion_name    text    not null,

    foreign key (promotion_type_id) references promotion_type (promotion_type_id) on delete cascade
);

drop table if exists address_x_promotion_type cascade;
create table address_x_promotion_type
(
    address_id        integer not null,
    promotion_type_id integer not null,

    CONSTRAINT ad_X_prom_t_id PRIMARY KEY (address_id, promotion_type_id),
    FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_type_id) REFERENCES promotion_type (promotion_type_id) ON DELETE CASCADE
);

drop table if exists occasion_x_service cascade;
create table occasion_x_service
(
    occasion_id integer not null,
    service_id  integer not null,

    CONSTRAINT oc_X_serv_id PRIMARY KEY (occasion_id, service_id),
    FOREIGN KEY (occasion_id) REFERENCES occasion (occasion_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service (service_id) ON DELETE CASCADE
);

drop table if exists service_x_promotion cascade;
create table service_x_promotion
(
    service_id   integer not null,
    promotion_id integer not null,

    CONSTRAINT serv_X_prom_id PRIMARY KEY (service_id, promotion_id),
    FOREIGN KEY (service_id) REFERENCES service (service_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotion (promotion_id) ON DELETE CASCADE
);

drop table if exists client_x_promotion cascade;
create table client_x_promotion
(
    client_id    integer not null,
    promotion_id integer not null,

    CONSTRAINT cl_X_prom_id PRIMARY KEY (client_id, promotion_id),
    FOREIGN KEY (client_id) REFERENCES client (client_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotion (promotion_id) ON DELETE CASCADE
);

-- task 4
insert into rental_service.address(address_id, address_name)
VALUES (1, '3-я улица Строителей, дом 25'),
       (2, 'аллея Смурфиков, дом 3'),
       (3, 'улица Броненосоца дом 221а'),
       (4, 'Тисовая улица дом 4'),
       (5, 'переулок Столярный дом 5');

insert into rental_service.service(service_id, naming, price)
VALUES (1, 'Коньки "Жизнь на острие"', 500),
       (2, 'Ватрушка "Тубус-бубус"', 400),
       (3, 'Беговые лыжи "Лыжню, товарищ!"', 500),
       (4, 'Горные лыжи "С горки с ветерком"', 1000),
       (5, 'Сноуборд "Полет нормальный"', 1000),
       (6, 'Скандинавские палочки для ходьби "Попу не отбей!"', 200),
       (7, 'Санки и финские сани "Любишь кататься -- люби и саночки возить!"', 400);