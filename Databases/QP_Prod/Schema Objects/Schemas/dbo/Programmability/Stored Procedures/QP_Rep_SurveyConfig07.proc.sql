CREATE PROCEDURE QP_Rep_SurveyConfig07  
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50),  
 @Survey varchar(50)  
AS  
set transaction isolation level read uncommitted  
Declare @intStudy_id int, @intSurvey_id int  
select @intStudy_id=s.study_id, @intSurvey_id=sd.survey_id  
from study s, client c, survey_def sd  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and c.client_id=s.client_id  
  and s.study_id=sd.study_id  
  and sd.strsurvey_nm=@survey  
  
/*select t.Tag, isnull(mt.strtable_nm+'.'+mf.strfield_nm,tf.strReplaceLiteral) as [Assigned Field/Literal]  
from tag T, metatable mt right outer join tagfield TF left outer join metafield mf on tf.field_id=mf.field_id on tf.table_id=mt.table_id  
where tf.study_id=@intstudy_id  
  and tf.tag_id=t.tag_id  
order by upper(t.tag)  
*/  
  
--  5/24/1 BD to show where the tags are used and the code associated.  
-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (
	select distinct 'Survey Configuration' AS SheetNameDummy, ct.code, upper(t.Tag) as Tag, 
	isnull(mt.strtable_nm+'.'+mf.strfield_nm,tf.strReplaceLiteral) as [Assigned Field/Literal], convert(varchar(10),qstncore) as Location  
	from tag T, codetexttag ctt, codestext ct, codeqstns cq, sel_qstns sq, metatable mt right outer join tagfield TF left outer join metafield mf   
	on tf.field_id=mf.field_id   
	on tf.table_id=mt.table_id  
	where tf.study_id=@intStudy_id  
	  and tf.tag_id=t.tag_id  
	  and t.tag_id = ctt.tag_id  
	  and ctt.codetext_id = ct.codetext_id  
	  and ct.code = cq.code  
	  and cq.survey_id = @intSurvey_id  
	  and cq.selqstns_id=sq.selqstns_id  
	  and cq.survey_id = sq.survey_id  
	  and cq.language = sq.language  
	union  
	select distinct 'Survey Configuration' AS SheetNameDummy, ct.code, upper(t.Tag) as Tag, 
	isnull(mt.strtable_nm+'.'+mf.strfield_nm,tf.strReplaceLiteral) as [Assigned Field/Literal], 'TextBox' as Location  
	from tag T, codetexttag ctt, codestext ct, codetxtbox cq, metatable mt right outer join tagfield TF left outer join metafield mf   
	on tf.field_id=mf.field_id   
	on tf.table_id=mt.table_id  
	where tf.study_id=@intStudy_id  
	  and tf.tag_id=t.tag_id  
	  and t.tag_id = ctt.tag_id  
	  and ctt.codetext_id = ct.codetext_id  
	  and ct.code = cq.code  
	  and survey_id = @intSurvey_id
		)

	select distinct 'Survey Configuration' AS SheetNameDummy, ct.code, upper(t.Tag) as Tag, 
	isnull(mt.strtable_nm+'.'+mf.strfield_nm,tf.strReplaceLiteral) as [Assigned Field/Literal], convert(varchar(10),qstncore) as Location  
	from tag T, codetexttag ctt, codestext ct, codeqstns cq, sel_qstns sq, metatable mt right outer join tagfield TF left outer join metafield mf   
	on tf.field_id=mf.field_id   
	on tf.table_id=mt.table_id  
	where tf.study_id=@intStudy_id  
	  and tf.tag_id=t.tag_id  
	  and t.tag_id = ctt.tag_id  
	  and ctt.codetext_id = ct.codetext_id  
	  and ct.code = cq.code  
	  and cq.survey_id = @intSurvey_id  
	  and cq.selqstns_id=sq.selqstns_id  
	  and cq.survey_id = sq.survey_id  
	  and cq.language = sq.language  
	union  
	select distinct 'Survey Configuration' AS SheetNameDummy, ct.Code, upper(t.Tag) as Tag, 
	isnull(mt.strtable_nm+'.'+mf.strfield_nm,tf.strReplaceLiteral) as [Assigned Field/Literal], 'TextBox' as Location  
	from tag T, codetexttag ctt, codestext ct, codetxtbox cq, metatable mt right outer join tagfield TF left outer join metafield mf   
	on tf.field_id=mf.field_id   
	on tf.table_id=mt.table_id  
	where tf.study_id=@intStudy_id  
	  and tf.tag_id=t.tag_id  
	  and t.tag_id = ctt.tag_id  
	  and ctt.codetext_id = ct.codetext_id  
	  and ct.code = cq.code  
	  and survey_id = @intSurvey_id  
	order by ct.code, upper(t.Tag), isnull(mt.strtable_nm+'.'+mf.strfield_nm,tf.strReplaceLiteral)   
ELSE
	select distinct 'Survey Configuration' AS SheetNameDummy, '' AS Code, '' as Tag, '' as [Assigned Field/Literal], '' as Location  
  
update dashboardlog   
set procedureend = getdate()  
where report = 'Survey Configuration'  
and associate = @associate  
and client = @client  
and study = @study  
and survey = @survey  
and procedureend is null  
  
set transaction isolation level read committed


