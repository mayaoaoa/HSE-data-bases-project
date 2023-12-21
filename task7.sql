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