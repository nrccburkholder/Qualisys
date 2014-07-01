use [NRC_DataMart]

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM [Disposition]

if not exists (select 1 from disposition where dispositionID = 23)
insert into disposition values (23,'Negative Screener Response')

if not exists (select 1 from disposition where dispositionID = 24)
insert into disposition values (24,'Institutionalized')

if not exists (select 1 from disposition where dispositionID = 25)
insert into disposition values (25,'Blank first mail survey')

if not exists (select 1 from disposition where dispositionID = 26)
insert into disposition values (26,'Blank second mail survey')

if not exists (select 1 from disposition where dispositionID = 27)
insert into disposition values (27,'Blank phone survey')

if not exists (select 1 from disposition where dispositionID = 28)
insert into disposition values (28, 'Mixed Mode Removed from Phone')

if not exists (select 1 from disposition where dispositionID = 29)
insert into disposition values (29, 'Complete and Valid Survey by Web')

if not exists (select 1 from disposition where dispositionID = 30)
insert into disposition values (30, 'Partial Survey by Web')

if not exists (select 1 from disposition where dispositionID = 32)
insert into disposition values (32, 'Returned Survey - Eligibility Unknown')

if not exists (select 1 from disposition where dispositionID = 33)
insert into disposition values (33, 'Ineligible - Not Receiving Care')

if not exists (select 1 from disposition where dispositionID = 34)
insert into disposition values (34, 'Ineligible - Not Receiving Care at Facility')

if not exists (select 1 from disposition where dispositionID = 35)
insert into disposition values (35, 'Partial Survey by Web')

