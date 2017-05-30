/*
	    RTP-2395 Sampling - re-survey exclusion rule.sql

		Chris Burkholder

		5/30/2017

		ADD COLUMN to SURVEY_DEF, Survey_DefTemplate

		select t.name,c.name,* from sys.columns c inner join sys.tables t on c.object_id = t.object_id where c.name like '%resurvey%'
*/

use qp_prod
go

if not exists(select * from sys.columns where name = 'LocationFacilityResurveyDays'
			and object_id = object_id('dbo.survey_def'))
	alter table dbo.survey_def add LocationFacilityResurveyDays int

if not exists(select * from sys.columns where name = 'LocationFacilityResurveyDays'
			and object_id = object_id('rtphoenix.survey_defTemplate'))
	alter table rtphoenix.survey_defTemplate add LocationFacilityResurveyDays int

--TODO: what about MakeTemplate scripts???

go