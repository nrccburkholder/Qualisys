/*

	ROLLBACK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S67 ATL-1219 CG-CAHPS Submission File Updates
	As a CG-CAHPS vendor, we need to create files following the updated specifications, so our data will be accepted.

	ATL-1383  Modify CG CAHPS submissions to use correct question cores

	CREATE procedure GetCGCAHPSdata3
	CREATE procedure GetCGCAHPSdata3_sub_Adult12MonthA
	CREATE procedure GetCGCAHPSdata3_sub_Adult12MonthB
	CREATE procedure GetCGCAHPSdata3_sub_Adult12MonthPCMHa
	CREATE procedure GetCGCAHPSdata3_sub_Adult12MonthPCMHb
	CREATE procedure GetCGCAHPSdata3_sub_Adult6MonthA
	CREATE procedure GetCGCAHPSdata3_sub_Adult6MonthB
	CREATE procedure GetCGCAHPSdata3_sub_Adult6MonthPCMHa
	CREATE procedure GetCGCAHPSdata3_sub_Adult6MonthPCMHb
	CREATE procedure GetCGCAHPSdata3_sub_AdultVisitA
	CREATE procedure GetCGCAHPSdata3_sub_AdultVisitB
	CREATE procedure GetCGCAHPSdata3_sub_Child12MonthPCMHa
	CREATE procedure GetCGCAHPSdata3_sub_Child12MonthPCMHb
	CREATE procedure GetCGCAHPSdata3_sub_Child6Montha
	CREATE procedure GetCGCAHPSdata3_sub_Child6Monthb
	CREATE procedure GetCGCAHPSdata3_sub_Child6MonthPCMHa
	CREATE procedure GetCGCAHPSdata3_sub_Child6MonthPCMHb
	CREATE procedure GetCGCAHPSdata3_sub_Adult6Month30A
	CREATE procedure GetCGCAHPSdata3_sub_Adult6Month30B
	CREATE procedure GetCGCAHPSdata3_sub_Child6Month30a
	CREATE procedure GetCGCAHPSdata3_sub_Child6Month30b
	CREATE procedure GetCGCAHPSdata3_sub_Child12MonthA
	CREATE procedure GetCGCAHPSdata3_sub_Child12MonthB

	Tim Butler
*/
use qp_comments
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3')
	drop procedure GetCGCAHPSdata3
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult12MonthA')
	drop procedure GetCGCAHPSdata3_sub_Adult12MonthA
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult12MonthB')
	drop procedure GetCGCAHPSdata3_sub_Adult12MonthB
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult12MonthPCMHa')
	drop procedure GetCGCAHPSdata3_sub_Adult12MonthPCMHa
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult12MonthPCMHb')
	drop procedure GetCGCAHPSdata3_sub_Adult12MonthPCMHb
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult6MonthA')
	drop procedure GetCGCAHPSdata3_sub_Adult6MonthA
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult6MonthB')
	drop procedure GetCGCAHPSdata3_sub_Adult6MonthB
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult6MonthPCMHa')
	drop procedure GetCGCAHPSdata3_sub_Adult6MonthPCMHa
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult6MonthPCMHb')
	drop procedure GetCGCAHPSdata3_sub_Adult6MonthPCMHb
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_AdultVisitA')
	drop procedure GetCGCAHPSdata3_sub_AdultVisitA
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_AdultVisitB')
	drop procedure GetCGCAHPSdata3_sub_AdultVisitB
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child12MonthPCMHa')
	drop procedure GetCGCAHPSdata3_sub_Child12MonthPCMHa
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child12MonthPCMHb')
	drop procedure GetCGCAHPSdata3_sub_Child12MonthPCMHb
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child6Montha')
	drop procedure GetCGCAHPSdata3_sub_Child6Montha
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child6Monthb')
	drop procedure GetCGCAHPSdata3_sub_Child6Monthb
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child6MonthPCMHa')
	drop procedure GetCGCAHPSdata3_sub_Child6MonthPCMHa
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child6MonthPCMHb')
	drop procedure GetCGCAHPSdata3_sub_Child6MonthPCMHb
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult6Month30A')
	drop procedure GetCGCAHPSdata3_sub_Adult6Month30A
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Adult6Month30B')
	drop procedure GetCGCAHPSdata3_sub_Adult6Month30B
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child6Month30a')
	drop procedure GetCGCAHPSdata3_sub_Child6Month30a
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child6Month30b')
	drop procedure GetCGCAHPSdata3_sub_Child6Month30b
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child12MonthA')
	drop procedure GetCGCAHPSdata3_sub_Child12MonthA
go

if exists (select * from sys.procedures where name = 'GetCGCAHPSdata3_sub_Child12MonthB')
	drop procedure GetCGCAHPSdata3_sub_Child12MonthB
go

