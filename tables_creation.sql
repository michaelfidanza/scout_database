--table creation script

create table if not exists Year_to_pay(
	year_to_pay int not null,
	primary key(year_to_pay) 
);

create table if not exists Nation(
	name varchar(100),
	primary key(name)
);

create table if not exists Organization(
	name varchar(100) not null primary key,
	nation_name varchar(100) not null references Nation
);

create table if not exists Group_zone(
	id int generated always as identity primary key,
	organization_name varchar(100) not null,
	zone_description varchar(100) not null,
	foreign key (organization_name)	references Organization(name)
);

create table if not exists Scout_group(
	name varchar(100) not null primary key,
	phone varchar(20) not null,
	address varchar(100) not null,
	website varchar(100),
	zone_id int  not null references Group_zone
);

create table if not exists Category(
	name varchar(100) not null primary key constraint check_available_category check (name in ('L/C', 'E/G', 'R/S')) 
);
 

create table if not exists Boyscout(
	id int generated always as identity primary key,
	name varchar(100) not null,
	surname varchar(100) not null,
	phone varchar(20) not null,
	emergency_contact varchar(100) not null,
	birthdate date not null,
	category_name char(3) not null references Category constraint check_age_to_category check (category_name = category_by_age(birthdate)),
	group_name varchar(100) not null references Scout_group constraint check_head_is_present check (is_there_head(group_name, category_name) is true)
);


create table if not exists Adult(
	id int generated always as identity primary key,
	name varchar(100) not null,
	surname varchar(100) not null,
	phone varchar(20) not null,
	emergency_contact varchar(100) not null,
	birthdate date  not null constraint check_age_gt_21 CHECK (age_calc(birthdate) > 21),
	training_level varchar(100) not null,
	scout_role varchar(100) not null,
	head_of_category char(3) not null references Category,
	group_name varchar(100) not null references Scout_group
);



create table if not exists boyscout_annual_fee(
	boyscout_id int not null references Boyscout,
	year_paid int not null references year_to_pay,
	primary key(boyscout_id, year_paid)
);

create table if not exists organization_activity (
	id int generated always as identity primary key,
	organization_name varchar(100) not null references organization,
	description varchar(100) not null,
	start_date date not null,
	duration int not null,
	price float(2) not null,
	location varchar(100) not null,
	phone varchar(20) not null
);

create table if not exists activity (
	id int generated always as identity primary key,
	activity_type varchar(5) not null constraint check_activity_type check (activity_type in ('group', 'org')),
	group_name varchar(100) references scout_group constraint check_group_activity check ((activity_type = 'group' and group_name is not null) or (activity_type = 'org' and group_name is null)),
	organization_name varchar(100) references organization constraint check_org_activity check ((activity_type = 'org' and organization_name is not null) or (activity_type = 'group' and organization_name = org_by_group(group_name))),
	description varchar(100) not null,
	start_date date not null constraint check_date_is_valid check (start_date > now()),
	duration int not null,
	price float(2) not null,
	location varchar(100) not null,
	phone varchar(20) not null
);

create table if not exists group_activity (
	id int generated always as identity primary key,
	group_name varchar(100) not null references scout_group,
	description varchar(100) not null,
	start_date date not null,
	duration int not null,
	price float(2) not null,
	location varchar(100) not null,
	phone varchar(20) not null
);

create table if not exists organization_activity_category(
	id int not null references organization_activity,
	category_allowed varchar(100) not null references category,
	primary key (id, category_allowed)
);

create table if not exists group_activity_category(
	id int not null references group_activity,
	category_allowed varchar(100) not null references category,
	primary key (id, category_allowed)
);

create table if not exists activity_category(
	id int not null references activity,
	category_allowed varchar(100) not null references category,
	primary key (id, category_allowed)
);

