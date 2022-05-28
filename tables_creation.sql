--table creation script

create table if not exists Year_to_pay(
	year_to_pay int,
	primary key(year_to_pay) 
);

create table if not exists Nation(
	name varchar(100),
	primary key(name)
);

create table if not exists Organization(
	name varchar(100) primary key,
	nation_name varchar(100) references Nation
);

create table if not exists Group_zone(
	id int generated always as identity primary key,
	organization_name varchar(100),
	zone_description varchar(100),
	foreign key (organization_name)	references Organization(name)
);

create table if not exists Scout_group(
	name varchar(100) primary key,
	phone varchar(20),
	address varchar(100),
	website varchar(100),
	zone_id int references Group_zone
);

create table if not exists Category(
	name varchar(100) primary key constraint check_available_category check (name in ('L/C', 'E/G', 'R/S')) 
);
 

create table if not exists Boyscout(
	id int generated always as identity primary key,
	name varchar(100),
	surname varchar(100),
	phone varchar(20),
	emergency_contact varchar(100),
	birthdate date,
	category_name char(3) references Category constraint check_age_to_category check (category_name = category_by_age(birthdate)),
	group_name varchar(100) references Scout_group constraint check_head_is_present check (is_there_head(group_name, category_name) is true)
);


create table if not exists Adult(
	id int generated always as identity primary key,
	name varchar(100),
	surname varchar(100),
	phone varchar(20),
	emergency_contact varchar(100),
	birthdate date constraint check_age_gt_21 CHECK (age_calc(birthdate) > 21),
	training_level varchar(100),
	scout_role varchar(100),
	head_of_category char(3) references Category,
	group_name varchar(100) references Scout_group
);



create table if not exists boyscout_annual_fee(
	boyscout_name int references Boyscout,
	year_paid int references year_to_pay,
	primary key(boyscout_name, year_paid)
);

create table if not exists organization_activity (
	organization_name varchar(100) references organization,
	start_date date,
	duration int,
	price float(2),
	location varchar(100),
	phone varchar(20),
	primary key (organization_name, start_date)
);

create table if not exists group_activity (
	group_name varchar(100) references scout_group,
	start_date date,
	duration int,
	price float(2),
	location varchar(100),
	phone varchar(20),
	primary key (group_name, start_date)
);

create table if not exists organization_activity_category(
	organization_name varchar(100),
	start_date date,
	category_allowed varchar(100) references category,
	foreign key(organization_name, start_date)  references organization_activity (organization_name, start_date),
	primary key (organization_name, start_date, category_allowed)
);

create table if not exists group_activity_category(
	group_name varchar(100),
	start_date date,
	category_allowed varchar(100) references category,
	foreign key(group_name, start_date)  references group_activity (group_name, start_date),
	primary key (group_name, start_date, category_allowed)
);

