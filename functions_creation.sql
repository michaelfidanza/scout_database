
-- function that given a birth date, returns the age of the person
create or replace function age_calc(birthdate date)
  returns int
as
$func$
begin
	RETURN (select(date_part('year', now()) - date_part('year', birthdate::date)));
end;
$func$ language plpgsql;

--function that given a birth date, returns the category for a boy scout (if in age range (9-21))
create or replace function category_by_age(birthdate date)
  returns text
as
$func$
declare 
	age integer;
begin
	age := age_calc(birthdate);
	if age >= 9 and age <= 11 then
    	return 'L/C';
    elsif age >= 12 and age <= 16 then
    	return 'E/G';
    elsif age >= 17 and age <= 21 then
    	return 'R/S';
    else
    	return 'Can not be a boyscout';
    end if;
    
end;
$func$ language plpgsql;


-- function that given a group name and a category, returns true if at least 1 head is found 
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

