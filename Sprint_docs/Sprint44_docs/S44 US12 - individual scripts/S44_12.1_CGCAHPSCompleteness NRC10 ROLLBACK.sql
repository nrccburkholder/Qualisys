/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S44 12 CG-CAHPS Completeness
	As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

	Task 1 - Add new subtypes for 3.0 questionnaire types; confirm all other types already in table

	Tim Butler
*/


use qp_prod
go


	declare @SurveyType_id int

	select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = 'CGCAHPS'

	declare @subtype_id int

	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id  in (
		SELECT Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = 'Adult 3.0'
	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = 'Adult 3.0'

	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id  in (
		SELECT Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = 'Child 3.0'
	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = 'Child 3.0'


	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id  in (
		SELECT Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = '6-month Adult 3.0'
	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = '6-month Adult 3.0'



	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id in (
		SELECT Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = '6-month Child 3.0'
	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = '6-month Child 3.0'



	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id in (
		SELECT Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = '6-month Adult 2.0'
	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = '6-month Adult 2.0'

	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id IN (
		Select Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = '6-month Child 2.0'
	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = '6-month Child 2.0'



	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id in (
		SELECT Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = '6-month Adult 2.0 w/ PCMH'
	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = '6-month Adult 2.0 w/ PCMH'

	

	DELETE FROM dbo.SurveyTypeSubtype 
	WHERE surveytype_id = @SurveyType_id
	and subtype_id in (
		SELECT Subtype_id
		FROM dbo.subtype 
		WHERE SubType_nm = '6-month Child 2.0 w/ PCMH'

	)

	DELETE FROM dbo.Subtype
	WHERE SubType_nm = '6-month Child 2.0 w/ PCMH'


	declare @surveyTypeSubType_id int

	select @subtype_id = max(subtype_id) from dbo.Subtype
	select @surveyTypeSubType_id = max(surveyTypeSubType_id) from dbo.SurveyTypeSubtype

	DBCC CHECKIDENT ('dbo.SubType', RESEED, @subtype_id)
	DBCC CHECKIDENT ('dbo.SurveyTypeSubType', RESEED, @surveyTypeSubType_id) 

GO


select distinct st.* 
from dbo.Subtype st
inner join dbo.SurveyTypeSubtype stst on stst.Subtype_id = st.Subtype_id
where st.SubtypeCategory_id = 2
and stst.SurveyType_id = 4

select * 
from dbo.SurveyTypeSubtype 
where surveytype_id = 4



