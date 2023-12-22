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
    birthday   date check ( extract(year from age(client.birthday))  > 4), --можно с 4х лет
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


-- task 4
set search_path = rental_service;
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
values (1, 'Степанида Васильева', 3, '89234160751');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (2, 'Агрофена Чебурашкина', 10, '89213416722');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (3, 'Геннадий Полотенцев', 6, '82222222222');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (4, 'Василий Грибников-Белкин', 2, '81923044567');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (5, 'Корней Копатычев', 14, '88112460999');
insert into rental_service.coach (coach_id, coach_name, experience, phone)
values (6, 'Капитолина Диванова', 7, '89009127741');
insert into rental_service.coach(coach_id, coach_name, experience, phone)
values (7, 'Прасковья Шоколадкина', 3, '89256178911');


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
--клиент взял коньки, потом вернул их и взял санки по скидке
insert into rental_service.occasion(occasion_id, service_id, client_id, datetime)
values (15, 1, 10, '19-01-2023 19:14:50');

delete
from rental_service.occasion
where occasion_id = 15;

insert into rental_service.occasion(occasion_id, service_id, client_id, promotion_id, datetime)
values (15, 7, 10, 4, '19-01-2023 19:20:03');

--добавить новую акцию
insert into rental_service.promotion (promotion_id, promotion_type_id, address_id, begin_t, end_t, promotion_name,
                                      promotion_type_name)
values (7, 1, 3, '01.01.2023', '01.02.2023', 'Не плати за третий сноуборд', '3 по цене 2');

--добавить нового клиента в табличку и вывести всех клиентов
insert into rental_service.client(client_id, address_id, name, surname, birthday, phone)
values (11, 2, 'Эндрю', 'Тейт', '11.11.1991', '89555559022');

select client_id, name, surname
from rental_service.client;

--удалить тренера, потом обновить таблицу и добавить нового тренера
delete
from rental_service.coach
where coach_id = 1; --уволили тренера 1

delete
from rental_service.address_x_coach
where coach_id = 1; --удалили его с адреса

insert into rental_service.coach(coach_id, coach_name, experience, phone) --приняли нового тренера по той же услуге, что и уволенный
values (1, 'Остап Подковыров', 23, '89998887766');

insert into rental_service.address_x_coach(coach_id, address_id)
values (1, 4); --поставили его на адрес 4

update rental_service.address_x_coach
set address_id = 2
where coach_id = 1;
--передумали и поставили на адрес 2

--изменили цену на пару услуг и обновили таблицу
update rental_service.service
set price = 1200
where service_id = 12;

update rental_service.service
set price = 800
where service_id = 10;

--продлили акцию
update rental_service.promotion
set end_t = '25.02.2023'
where promotion_id = 2;


--task 6
-- Вывести общую сумму трат каждого клиента, отсортировав по убыванию суммы
-- Если клиент не совершал покупок, то вывести 0
-- Формат: total_sum (общая сумма трат клиента), client_id, client (name + surname)
select coalesce(sum(s.price), 0)    as total_sum,
       cl.client_id,
       cl.name || ' ' || cl.surname as client
from client cl
         left join occasion o on cl.client_id = o.client_id
         left join service s on o.service_id = s.service_id
         left join promotion p on o.promotion_id = p.promotion_id
group by cl.client_id, cl.name, cl.surname
order by total_sum desc;

-- Вывести средний опыт тренеров на адресах, куда ходят более одного клиента, отсортировав по нему
-- Формат: address_id, address (street + house), avg_coach_exp (средний опыт тренеров)
select avg(c.experience)               as avg_coach_exp,
       ac.address_id,
       a.street || ', дом ' || a.house as address
from coach c
         join address_x_coach ac on c.coach_id = ac.coach_id
         join client cl on ac.address_id = cl.address_id
         join address a on ac.address_id = a.address_id
where ac.address_id in (select address_id
                        from client
                        group by address_id
                        having count(*) > 1)
group by ac.address_id, address
order by avg_coach_exp;

-- Вывести имена клиентов в алфавитном порядке, которые брали в аренду коньки после 15.12.2022
-- Формат: name, surname, occasion_id, datetime
select c.name, c.surname, o.occasion_id, o.datetime
from rental_service.client as c
         join rental_service.occasion as o on c.client_id = o.client_id
         join rental_service.service as s on o.service_id = s.service_id
where (s.naming = 'Коньки "Жизнь на острие"' or s.naming = 'Учимся быть лучшими фигуристами с Геннадием')
  and o.datetime > '15-12-2022 00:00:00'
order by c.surname;

-- Вывести название акции, которой пользовались наибольшее количество раз и количество раз,
-- когда эта акция была использована
-- Если таких акций несколько, то вывести все
-- Формат: promotion_name, count
with promotion_count as (select promotion.promotion_name,
                                COUNT(occasion.promotion_id) as count
                         from rental_service.occasion
                                  join rental_service.promotion on occasion.promotion_id = promotion.promotion_id
                         group by promotion.promotion_name),
     max_count as (select MAX(count) as max_c
                   from promotion_count)
select promotion_count.promotion_name,
       promotion_count.count
from promotion_count
         join max_count on promotion_count.count = max_count.max_c;

-- Вывести адреса от самого популярного к самому непопулярному
-- по количеству тренеров, которые работают по адресу
-- Формат: street, house, count
select street, house, count(axc.coach_id)
from rental_service.address a
         inner join rental_service.address_x_coach axc on a.address_id = axc.address_id
         inner join rental_service.coach c on axc.coach_id = c.coach_id
where (a.address_id = 1 or a.address_id = 2 or a.address_id = 3 or a.address_id = 4 or a.address_id = 5)
group by street, house
having count(axc.coach_id) > 0
order by count(axc.coach_id) desc;

-- Вывести имена клиентов, которые всегда пользуются услугами сервиса
-- во временном промежутке от 9 до 10 утра
-- Формат: name, surname
select name, surname
from rental_service.client c
         inner join rental_service.occasion o on c.client_id = o.client_id
where extract(hour from o.datetime) < '10'
  and extract(hour from o.datetime) >= '9'
group by name, surname
order by name;


--task7
-- create views
drop schema if exists rental_service_view cascade;
create schema rental_service_view;

set search_path = rental_service_view;

-- clients
drop view if exists clients;
create view clients as
select cl.name || ' ' || cl.surname                             as client,
       overlay(cl.phone::text placing '-***-***-' from 2 for 6) as phone,
       extract(year from age(cl.birthday))                      as age
from rental_service.client cl;

-- coaches
drop view if exists coaches;
create view coaches as
select c.coach_name                                            as coach,
       c.experience                                            as XP,
       overlay(c.phone::text placing '-***-***-' from 2 for 6) as phone
from rental_service.coach c
order by XP desc;

-- services
drop view if exists services;
create view services as
select s.naming,
       s.price
from rental_service.service s
order by s.price desc;

-- addresses
drop view if exists addresses;
create view addresses as
select a.street || ', дом ' || a.house                         as address,
       overlay(a.phone::text placing '-***-***-' from 2 for 6) as phone
from rental_service.address a
order by address desc;

-- promotions
drop view if exists promotions;
create view promotions as
select p.promotion_name    as naming,
       promotion_type_id   as type,
       p.begin_t           as starts,
       p.end_t             as ends,
       p.end_t - p.begin_t as duration
from rental_service.promotion p
order by p.begin_t;


--task 8
-- вывести общее число денег, сэкономленных каждым клиентом при использовании акций
-- отсортировать от клиента с самым большим накоплением до самого маленького
drop view if exists client_saving;
create view client_saving as
select cl.name || ' ' || cl.surname as client,
       sum(case
               when o.promotion_id is null
                   then 0
               when
                   o.promotion_id = 1 or o.promotion_id = 2 or o.promotion_id = 7
                   then s.price
               when
                   o.promotion_id = 3 or o.promotion_id = 6
                   then s.price * 0.1
               when o.promotion_id = 4
                   then s.price * 0.2
               when o.promotion_id = 5
                   then s.price * 0.35
           end)                     as total_saving
from rental_service.client cl
         inner join rental_service.occasion o on cl.client_id = o.client_id
         inner join rental_service.service s on o.service_id = s.service_id
         left join rental_service.promotion p on p.promotion_id = o.promotion_id
group by cl.name || ' ' || cl.surname
order by total_saving desc;

-- вывести прибыль по каждому адресу,
-- отсортировав от самого прибыльного адреса, к самому неприбыльному
drop view if exists address_profit;
create view address_profit as
select (street || ', дом ' || house) as full_address,
       sum(case
               when
                   o.promotion_id = 1 or o.promotion_id = 2 or o.promotion_id = 7
                   then 0
               when
                   o.promotion_id = 3 or o.promotion_id = 6
                   then s.price * 0.9
               when o.promotion_id = 4
                   then s.price * 0.8
               when o.promotion_id = 5
                   then s.price * 0.65
               when o.promotion_id is null
                   then s.price
           end)                      as total_address_profit
from rental_service.address a
         inner join rental_service.client c on a.address_id = c.address_id
         inner join rental_service.occasion o on c.client_id = o.client_id
         inner join rental_service.service s on o.service_id = s.service_id
         left join rental_service.promotion p on o.promotion_id = p.promotion_id
group by full_address
order by total_address_profit desc;

-- вывести количество затрат каждого клиента на услуги любого тренера
-- отсортировать от клиента с самыми большими затратами на тренера к самым маленьким
drop view if exists client_spent_coach;
create view client_spent_coach as
select cl.name || ' ' || cl.surname as client,
       ch.coach_name                as coach_name,
       sum(case
               when s.service_id >= 8 and o.promotion_id = 5
                   then s.price * 0.65
               when s.service_id >= 8
                   then s.price
           end)                     as spent_coach
from rental_service.client cl
         inner join rental_service.occasion o on cl.client_id = o.client_id
         inner join rental_service.service s on o.service_id = s.service_id
         inner join rental_service.service_x_coach sc on s.service_id = sc.service_id
         inner join rental_service.coach ch on sc.coach_id = ch.coach_id
group by cl.name || ' ' || cl.surname, ch.coach_name
order by spent_coach desc;

-- вывести прибыль, которую принесла каждая услуга
-- отсортировать от самой прибыльной услуги, к самой неприбыльной
drop view if exists service_profit;
create view service_profit as
select naming   as service_name,
       sum(case
               when
                   o.promotion_id = 1 or o.promotion_id = 2 or o.promotion_id = 7
                   then 0
               when
                   o.promotion_id = 3 or o.promotion_id = 6
                   then s.price * 0.9
               when o.promotion_id = 4
                   then s.price * 0.8
               when o.promotion_id = 5
                   then s.price * 0.65
               when o.promotion_id is null
                   then s.price
           end) as total_service_profit
from rental_service.service s
         inner join rental_service.occasion o on o.service_id = s.service_id
         left join rental_service.promotion p on o.promotion_id = p.promotion_id
group by service_name
order by total_service_profit desc;