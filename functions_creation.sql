create or replace function category_by_age(birthdate date)
  returns text
as
$func$
declare 
	quantity integer;
begin
	quantity := (select(date_part('year', now()) - date_part('year', birthdate::date)));
	if quantity < 12 then
    	return 'L/C';
    elsif quantity <17 then
    	return 'E/G';
    else
    	return 'R/S';
    end if;
    
end;
$func$ language plpgsql;

create or replace function is_there_head(group_name_par varchar(20), category_name_par varchar(20))
  returns boolean
as
$func$
begin
	
    IF EXISTS (select * from adult where group_name = group_name_par and head_of_category = category_name_par) THEN
  		return true ;
  	else
  		return false;
	END IF;
end;
$func$ language plpgsql;

