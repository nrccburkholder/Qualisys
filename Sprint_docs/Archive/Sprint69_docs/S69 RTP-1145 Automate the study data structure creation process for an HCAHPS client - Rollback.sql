/*
S69 RTP-1145 Automate the study data structure creation process for an HCAHPS client - Rollback.sql

Chris Burkholder

1/31/2017

DROP TABLE RTPhoenix.Study_EmployeeTemplate
DROP TABLE RTPhoenix.CODETXTBOXTemplate
DROP TABLE RTPhoenix.CODEQSTNSTemplate
DROP TABLE RTPhoenix.CODESCLSTemplate
DROP TABLE RTPhoenix.TAGFIELDTemplate
DROP TABLE RTPhoenix.ModeSectionMappingTemplate
DROP TABLE RTPhoenix.SEL_COVERTemplate
DROP TABLE RTPhoenix.SEL_LOGOTemplate
DROP TABLE RTPhoenix.SEL_PCLTemplate
DROP TABLE RTPhoenix.SEL_QSTNSTemplate
DROP TABLE RTPhoenix.SEL_SCLSTemplate
DROP TABLE RTPhoenix.SEL_SKIPTemplate
DROP TABLE RTPhoenix.SEL_TEXTBOXTemplate
DROP TABLE RTPhoenix.SUFacilityTemplate
DROP TABLE RTPhoenix.MedicareLookupTemplate
DROP TABLE RTPhoenix.CriteriaInlistTemplate
DROP TABLE RTPhoenix.CriteriaClauseTemplate
DROP TABLE RTPhoenix.CriteriaStmtTemplate
DROP TABLE RTPhoenix.HouseHoldRuleTemplate
DROP TABLE RTPhoenix.BusinessRuleTemplate
DROP TABLE RTPhoenix.PeriodDatesTemplate
DROP TABLE RTPhoenix.PeriodDefTemplate
DROP TABLE RTPhoenix.SAMPLEUNITSECTIONTemplate
DROP TABLE RTPhoenix.SAMPLEUNITTREEINDEXTemplate
DROP TABLE RTPhoenix.SAMPLEUNITSERVICETemplate
DROP TABLE RTPhoenix.SAMPLEUNITTemplate
DROP TABLE RTPhoenix.SAMPLEPLANTemplate
DROP TABLE RTPhoenix.mailingstepTemplate
DROP TABLE RTPhoenix.mailingmethodologyTemplate
DROP TABLE RTPhoenix.SurveySubtypeTemplate
DROP TABLE RTPhoenix.SURVEY_DEFTemplate
DROP TABLE RTPhoenix.METALOOKUPTemplate
DROP TABLE RTPhoenix.METASTRUCTURETemplate
DROP TABLE rtphoenix.METATABLETemplate
DROP TABLE rtphoenix.STUDYTemplate
DROP TABLE rtphoenix.CLIENTTemplate
DROP TABLE rtphoenix.Template
DROP TABLE RTPhoenix.DestinationQLTemplate
DROP TABLE RTPhoenix.SourceQLTemplate
DROP TABLE RTPhoenix.DTSMappingQLTemplate
DROP TABLE RTPhoenix.PackageQLTemplate

DROP VIEW RTPhoenix.ClientStudySurvey_viewTemplate

DROP TABLE RTPhoenix.TemplateJob
DROP TABLE RTPhoenix.TemplateLog
DROP TABLE RTPhoenix.Template
DROP TABLE RTPhoenix.TemplateJobType
DROP TABLE RTPhoenix.TemplateLogEntryType

DROP SCHEMA RTPhoenix

*/
USE [QP_Prod]
GO

DROP TABLE RTPhoenix.Study_EmployeeTemplate
GO

DROP TABLE RTPhoenix.CODETXTBOXTemplate
GO

DROP TABLE RTPhoenix.CODEQSTNSTemplate
GO

DROP TABLE RTPhoenix.CODESCLSTemplate
GO

DROP TABLE RTPhoenix.TAGFIELDTemplate
GO

DROP TABLE RTPhoenix.ModeSectionMappingTemplate
GO

DROP TABLE RTPhoenix.SEL_COVERTemplate
GO

DROP TABLE RTPhoenix.SEL_LOGOTemplate
GO

DROP TABLE RTPhoenix.SEL_PCLTemplate
GO

DROP TABLE RTPhoenix.SEL_QSTNSTemplate
GO

DROP TABLE RTPhoenix.SEL_SCLSTemplate
GO

DROP TABLE RTPhoenix.SEL_SKIPTemplate
GO

DROP TABLE RTPhoenix.SEL_TEXTBOXTemplate
GO

DROP TABLE RTPhoenix.SUFacilityTemplate
GO

DROP TABLE RTPhoenix.MedicareLookupTemplate
GO

DROP TABLE RTPhoenix.CriteriaInlistTemplate
GO

DROP TABLE RTPhoenix.CriteriaClauseTemplate
GO

DROP TABLE RTPhoenix.CriteriaStmtTemplate
GO

DROP TABLE RTPhoenix.HouseHoldRuleTemplate
GO

DROP TABLE RTPhoenix.BusinessRuleTemplate
GO

DROP TABLE RTPhoenix.PeriodDatesTemplate
GO

DROP TABLE RTPhoenix.PeriodDefTemplate
GO

DROP TABLE RTPhoenix.SAMPLEUNITTREEINDEXTemplate
GO

DROP TABLE RTPhoenix.SAMPLEUNITSERVICETemplate
GO

DROP TABLE RTPhoenix.SAMPLEUNITSECTIONTemplate
GO

ALTER TABLE [RTPhoenix].[SAMPLEPLANTemplate] DROP CONSTRAINT [FK_SAMPLEPL_REF_4957_SAMPLEUN]
GO

ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] DROP CONSTRAINT [FK_SAMPLEUNIT_REF_2092_SAMPLEPL]
GO

DROP TABLE RTPhoenix.SAMPLEUNITTemplate
GO

DROP TABLE RTPhoenix.SAMPLEPLANTemplate
GO

DROP TABLE RTPhoenix.mailingstepTemplate
GO

DROP TABLE RTPhoenix.mailingmethodologyTemplate
GO

DROP TABLE RTPhoenix.SurveySubtypeTemplate
GO

DROP TABLE RTPhoenix.SURVEY_DEFTemplate
GO

DROP TABLE RTPhoenix.MatchFieldValidationQLTemplate
GO

DROP TABLE RTPhoenix.METALOOKUPTemplate
GO

DROP TABLE RTPhoenix.METASTRUCTURETemplate
GO

DROP TABLE rtphoenix.METATABLETemplate
GO

DROP TABLE rtphoenix.STUDYTemplate
GO

DROP TABLE rtphoenix.CLIENTTemplate
GO

DROP TABLE RTPhoenix.DestinationQLTemplate
GO

DROP TABLE RTPhoenix.SourceQLTemplate
GO

DROP TABLE RTPhoenix.DTSMappingQLTemplate
GO

DROP TABLE RTPhoenix.PackageQLTemplate
GO

DROP VIEW RTPhoenix.ClientStudySurvey_viewTemplate
GO

DROP TABLE RTPhoenix.TemplateJob
GO

DROP TABLE RTPhoenix.TemplateLog
GO

DROP TABLE RTPhoenix.Template
GO

DROP TABLE RTPhoenix.TemplateJobType
GO

DROP TABLE RTPhoenix.TemplateLogEntryType
GO

DROP PROCEDURE RTPhoenix.MakeSampleUnitsFromTemplate
GO

DROP PROCEDURE RTPhoenix.MakeStudyFromTemplate
GO

DROP PROCEDURE RTPhoenix.MakeSurveysFromTemplate
GO

DROP PROCEDURE RTPhoenix.ProcessStudyOwnedTables
GO

DROP PROCEDURE RTPhoenix.ProcessTemplateJobs
GO

DROP SCHEMA RTPhoenix
GO

