-- task 3
-- создание схемы
drop schema if exists rental_service cascade;
create schema rental_service;

set search_path = rental_service;

-- создание таблиц
drop table if exists service cascade;
create table service
(
    service_id integer primary key,
    naming     varchar(50) not null,
    price      integer     not null
);

drop table if exists address cascade;
create table address
(
    address_id integer primary key,
    street     varchar(50),
    house      varchar(10),
    phone      varchar(20) not null
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

drop table if exists coach cascade;
create table coach
(
    coach_id   integer primary key,
    coach_name text not null,
    experience integer,
    phone      varchar(20) unique
);

drop table if exists promotion cascade;
create table promotion
(
    promotion_id        integer primary key,
    address_id          integer not null,
    promotion_name      text    not null,
    promotion_type_id   integer not null,
    promotion_type_name text    not null,
    begin_t             date,
    end_t               date,

    foreign key (address_id) references address (address_id) on delete cascade
);

drop table if exists occasion cascade;
create table occasion
(
    occasion_id  integer primary key,
    service_id   integer   not null,
    client_id    integer   not null,
    promotion_id integer,
    datetime     timestamp not null,

    foreign key (client_id) references client (client_id) on delete cascade,
    foreign key (service_id) references service (service_id) on delete cascade,
    foreign key (promotion_id) references promotion (promotion_id) on delete cascade
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

drop table if exists service_x_coach cascade;
create table service_x_coach
(
    coach_id   integer not null,
    service_id integer not null,

    CONSTRAINT serv_X_coach_id PRIMARY KEY (coach_id, service_id),
    FOREIGN KEY (coach_id) REFERENCES coach (coach_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service (service_id) ON DELETE CASCADE
);

drop table if exists address_x_coach cascade;
create table address_x_coach
(
    coach_id   integer not null,
    address_id integer not null,

    CONSTRAINT ad_X_coach_id PRIMARY KEY (coach_id, address_id),
    FOREIGN KEY (coach_id) REFERENCES coach (coach_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE CASCADE
);