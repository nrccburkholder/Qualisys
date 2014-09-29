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

if exists (select * from survey_def where surveytype_id = @Surveytypeid and survey_id in (select survey_id from surveysubtype where subtype_id=@Subtype_id))
	print 'There are still surveys that use the PCMH subtype. Aborting'
else
begin

	/* dbg: I don't think we want to do this. Some of these DefaultCriteriaStmt's are used for other survey/subtypes as well.
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
	*/

	/* dbg: first we want to get rid of the PCMH specific default criteria statements: */
	delete
	from SurveyTypeDefaultCriteria
	where surveytype_id = @SurveyTypeid
	and Subtype_id = @Subtype_Id

	/* dbg: and then we want to delete any records in DefaultCriteriaStmt and DefaultCriteriaClause that are no longer referenced by any survey types/subtypes */
	delete
	from defaultcriteriastmt 
	where DefaultCriteriaStmt_id not in (select DefaultCriteriaStmt_id from SurveyTypeDefaultCriteria)

	delete
	from DefaultCriteriaClause
	where DefaultCriteriaStmt_id not in (select DefaultCriteriaStmt_id from SurveyTypeDefaultCriteria)

end


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
