
/*

S32 US10 ACO Questionnaire Type	As an Implementation Associate, I want a new questionnaire type for ACO-9, so that I can set up surveys for Fall 2015 fielding
S32 US12 ACO Subtype Deactivation	As an Implementation Associate, I do not want to be able to select questionnaire types that are no longer valid in the dropdown list, so that I do not accidentally pick the wrong type.

Task 10.1 	add questionnaire subtype to subtype table 
Task 12.1	add a bit active column to subtype table and populate
Task 12.2	modfy configmanager to display indicator on inactive subtypes and filter out inactives for new surveys
Task 12.3	modify proc that reads the subtypes for configmanager dropdown


Tim Butler

	alter table [dbo].[SubType] add column bitActive
	update ACO-8 bitActive = 0
	insert ACO-9 
	ALTER PROCEDURE [dbo].[QCL_SelectSubTypes]
	ALTER PROCEDURE [dbo].[QCL_SelectSurveySubTypes] 

*/


-- Task 12.1
use [QP_Prod]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'Subtype' 
					   AND sc.NAME = 'bitActive' )

	alter table [dbo].[Subtype] add bitActive bit NOT NULL DEFAULT 1

go

commit tran
go



USE [QP_Prod]
GO

UPDATE [dbo].[Subtype]
   SET bitActive = 0
 WHERE Subtype_nm = 'ACO-8'
GO


-- Task 10.1
USE [QP_Prod]
GO

IF NOT EXISTS (SELECT 1 FROM [QP_Prod].[dbo].[Subtype] WHERE Subtype_nm = 'ACO-9')
BEGIN
	SET IDENTITY_INSERT subtype ON
	INSERT INTO [dbo].[Subtype]
			   ([Subtype_id]
			   ,[Subtype_nm]
			   ,[SubtypeCategory_id]
			   ,[bitRuleOverride]
			   ,[bitQuestionnaireRequired])
		 VALUES
			   (13
			   ,'ACO-9'
			   ,2
			   ,0
			   ,0)

	SET IDENTITY_INSERT subtype OFF
END
GO



-- Task 12.3
USE [QP_Prod]
GO

DECLARE @SubtypeId int

IF EXISTS (SELECT 1 FROM [QP_Prod].[dbo].[Subtype] WHERE Subtype_nm = 'ACO-9')
BEGIN
	SELECT @SubtypeId = SubType_id FROM [QP_Prod].[dbo].[Subtype] WHERE Subtype_nm = 'ACO-9' 

	IF NOT EXISTS (SELECT 1 FROM [dbo].[SurveyTypeSubtype] WHERE SurveyType_id = 10 and Subtype_id = @SubtypeId)
	BEGIN

		INSERT INTO [dbo].[SurveyTypeSubtype]
				   ([SurveyType_id]
				   ,[Subtype_id])
			 VALUES
				   (10
				   ,@SubtypeId)

	END
END
GO



USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectSubTypes]    Script Date: 8/19/2015 4:21:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectSubTypes] 
@surveytypeid int,
@subtypecategory int,
@surveyid int 
AS

/*
	S23 US13	Tim Butler -- changed to join with SubtypeSubtypeMapping
	S32 US12.3	Tim Butler -- added bitActive to SELECT 

*/

if @SubtypeCategory = 1
-- this returns records for loading the SubType combobox
	SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, st.bitActive, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected, ISNULL(ststm.ParentSubtype_id,0) ParentSubType_id, st.bitQuestionnaireRequired
	FROM SurveyTypeSubType stst
	inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
	inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
	left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = @surveyid)
	left join SubtypeSubtypeMapping ststm on (ststm.ParentSubtype_id = st.Subtype_id)  -- joins on ParentSubType_id
	WHERE SurveyType_ID = @surveytypeid
	and stc.SubtypeCategory_id = @SubtypeCategory

ELSE if @SubtypeCategory = 2
-- this returns records for loading the Questionnaire combobox
	SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, st.bitActive, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected, ISNULL(ststm.ParentSubtype_id,0) ParentSubType_id, st.bitQuestionnaireRequired
	--INTO #QuestionnaireTypes
	FROM SurveyTypeSubType stst
	inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
	inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
	left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = @surveyid)
	left join SubtypeSubtypeMapping ststm on (ststm.ChildSubtype_id = st.Subtype_id)  -- joins on ChildSubType_id
	WHERE SurveyType_ID = @surveytypeid
	and stc.SubtypeCategory_id = @SubtypeCategory

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveySubTypes]    Script Date: 8/20/2015 8:24:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectSurveySubTypes]      
    @SurveyId INT,
	@SubtypeCategory_id INT     
AS      

/*
	S32 US12.3	Tim Butler -- added bitActive to SELECT 
*/      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      

SELECT sst.SurveySubtype_id, sst.Subtype_id, sst.Survey_id, st.Subtype_nm, st.SubtypeCategory_id, st.bitRuleOverride, st.bitActive
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @SurveyId
and st.SubtypeCategory_id = @SubtypeCategory_id 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF