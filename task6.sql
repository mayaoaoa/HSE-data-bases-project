--task 6
set search_path = rental_service;

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