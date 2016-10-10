/*

S39 US 17 Hospice CAHPS 2.0 Language-Speak Question 

As a Hospice CAHPS vendor, we must update the language spoken question, so that we are fielding according to protocols.


Task 2 - Update the table for survey validation

Task 3 - Create a script to programmatically update all Hospice CAHPS surveys with core 54067 instead of 51620.

Tim Butler



*/


DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc


DECLARE @OldQstnCore int
DECLARE @NewQstnCore int


SET @OldQstnCore = 51620 
SET @NewQstnCore = 54067

 begin tran

 update stqm
	SET datEncounterEnd_dt = '2015-09-30 00:00:00.000'
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings] stqm
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore 


  IF not exists ( SELECT * FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings] where SurveyType_id = @SurveyType_ID and QstnCore = @NewQstnCore)
  begin 

	INSERT INTO [dbo].[SurveyTypeQuestionMappings]
           ([SurveyType_id]
           ,[QstnCore]
           ,[intOrder]
           ,[bitFirstOnForm]
           ,[bitExpanded]
           ,[datEncounterStart_dt]
           ,[datEncounterEnd_dt]
           ,[SubType_ID]
           ,[isATA]
           ,[isMeasure])
     VALUES
           (11
           ,@NewQstnCore
           ,47
           ,0
           ,0
           ,'2015-10-01 00:00:00.000'
           ,'2999-12-31 00:00:00.000'
           ,0
           ,0
           ,0)

	end

  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore

  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @NewQstnCore 

  rollback tran