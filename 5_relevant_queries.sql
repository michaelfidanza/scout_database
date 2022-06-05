--organization with largest number of subscription for the current year
select o.name, count(*) as total_subscription
from boyscout b 
join boyscout_annual_fee baf on b.id = baf.boyscout_id 
join scout_group sg on b.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
where baf.year_paid = date_part('year', now()) 
group by o."name" 
order by total_subscription desc
limit 1;

--average age of the boyscout subscribed to a certain group
select b.group_name, avg(age_calc(b.birthdate))::float
from boyscout b 
group by b.group_name;


--scout category which can participate in the largest number of activities
create view total_group_activities_by_category as
select oac.category_allowed, count(*) as total_activities
from organization_activity_category oac
group by oac.category_allowed;

create view total_organization_activities_by_category as
select gac.category_allowed, count(*) as total_activities
from group_activity_category gac 
group by gac.category_allowed;

select coalesce(tga.category_allowed, toa.category_allowed), 
coalesce(tga.total_activities,0) + coalesce(toa.total_activities, 0) as total_org_group_activities
from total_group_activities_by_category tga
full join total_organization_activities_by_category toa on tga.category_allowed = toa.category_allowed;



--number of adults vs number of scouts per each category in each group in Italy
create view total_heads_by_category_in_groups as
select a.group_name, a.head_of_category as category, count(*) as number_of_heads
from adult a 
join scout_group sg on a.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
join nation n on o.nation_name = n."name" 
where n."name" = 'Italy'
group by a.group_name, a.head_of_category 
order by a.group_name, a.head_of_category;

create view total_scouts_by_category_in_groups as
select b.group_name, b.category_name  as category, count(*) as number_of_scouts
from boyscout b 
join scout_group sg on b.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
join nation n on o.nation_name = n."name" 
where n."name" = 'Italy'
group by b.group_name, b.category_name 
order by b.group_name, b.category_name;

select coalesce(th.group_name, ts.group_name) as group_name, coalesce(th.category, ts.category) as category, 
th.number_of_heads, coalesce(ts.number_of_scouts,0) as number_of_scouts
from total_heads_by_category_in_groups th
left join total_scouts_by_category_in_groups ts on th.group_name = ts.group_name and th.category = ts.category


--find total number of scout groups by nation
select n."name" as nation, count(*)
from nation n
join organization o on o.nation_name = n."name" 
join group_zone gz on gz.organization_name = o."name" 
join scout_group sg on gz.id  = sg.zone_id 
group by n."name" 



