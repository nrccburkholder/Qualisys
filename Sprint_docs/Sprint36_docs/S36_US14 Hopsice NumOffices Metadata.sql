/*

S36 US14 Hospice - Num Offices Metafield	As an Implementation Associate, I want a new metafield to store the number of offices, so that we can store this required data

Task 1 - create new metafield and add to required fields in survey validation

Tim Butler

*/

use QP_Prod

begin tran

DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'Hospice CAHPS'


declare @fldGroupId int
select @fldGroupId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Hospice CAHPS Enc'


if not exists (select 1 from METAFIELD WHERE STRFIELD_NM = 'HSP_NumOffices')
	insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
	values ('HSP_NumOffices','Number of administrative offices per CCN, for Hospice CAHPS',@fldGroupId,'I',NULL,NULL,NULL,'NumOffc',0,0,NULL,NULL,0)



if not exists (select 1 from SurveyValidationFields where ColumnName = 'HSP_NumOffices' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter', 'HSP_NumOffices', @SurveyType_ID, 1)


commit tran


