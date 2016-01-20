/*

S40_US10_OAS_Methodologies_update CATALYST - Rollback.sql

10 OAS: New Survey Type
As an Implementation Associate, I want a new survey type w/ appropriate settings for OAS CAHPS, so that I can set up surveys compliantly.
Survey type, no subtypes, DQ rules, monthly sample periods, 3 std methodologies, add survey type to catalyst database 



Chris Burkholder

Task 2 - Update old scripts where we've done this before; make sure goes into Catalyst


*/
USE [NRC_Datamart]
GO

--if not exists( 
delete
--select * 
from [dbo].[SurveyType] where SurveyTypeID = 16 --)
GO

--if not exists( 
delete
--select * 
from [dbo].[CahpsType] where CAHPSTypeID = 9 --)
GO
