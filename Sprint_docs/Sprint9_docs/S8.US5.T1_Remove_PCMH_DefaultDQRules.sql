use QP_PROD

/*
S8.US5 - Remove PCMH Data from Stage and Test
As a ALLCAHPS team, we want to remove PMCH changes from Test and Stage so that the environments are in sync.
Tim Butler
*/

begin tran
go

declare @SurveyTypeid int, @Subtype_Id int
																												
select @SurveyTypeid = surveytype_id from surveytype where SurveyType_dsc='CGCAHPS'	

select @subtype_id = st.subtype_id 
from surveytypesubtype stst
inner join subtype st on st.subtype_id = stst.subtype_id
where st.Subtype_nm = 'PCMH'


delete
from DefaultCriteriaStmt
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
	from SurveyTypeDefaultCriteria
	where surveytype_id = @SurveyTypeid
	and Subtype_id = @Subtype_Id
)

delete
from DefaultCriteriaClause
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
	from SurveyTypeDefaultCriteria
	where surveytype_id = @SurveyTypeid
	and Subtype_id = @Subtype_Id
)



delete
from SurveyTypeDefaultCriteria
where surveytype_id = @SurveyTypeid
and Subtype_id = @Subtype_Id




/*
go 
commit tran		

rollback tran

*/


select *
from SurveyTypeDefaultCriteria
where surveytype_id = @SurveyTypeid
and Subtype_id = @Subtype_Id

select *
from DefaultCriteriaStmt
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
	from SurveyTypeDefaultCriteria
	where surveytype_id = @SurveyTypeid
	and Subtype_id = @Subtype_Id
)


select *
from DefaultCriteriaClause
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
	from SurveyTypeDefaultCriteria
	where surveytype_id = @SurveyTypeid
	and Subtype_id = @Subtype_Id
)
