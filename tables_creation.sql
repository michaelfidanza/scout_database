
create table if not exists Year_to_pay(
	year_to_pay int,
	primary key(year) 
);

create table if not exists Nation(
	name varchar(20),
	primary key(name)
);

create table if not exists Organization(
	name varchar(20) primary key,
	nation_name varchar(20) references Nation
);

create table if not exists Group_zone(
	id int generated always as identity primary key,
	organization_name varchar(20),
	foreign key (organization_name)
	references Organization(name)
);

create table if not exists Scout_group(
	name varchar(20) primary key,
	phone varchar(20),
	address varchar(55),
	website varchar(20),
	zone_id int references Group_zone
);

create table if not exists Category(
	name varchar(20) primary key check (name in ('L/C', 'E/G', 'R/S'))
);
 

create table if not exists Boyscout(
	id int generated always as identity primary key,
	name varchar(20),
	surname varchar(20),
	phone varchar(20),
	emergency_contact varchar(55),
	birthdate date,
	category_name char(3) references Category check (category_name = category_by_age(birthdate)),
	group_name varchar(55) references Scout_group check (is_there_head(group_name, category_name) is true)
);


create table if not exists Adult(
	id int generated always as identity primary key,
	name varchar(20),
	surname varchar(20),
	phone varchar(20),
	emergency_contact varchar(55),
	training_level varchar(55),
	scout_role varchar(55),
	head_of_category char(3) references Category,
	group_name varchar(55) references Scout_group
);

create table if not exists boyscout_annual_fee(
	boyscout_name int references Boyscout,
	year_paid int references year_to_pay,
	primary key(boyscout_name, year_paid)
);

create table if not exists organization_activity (
	organization_name varchar(20) references organization,
	start_date date,
	duration int,
	price float(2),
	location varchar(55),
	phone varchar(20),
	primary key (organization_name, start_date)
);

create table if not exists group_activity (
	group_name varchar(20) references scout_group,
	start_date date,
	duration int,
	price float(2),
	location varchar(55),
	phone varchar(20),
	primary key (group_name, start_date)
);

create table if not exists organization_activity_category(
	organization_name varchar(20),
	start_date date,
	category_allowed varchar(20) references category,
	foreign key(organization_name, start_date)  references organization_activity (organization_name, start_date),
	primary key (organization_name, start_date, category_allowed)
);

create table if not exists group_activity_category(
	group_name varchar(20),
	start_date date,
	category_allowed varchar(20) references category,
	foreign key(group_name, start_date)  references group_activity (group_name, start_date),
	primary key (group_name, start_date, category_allowed)
);

