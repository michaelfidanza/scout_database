insert into year_to_pay values
  (2015)
, (2016)
, (2017)
, (2018)
, (2019)
, (2020)
, (2021)
, (2022)
;

insert into nation values 
  ('Italy')
, ('International')
;

insert into organization values
	('Agesci', 'Italy')
,	('Cngei', 'Italy')
,	('MasciScout d''Europa', 'Italy')
,	('Masci', 'Italy')
,	('Wosm for men', 'International')
,	('Waggs for women', 'International')
;

-- create a zone for each organization to start with. To add later other zones in case it is necessary
insert into group_zone (organization_name, zone_description) 
select name, 'Northern Italy' from organization where nation_name <> 'International'
;

insert into scout_group values
	('Gruppo Scout AGESCI Verona 24', '045 581715', 'via santo sepolcro 15, 37131 Verona', 'www.agesciverona.com', 1)
,	('Gruppo Scout AGESCI Vicenza', '054 332548', 'via G. Matteotti 15, 46044 Vicenza', 'www.agescivicenza.com', 1)
;

insert into category values
	('L/C')
,	('E/G')
,	('R/S')
;

insert into adult (name, surname, phone, emergency_contact, birthdate, training_level, scout_role, head_of_category, group_name) values
	('Marco', 'Rossi', '+39 345 9875485', 'Mom: +39 354 6587457', '1993-03-24', 'Expert', 'Head of lupetti/coccinelle', 'L/C', 'Gruppo Scout AGESCI Verona 24')
,	('Valerio', 'Verdi', '+39 345 4783215', 'Dad: +39 354 8753012', '1993-05-15', 'Expert', 'Co-Head of lupetti/coccinelle', 'L/C', 'Gruppo Scout AGESCI Verona 24')
,	('Sara', 'Cinesca', '+39 345 7402156', 'Uncle Sam: +39 354 0302054', '1990-12-01', 'Expert', 'Head of esploratori/guide', 'E/G', 'Gruppo Scout AGESCI Verona 24')
,	('Marco', 'Smeraldi', '+39 345 5214569', 'N/A', '1993-07-01', 'Expert', 'Head of rover/scolte', 'R/S', 'Gruppo Scout AGESCI Verona 24')
,	('Franca', 'Franchi', '+39 345 0254879', 'Dad: +39 354 3021569', '1991-09-14', 'Expert', 'Head of lupetti/coccinelle', 'L/C', 'Gruppo Scout AGESCI Vicenza')
,	('Bianca', 'Neve', '+39 345 8574965', 'Sister Susan: +39 354 457820', '1990-04-14', 'Expert', 'Head of esploratori/guide', 'E/G', 'Gruppo Scout AGESCI Vicenza')
;

insert into boyscout (name, surname, phone, emergency_contact, birthdate, category_name, group_name) values
	('Marcello', 'Scodello', '+39 365 5214569', 'Fido the dog: +39 354 2222222', '2002-07-01', 'R/S', 'Gruppo Scout AGESCI Verona 24')
,	('Viola', 'Rosa', '+39 365 5214569', 'Miaow the cat: +39 354 111111', '2012-07-01', 'L/C', 'Gruppo Scout AGESCI Vicenza')




































