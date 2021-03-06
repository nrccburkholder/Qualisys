/*

	S36 US9 ICD-10 - Config Manager - HH Survey Validation for ICD-10 fields	As an Implementation Associate, I want survey validation to check for the existence of ICD-10 fields in the study data structure, so that I can ensure the study is correctly set up

	Task 1 - insert records into survey validation fields table for ICD10 1 thru 6

	Tim Butler

	ROLLBACK

*/


use QP_Prod

DECLARE @surveytype_id int

select @surveytype_id = surveytype_id 
FROM [QP_Prod].[dbo].SurveyType 
WHERE SurveyType_dsc = 'Home Health CAHPS'

select distinct field_id, strfield_nm 
INTO #metafield
from METAFIELD WHERE STRFIELD_NM like 'ICD10%'

begin tran

declare @field_id int, @strfield_nm varchar(20)
select top 1 @field_id = field_id, @strfield_nm = strfield_nm from #metafield
while @@rowcount>0
begin

	if exists (select 1 from SurveyValidationFields where ColumnName = @strfield_nm and SurveyType_id = @SurveyType_ID)
		Delete from SurveyValidationFields
		WHERE TableName = 'Encounter'
		and ColumnName = @strfield_nm

	delete from #metafield where FIELD_ID=@field_id
	select top 1 @field_id = field_id, @strfield_nm = strfield_nm from #metafield

end

commit tran

drop table #metafield

SELECT *
  FROM [QP_Prod].[dbo].[SurveyValidationFields]
  where SurveyType_Id = @surveytype_id


