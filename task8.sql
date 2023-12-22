--task 8
set search_path = rental_service_view;
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

-- вывести прибыль, которую принесла каждая услуга
-- отсортировать от самой прибыльной услуги, к самой неприбыльной
drop view if exists service_profit;
create view service_profit as
select naming as service_name,
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
           end)                      as total_service_profit
from rental_service.service s
         inner join rental_service.occasion o on o.service_id = s.service_id
         left join rental_service.promotion p on o.promotion_id = p.promotion_id
group by service_name
order by total_service_profit desc;

