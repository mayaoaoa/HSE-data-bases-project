-- task 3
-- создание схемы
drop schema if exists rental_service cascade;
create schema rental_service;

set search_path = rental_service, public;

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


-- task 4
set datestyle = 'DMY';


insert into rental_service.address(address_id, street, house, phone)
VALUES (1, '3-я улица Строителей', '25', '89617298345'),
       (2, 'аллея Смурфиков', '3', '89617293445'),
       (3, 'улица Броненосоца', '221a', '89433430555'),
       (4, 'Тисовая улица', '4', '88005553535'),
       (5, 'переулок Столярный', '5', '87776663322');


insert into rental_service.service(service_id, naming, price)
VALUES (1, 'Коньки "Жизнь на острие"', 500),
       (2, 'Ватрушка "Тубус-бубус"', 400),
       (3, 'Беговые лыжи "Лыжню, товарищ!"', 500),
       (4, 'Горные лыжи "С горки с ветерком"', 1000),
       (5, 'Сноуборд "Полет нормальный"', 1000),
       (6, 'Скандинавские палочки для ходьбы "Попу не отбей!"', 200),
       (7, 'Санки и финские сани "Люби и саночки возить!"', 400);

insert into rental_service.service(service_id, naming, price)
VALUES (8, 'Учимся быть лучшими фигуристами с Геннадием', 1200),   --коньки
       (9, 'Будь на высоте выше дивана с Дивановой', 1100),        --сноуборд
       (10, 'Научись правильно ходить, даже не за грибами!', 500), --ходьба с палками
       (11, 'Уроки лыж', 800),                                     --беговые лыжи
       (12, 'Научись летать', 1450); --горные лыжи


insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (1, 1, 'Маша', 'Сергеева', '12.12.2012', '89213659022');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (2, 1, 'Василиса', 'Васильева', '05.10.1998', '89280923677');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (3, 1, 'Петя', 'Дмитриев', '09.03.1978', '89229002277');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (4, 2, 'Степанида', 'Дубровская', '29.08.2000', '89134657188');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (5, 3, 'Василиса', 'Горькая', '20.09.1950', '89026337890');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (6, 3, 'Вася', 'Пупкин', '10.02.1980', '89290234675');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (7, 3, 'Акакий', 'Сергеев', '16.10.2010', '89220007861');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (8, 4, 'Наташа', 'Ростова', '21.06.1975', '89219017833');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (9, 4, 'Александр', 'Дюма', '31.01.1965', '89219200471');
insert into rental_service.client (client_id, address_id, name, surname, birthday, phone)
values (10, 5, 'Федя', 'Шишкин', '11.11.2011', '89239018821');


insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (1, 'Степанида Васильева', 3, '+79234160751');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (2, 'Агрофена Чебурашкина', 10, '+79213416722');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (3, 'Геннадий Полотенцев', 6, '82222222222');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (4, 'Василий Грибников-Белкин', 2, '81923044567');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (5, 'Корней Копатычев', 14, '+78112460999');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (6, 'Капитолина Диванова', 7, '89009127741');
insert into rental_service.coach(coach_id, coach_name, experience, phone)
values (7, 'Прасковья Шоколадкина', 3, '+7925617891');


insert into rental_service.service_x_coach(coach_id, service_id)
values (1, 12);
insert into rental_service.service_x_coach(coach_id, service_id)
values (2, 12);
insert into rental_service.service_x_coach(coach_id, service_id)
values (3, 8);
insert into rental_service.service_x_coach(coach_id, service_id)
values (4, 10);
insert into rental_service.service_x_coach(coach_id, service_id)
values (5, 11);
insert into rental_service.service_x_coach(coach_id, service_id)
values (6, 9);
insert into rental_service.service_x_coach(coach_id, service_id)
values (7, 11);


insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (1, 1, 3, '10.12.2022', '01.01.2023', 'Не плати за третьи коньки', '3 по цене 2');
insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (2, 1, 1, '15.01.2022', '15.02.2022', 'Взяли в аренду беговые лыжи и коньки? Аренда ватрушки в подарок',
        '3 по цене 2');
insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (3, 2, 2, '01.12.2022', '28.02.2023',
        'Посетителям старше 60 лет скидка на прокат палок для скандинавской ходьбы', 'Скидка по возрасту');
insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (4, 2, 1, '01.12.2022', '28.02.2023', 'Детям прокат санок и ватрушек делешевле на 20%', 'Скидка по возрасту');
insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (5, 4, 5, '01.01.2023', '31.01.2023', 'Скидка 35% на аренду любых лыж (с тренером или без)', 'Скидка k%');
insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (6, 3, 4, '01.02.2023', '27.02.2023',
        'Кто рано встает, тому сноуборд со скидкой 10% - успей оформить аренду до 10:00 и будет тебе счастье',
        'Скидка по времени');

insert into rental_service.service_x_promotion(service_id, promotion_id)
values (1, 1);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (1, 2);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (3, 2);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (2, 2);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (6, 3);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (2, 4);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (7, 4);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (3, 5);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (4, 5);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (11, 5);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (12, 5);
insert into rental_service.service_x_promotion(service_id, promotion_id)
values (5, 6);

insert into rental_service.occasion(occasion_id, client_id, service_id, promotion_id, datetime)
values (1, 4, 11, 5, '05-01-2023 10:03:54');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (2, 6, 1, '12-12-2022 14:44:03');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (3, 6, 1, '17-12-2022 15:09:51');
insert into rental_service.occasion(occasion_id, client_id, service_id, promotion_id, datetime)
values (4, 5, 6, 3, '01-02-2023 9:30:01');
insert into rental_service.occasion(occasion_id, client_id, service_id, promotion_id, datetime)
values (5, 2, 5, 6, '04-02-2023 9:47:32');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (6, 2, 9, '04-02-2023 9:47:32');
insert into rental_service.occasion(occasion_id, client_id, service_id, promotion_id, datetime)
values (7, 6, 1, 1, '21-12-2022 12:04:21');
insert into rental_service.occasion(occasion_id, client_id, service_id, promotion_id, datetime)
values (8, 1, 2, 4, '27-01-2023 17:41:08');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (9, 9, 4, '08-01-2023 11:04:42');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (10, 9, 3, '08-01-2023 13:10:22');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (11, 9, 11, '08-01-2023 13:10:22');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (12, 5, 10, '12-01-2023 15:11:33');
insert into rental_service.occasion(occasion_id, client_id, service_id, datetime)
values (13, 3, 8, '06-02-2023 11:10:05');
insert into rental_service.occasion(occasion_id, client_id, service_id, promotion_id, datetime)
values (14, 10, 12, 5, '11-02-2023 11:02:23');


insert into rental_service.address_x_coach(coach_id, address_id)
values (1, 2);
insert into rental_service.address_x_coach(coach_id, address_id)
values (2, 5);
insert into rental_service.address_x_coach(coach_id, address_id)
values (3, 1);
insert into rental_service.address_x_coach(coach_id, address_id)
values (4, 3);
insert into rental_service.address_x_coach(coach_id, address_id)
values (5, 4);
insert into rental_service.address_x_coach(coach_id, address_id)
values (6, 2);
insert into rental_service.address_x_coach(coach_id, address_id)
values (7, 4);

--task 5
-- клиент взял коньки, потом вернул их и взял санки по скидке
insert into rental_service.occasion(occasion_id, service_id, client_id, datetime)
values (15, 1, 10, '19-01-2023 19:14:50');

delete from rental_service.occasion where occasion_id = 15;

insert into rental_service.occasion(occasion_id, service_id, client_id, promotion_id, datetime)
values (15, 7, 10, 4, '19-01-2023 19:20:03');


--добавить новую акцию
insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (7, 1, 3, '01.01.2023', '01.02.2023', 'Не плати за третий сноуборд', '3 по цене 2');

