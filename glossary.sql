select baf.year_paid as year, b.group_name, b.category_name,  count(*) as number_of_subscriptions
from boyscout_annual_fee baf 
join boyscout b  on baf.boyscout_id = b.id
join scout_group sg on b.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
join nation n on o.nation_name = n."name" 
group by (baf.year_paid, b.group_name, b.category_name)
order by baf.year_paid, b.group_name, b.category_name ;


select baf.year_paid as year, b.group_name, b.category_name,  avg(age_calc(b.birthdate)) as average_age
from boyscout_annual_fee baf 
join boyscout b  on baf.boyscout_id = b.id
join scout_group sg on b.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
join nation n on o.nation_name = n."name" 
group by (baf.year_paid, b.group_name, b.category_name)
order by baf.year_paid, b.group_name, b.category_name ;


select ga.start_date,ga.group_name, gac.category_allowed,  count(*) as number_of_organized_events
from group_activity_category gac 
join group_activity ga on gac.id = ga.id 
join scout_group sg on ga.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
join nation n on o.nation_name = n."name" 
group by (ga.start_date, ga.group_name, gac.category_allowed)
order by ga.start_date, ga.group_name, gac.category_allowed;

select ga.start_date,ga.group_name, gac.category_allowed,  avg(ga.price) as average_price_of_organized_events
from group_activity_category gac 
join group_activity ga on gac.id = ga.id 
join scout_group sg on ga.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
join nation n on o.nation_name = n."name"
group by (ga.start_date, ga.group_name, gac.category_allowed)
order by ga.start_date, ga.group_name, gac.category_allowed;


select ga.start_date,ga.group_name, gac.category_allowed,  avg(ga.duration) as average_duration_of_organized_events
from group_activity_category gac 
join group_activity ga on gac.id = ga.id 
join scout_group sg on ga.group_name = sg."name" 
join group_zone gz on sg.zone_id = gz.id 
join organization o on gz.organization_name = o."name" 
join nation n on o.nation_name = n."name" 
group by  (ga.start_date, ga.group_name, gac.category_allowed)
order by ga.start_date, ga.group_name, gac.category_allowed;






