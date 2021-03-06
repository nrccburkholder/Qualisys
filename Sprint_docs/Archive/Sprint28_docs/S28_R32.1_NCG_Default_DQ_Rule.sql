/*

R32	Hospice non- caregiver name not generated

Tim Butler


add new DQ rule DQ_NCG

delete old rules

*/

use QP_Prod

declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'
declare @DCStmtId int, @FieldId int


insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_NCG', '(POPULATIONLName IS NULL) AND (POPULATIONFName IS NULL) AND (POPULATIONADDR IS NULL) AND (POPULATIONHSP_CaregiverRel IS NULL)', 'Q')

select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_NCG' and strCriteriaString = '(POPULATIONLName IS NULL) AND (POPULATIONFName IS NULL) AND (POPULATIONADDR IS NULL) AND (POPULATIONHSP_CaregiverRel IS NULL)'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'FName'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 9, Null, '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'LName'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 9, Null, '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'Addr'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 9, Null, '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_CaregiverRel'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 9, NULL, '')



-- delete DQ_F Nm rules for this survey type
delete [QP_Prod].[dbo].[SurveyTypeDefaultCriteria]
where SurveyType_id = @hospiceId
and DefaultCriteriaStmt_id = (
		SELECT TOP 1000 [DefaultCriteriaStmt_id]
	    FROM [QP_Prod].[dbo].[DefaultCriteriaStmt]
	    where strCriteriaStmt_nm = 'DQ_F Nm'
)

-- delete DQ_L Nm rules for this survey type

delete [QP_Prod].[dbo].[SurveyTypeDefaultCriteria]
where SurveyType_id = @hospiceId
and DefaultCriteriaStmt_id = (
		SELECT TOP 1000 [DefaultCriteriaStmt_id]
	    FROM [QP_Prod].[dbo].[DefaultCriteriaStmt]
	    where strCriteriaStmt_nm = 'DQ_L Nm'
)

