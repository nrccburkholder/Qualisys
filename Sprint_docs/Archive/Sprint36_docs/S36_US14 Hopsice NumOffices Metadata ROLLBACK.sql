/*

S36 US14 Hospice - Num Offices Metafield	As an Implementation Associate, I want a new metafield to store the number of offices, so that we can store this required data

Task 1 - create new metafield and add to required fields in survey validation

Tim Butler

ROLLBACK

*/

use QP_Prod

begin tran

DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'Hospice CAHPS'


declare @fldGroupId int
select @fldGroupId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Hospice CAHPS Enc'


if exists (select 1 from METAFIELD WHERE STRFIELD_NM = 'HSP_NumOffices')
	delete from METAFIELD
	WHERE STRFIELD_NM = STRFIELD_NM = 'HSP_NumOffices'


if exists (select 1 from SurveyValidationFields where ColumnName = 'HSP_NumOffices' and SurveyType_id = @SurveyType_ID)
	Delete from SurveyValidationFields
	WHERE TableName = 'Encounter'
	and ColumnName = 'HSP_NumOffices'

commit tran


