
/*

ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

S51 ATL-363 Process Multiple Files in HH Importer

Tim Butler


CREATE FUNCTION [dbo].[Split]
CREATE PROCEDURE [dbo].[LD_CheckForDuplicateCCNInSampleMonth] 
INSERT DataFileState - DuplicateCCNInSampleMonth
CREATE PROCEDURE [dbo].[LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates] 
CREATE PROCEDURE [dbo].[LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates]   
CREATE PROCEDURE LD_DisableAutoSamplingByStudyID
CREATE PROCEDURE LD_UnscheduledSamplesetByDataFileID


*/



USE [QP_DataLoad]
GO

IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[Split]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
	DROP FUNCTION [dbo].[Split]

GO

if exists (select * from sys.procedures where name = 'LD_CheckForDuplicateCCNInSampleMonth')
	drop procedure LD_CheckForDuplicateCCNInSampleMonth


DELETE FROM [dbo].[DataFileStates]
      WHERE State_desc = 'DuplicateCCNInSampleMonth'
GO

DECLARE @State_ID int

SELECT @State_ID = max(State_ID) FROM [dbo].[DataFileStates]

SET @State_ID = @State_ID + 1

DBCC CHECKIDENT ('[dbo].[DataFileStates]', RESEED, @State_id)

GO



if exists (select * from sys.procedures where name = 'LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates')
	drop procedure LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates


if exists (select * from sys.procedures where name = 'LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates')
	drop procedure LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates


if exists (select * from sys.procedures where name = 'LD_DisableAutoSamplingByStudyID')
	drop procedure LD_DisableAutoSamplingByStudyID


if exists (select * from sys.procedures where name = 'LD_UnscheduledSamplesetByDataFileID')
	drop procedure LD_UnscheduledSamplesetByDataFileID



