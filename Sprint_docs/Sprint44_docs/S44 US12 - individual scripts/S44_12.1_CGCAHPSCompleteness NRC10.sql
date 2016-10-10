/*

	S44 12 CG-CAHPS Completeness
	As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

	Task 1 - Add new subtypes for 3.0 questionnaire types; confirm all other types already in table

	Tim Butler
*/


use qp_prod
go


begin tran

	declare @subtype_id int

	INSERT INTO dbo.subtype VALUES ('6-month Adult 3.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Child 3.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Adult 2.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Child 2.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Adult 2.0 w/ PCMH',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id) 

	INSERT INTO dbo.subtype VALUES ('6-month Child 2.0 w/ PCMH',2,0,0,1) 
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

commit tran

go



select distinct st.* 
from dbo.Subtype st
inner join dbo.SurveyTypeSubtype stst on stst.Subtype_id = st.Subtype_id
where st.SubtypeCategory_id = 2
and stst.SurveyType_id = 4

select * 
from dbo.SurveyTypeSubtype 
where surveytype_id = 4

