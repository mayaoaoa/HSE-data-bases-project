--task 8
set search_path = rental_service_view;

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

