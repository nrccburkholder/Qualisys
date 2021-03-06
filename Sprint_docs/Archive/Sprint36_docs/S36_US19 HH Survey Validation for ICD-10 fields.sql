/*

	S36 US9 ICD-10 - Config Manager - HH Survey Validation for ICD-10 fields	As an Implementation Associate, I want survey validation to check for the existence of ICD-10 fields in the study data structure, so that I can ensure the study is correctly set up

	Task 1 - insert records into survey validation fields table for ICD10 1 thru 6

	Tim Butler

*/


use QP_Prod

DECLARE @surveytype_id int

select @surveytype_id = surveytype_id 
FROM [QP_Prod].[dbo].SurveyType 
WHERE SurveyType_dsc = 'Home Health CAHPS'

CREATE TABLE #metafield (                                  
   [field_id] int,
   [strfield_nm] varchar(20)                                 
)   

INSERT INTO #metafield
select distinct field_id, strfield_nm 
from METAFIELD WHERE STRFIELD_NM = 'ICD10_1'

INSERT INTO #metafield
select distinct field_id, strfield_nm 
from METAFIELD WHERE STRFIELD_NM = 'ICD10_2'

INSERT INTO #metafield
select distinct field_id, strfield_nm 
from METAFIELD WHERE STRFIELD_NM = 'ICD10_3'

INSERT INTO #metafield
select distinct field_id, strfield_nm 
from METAFIELD WHERE STRFIELD_NM = 'ICD10_4'

INSERT INTO #metafield
select distinct field_id, strfield_nm 
from METAFIELD WHERE STRFIELD_NM = 'ICD10_5'

INSERT INTO #metafield
select distinct field_id, strfield_nm 
from METAFIELD WHERE STRFIELD_NM = 'ICD10_6'

begin tran

declare @field_id int, @strfield_nm varchar(20)
select top 1 @field_id = field_id, @strfield_nm = strfield_nm from #metafield
while @@rowcount>0
begin

	if not exists (select 1 from SurveyValidationFields where ColumnName = @strfield_nm and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('ENCOUNTER', @strfield_nm, @SurveyType_ID, 1)

	delete from #metafield where FIELD_ID=@field_id
	select top 1 @field_id = field_id, @strfield_nm = strfield_nm from #metafield

end

commit tran

drop table #metafield

SELECT *
  FROM [QP_Prod].[dbo].[SurveyValidationFields]
  where SurveyType_Id = @surveytype_id


