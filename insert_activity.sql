INSERT INTO public.activity
(activity_type, group_name, organization_name, description, start_date, duration, price, "location", phone)
values
('org', NULL, 'Agesci', '', '2022-06-05', 0, 0, '', '');


select *
from activity a
join organization o on a.organization_name = o."name" 
join nation n on o.nation_name = n."name" 
left join scout_group sg on a.group_name = sg."name" 
left join group_zone gz on sg.zone_id = gz.id 