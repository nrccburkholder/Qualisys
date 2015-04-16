/*
S23_US13 As an ATLAS team, address gaps from prior PCMH implementation of survey setup

	T1 modify configuration manager to filter for questionnaires on selected subtype

Tim Butler


CREATE TABLE SubtypeSubtypeMapping
INSERT INTO SubtypeSubtypeMapping (inserting records for mapping PCMH subtype to specific PCMH questionnaire types)
ALTER PROCEDURE [dbo].[QCL_SelectSubTypes] 


*/
USE [QP_Prod]

IF NOT EXISTS (SELECT * FROM sys.tables where schema_id=1 and name = 'SubtypeSubtypeMapping')
BEGIN

CREATE TABLE SubtypeSubtypeMapping(
	[SubtypeSubtypeMapping_id] [int] IDENTITY(1,1) NOT NULL,
	[ParentSubtype_id] [int] NOT NULL,
	[ChildSubtype_id] [int] NOT NULL
)

END
GO

IF NOT EXISTS (SELECT 1 from SubtypeSubtypeMapping WHERE ParentSubtype_id = 12 and ChildSubtype_id = 7)
	INSERT INTO SubtypeSubtypeMapping
			   (ParentSubtype_id
			   ,ChildSubtype_id)
		 VALUES
			   (12
			   ,7)

GO

IF NOT EXISTS (SELECT 1 from SubtypeSubtypeMapping WHERE ParentSubtype_id = 12 and ChildSubtype_id = 8)
	INSERT INTO SubtypeSubtypeMapping
			   (ParentSubtype_id
			   ,ChildSubtype_id)
		 VALUES
			   (12
			   ,8)

GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectSubTypes')
	DROP PROCEDURE dbo.QCL_SelectSubTypes
GO


/****** Object:  StoredProcedure [dbo].[QCL_SelectSubTypes]    Script Date: 4/14/2015 2:05:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectSubTypes] 
@surveytypeid int,
@subtypecategory int,
@surveyid int 
AS


if @SubtypeCategory = 1
-- this returns records for loading the SubType combobox
	SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected, ISNULL(ststm.ParentSubtype_id,0) ParentSubType_id
	FROM SurveyTypeSubType stst
	inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
	inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
	left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = 15900)
	left join SubtypeSubtypeMapping ststm on (ststm.ParentSubtype_id = st.Subtype_id)
	WHERE SurveyType_ID = @surveytypeid
	and stc.SubtypeCategory_id = @SubtypeCategory

ELSE if @SubtypeCategory = 2
-- this returns records for loading the Questionnaire combobox
	SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected, ISNULL(ststm.ParentSubtype_id,0) ParentSubType_id
	--INTO #QuestionnaireTypes
	FROM SurveyTypeSubType stst
	inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
	inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
	left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = 15900)
	left join SubtypeSubtypeMapping ststm on (ststm.ChildSubtype_id = st.Subtype_id)
	WHERE SurveyType_ID = @surveytypeid
	and stc.SubtypeCategory_id = @SubtypeCategory

GO