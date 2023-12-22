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
    price      integer     not null default 500 check ( service.price > 0 )
);

drop table if exists address cascade;
create table address
(
    address_id integer primary key,
    street     varchar(50),
    house      varchar(10),
    phone      varchar(20) not null check ( phone ~ '^8[0-9]{10}$' )
);

drop table if exists client cascade;
create table client
(
    client_id  integer primary key,
    address_id integer     not null,
    name       varchar(50) not null,
    surname    varchar(50),
    birthday   date check ( extract(year from age(client.birthday)) > 4), --можно с 4х лет
    phone      varchar(20) unique check ( phone ~ '^8[0-9]{10}$' ),

    foreign key (address_id) references address (address_id) on delete cascade
);

drop table if exists coach cascade;
create table coach
(
    coach_id   integer primary key,
    coach_name text not null,
    experience integer check (coach.experience > 0 ),
    phone      varchar(20) unique check ( phone ~ '^8[0-9]{10}$' )
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
    end_t               date check ( promotion.end_t > promotion.begin_t ),

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

    constraint serv_X_prom_id primary key (service_id, promotion_id),
    foreign key (service_id) references service (service_id) on delete cascade,
    foreign key (promotion_id) references promotion (promotion_id) on delete cascade
);

drop table if exists service_x_coach cascade;
create table service_x_coach
(
    coach_id   integer not null,
    service_id integer not null,

    constraint serv_X_coach_id primary key (coach_id, service_id),
    foreign key (coach_id) references coach (coach_id) on delete cascade,
    foreign key (service_id) references service (service_id) on delete cascade
);

drop table if exists address_x_coach cascade;
create table address_x_coach
(
    coach_id   integer not null,
    address_id integer not null,

    constraint ad_X_coach_id primary key (coach_id, address_id),
    foreign key (coach_id) references coach (coach_id) on delete cascade,
    foreign key (address_id) references address (address_id) on delete cascade
);