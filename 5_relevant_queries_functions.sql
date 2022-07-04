CREATE OR REPLACE FUNCTION public.sub_number()
 RETURNS TABLE(organization_name character varying, total_subscription bigint)
 LANGUAGE plpgsql
AS $function$
	begin
		RETURN QUERY
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
	END;
$function$
;


CREATE OR REPLACE FUNCTION public.avg_age()
 RETURNS TABLE(group_name character varying, total_subscription bigint, avg_age float)
 LANGUAGE plpgsql
AS $function$
	begin
		RETURN QUERY
		select b.group_name, count(*), avg(age_calc(b.birthdate))::float
		from boyscout b 
		JOIN boyscout_annual_fee baf on b.id = baf.boyscout_id 
		where baf.year_paid = date_part('year', now()) 
		group by b.group_name;
	END;
$function$
;

CREATE OR REPLACE FUNCTION public.tot_group_numb()
 RETURNS TABLE(nation character varying, group_number bigint)
 LANGUAGE plpgsql
AS $function$
	begin
		RETURN QUERY
		select n."name" as nation, count(*)
			from nation n
			join organization o on o.nation_name = n."name" 
			join group_zone gz on gz.organization_name = o."name" 
			join scout_group sg on gz.id  = sg.zone_id 
			group by n."name";
	END;
$function$
;


CREATE OR REPLACE FUNCTION public.tot_act()
 RETURNS TABLE(category character varying, total_activities bigint)
 LANGUAGE plpgsql
AS $function$
	begin
		RETURN QUERY
		select coalesce(tga.category_allowed, toa.category_allowed), 
			coalesce(tga.total_activities,0) + coalesce(toa.total_activities, 0) as total_org_group_activities
			from total_group_activities_by_category tga
			full join total_organization_activities_by_category toa on tga.category_allowed = toa.category_allowed;

	END;
$function$
;

CREATE OR REPLACE FUNCTION public.heads_vs_scouts()
 RETURNS TABLE(group_name character varying, category char(3), 
 number_of_heads bigint, number_of_scouts bigint)
 LANGUAGE plpgsql
AS $function$
	begin
		RETURN QUERY
		select coalesce(th.group_name, ts.group_name) as group_name, coalesce(th.category, ts.category) as category, 
			th.number_of_heads, coalesce(ts.number_of_scouts,0) as number_of_scouts
			from total_heads_by_category_in_groups th
			left join total_scouts_by_category_in_groups ts on th.group_name = ts.group_name and th.category = ts.category;

	END;
$function$
;






