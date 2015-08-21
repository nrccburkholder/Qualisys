/*

S32 Hospice LOS DQ Rule Update	Story: As a certified Hospice CAHPS vendor, we want to refrain from sampling decedents that don’t have an admission date, so that we can administer and submit the survey properly.

Background: The current DQ rule is “(ENCOUNTERLengthOfStay < 2)”, but when AdmitDate is NULL LengthOfStay is also NULL, and these records do not get disqualified. 

Solution:  Modify DQ rule to (ENCOUNTERLengthOfStay < 2) OR (ENCOUNTERLengthOfStay IS NULL)

Task 14.1	modify the Hospice CAHPS default DQ rule 
Task 14.2	alter existing Hospice CAHPS survey DQ rules


Tim Butler


modify DQ_LOS

*/

use qp_prod


go

begin tran

declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'
declare @DCStmtId int, @FieldId int
declare @dq_name varchar(20) = 'DQ_LOS'

SELECT * 
FROM DefaultCriteriaStmt
where strCriteriaStmt_nm = @dq_name

select *
from DefaultCriteriaClause
WHERE DefaultCriteriaStmt_id in (SELECT DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @dq_name)

select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @dq_name

UPDATE DefaultCriteriaStmt
	SET strCriteriaString = '(ENCOUNTERLengthOfStay < 2) OR (ENCOUNTERLengthOfStay IS NULL)'
WHERE DefaultCriteriaStmt_id = @DCStmtId

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'LengthOfStay'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 9, Null, '')

commit tran

SELECT * 
FROM DefaultCriteriaStmt
where strCriteriaStmt_nm = @dq_name

select *
from DefaultCriteriaClause
WHERE DefaultCriteriaStmt_id in (SELECT DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @dq_name)

--rollback tran


