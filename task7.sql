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
order by XP desc ;