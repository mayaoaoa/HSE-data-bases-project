--task 5
set search_path = rental_service;

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
values (1, 'Остап Подковыров', 23, '+79998887766');

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