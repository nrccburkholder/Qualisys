use QP_Prod

/*
S8.US5 - Remove PCMH Data from Stage and Test
As a ALLCAHPS team, we want to remove PMCH changes from Test and Stage so that the environments are in sync.
Tim Butler
*/


-- RUN THIS ONE LAST
begin tran
go

declare @SurveyTypeid int, @Subtype_Id int

select @SurveyTypeid = surveytype_id from surveytype where SurveyType_dsc='CGCAHPS'	

select @subtype_id = st.subtype_id 
from surveytypesubtype stst
inner join subtype st on st.subtype_id = stst.subtype_id
where st.Subtype_nm = 'PCMH'

if exists (select * from survey_def where surveytype_id = @Surveytypeid and survey_id in (select survey_id from surveysubtype where subtype_id=@Subtype_id))
	print 'There are still surveys that use the PCMH subtype. Aborting'
else
begin
	DELETE FROM [dbo].[SurveySubtype]
	WHERE Subtype_id = @SubType_id

	DELETE FROM [dbo].[SurveyTypeSubtype]
	WHERE Subtype_id = @SubType_id

	DELETE dbo.subtype
	WHERE [Subtype_nm] = 'PCMH'
end																						
/*

  go
  commit tran

  rollback tran
*/

Select  *
FROM [dbo].[SurveySubtype]
 WHERE Subtype_id = @SubType_id

select *
 FROM [dbo].[SurveyTypeSubtype]
 WHERE Subtype_id = @SubType_id

select *
FROM [dbo].[Subtype]	