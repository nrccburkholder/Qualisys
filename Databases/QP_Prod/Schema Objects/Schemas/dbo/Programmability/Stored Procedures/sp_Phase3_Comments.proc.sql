CREATE procedure sp_Phase3_Comments
as

declare @extract datetime, @strsql varchar(2000)

set @extract = getdate()

select cmnt_id into #c from comments where datreported is null

/* Modified 12-10-01 JJF
update c
set datreported = @extract
from #c t, comments c, questionform qf, survey_def sd 
where t.cmnt_id = c.cmnt_id
  and c.questionform_id = qf.questionform_id
  and qf.survey_id = sd.survey_id
  and sd.study_id = 479 */
update c
set datreported = @extract
from #c t, comments c, questionform qf, survey_def sd, study st
where t.cmnt_id = c.cmnt_id
  and c.questionform_id = qf.questionform_id
  and qf.survey_id = sd.survey_id
  and sd.study_id = st.study_id
  and st.client_id = 253

set @strsql = 'drop view phase3_comments'
exec (@strsql)
set @strsql = 'drop view phase3_commentselcodes'
exec (@strsql)
set @strsql = 'drop view phase3_commentcodes'
exec (@strsql)
set @strsql = 'drop view phase3_unscaled'
exec (@strsql)


set @strsql = 'create view phase3_comments ' + char(10) +
	' as ' + char(10) +
	' select cmnt_id, strlithocode as lithocode, strcmnttext, sd.study_id, sd.survey_id, datreported, strcmnttype_nm as commenttype, ' + char(10) +
	' strcmntvalence_nm as commentvalence, qstncore, strsampleunit_nm, strcmntorhand, ss.sampleunit_id ' + char(10) +
	' from comments c, questionform qf, sentmailing sm, survey_def sd, commenttypes ct, commentvalences cv, selectedsample ss, ' + char(10) + 
	' samplepop sp, sampleunit su ' + char(10) +
	' where c.datreported = ''' + convert(varchar,@extract,113) + '''' + char(10) +
	' and c.questionform_id = qf.questionform_id ' + char(10) +
	' and qf.survey_id = sd.survey_id ' + char(10) +
	' and qf.sentmail_id = sm.sentmail_id ' + char(10) +
	' and c.cmnttype_id = ct.cmnttype_id ' + char(10) +
	' and qf.samplepop_id = sp.samplepop_id ' + char(10) +
	' and sp.sampleset_id = ss.sampleset_id ' + char(10) +
	' and sp.pop_id = ss.pop_id ' + char(10) +
	' and ss.intextracted_flg = 1 ' + char(10) +
	' and ss.sampleunit_id = su.sampleunit_id ' + char(10) +
/* Modified 12-10-01 JJF
	' and c.cmntvalence_id = cv.cmntvalence_id ' + char(10) +
	' and study_id = 479 ' */
	' and c.cmntvalence_id = cv.cmntvalence_id '
/* End of modification 12-10-01 JJF 
-- added to accomodate the team incorrectly sampling.  A new survey is to be setup to replace 1249
	' and sd.survey_id != 1249 ' */

--print @strsql
exec (@strsql)

set @strsql = 'create view phase3_commentselcodes ' + char(10) +
	' as ' + char(10) +
	' select distinct c.cmnt_id, cmntcode_id' + char(10) +
	' from comments c, commentselcodes csc ' + char(10) +
	' where c.datreported = ''' + convert(varchar,@extract,113) + '''' + char(10) +
	' and c.cmnt_id = csc.cmnt_id '

--print @strsql
exec (@strsql)

set @strsql = 'create view phase3_commentcodes ' + char(10) +
	' as ' + char(10) +
/* Modified 12-10-01 JJF
        ' select distinct cc.CmntCode_id, cc.strCmntCode_Nm as strCmntCode_Nm ' + char(10) +
        ' from Comments cm, CommentSelCodes cs, CommentCodes cc, QuestionForm qf, Survey_Def sd ' + char(10) + 
        ' where cm.QuestionForm_id = qf.QuestionForm_id ' + char(10) +
        '   and qf.Survey_id = sd.Survey_id ' + char(10) +
        '   and sd.Study_id = 479 ' + char(10) +
        '   and cm.Cmnt_id = cs.Cmnt_id ' + char(10) +
        '   and cs.CmntCode_id = cc.CmntCode_id ' */
        ' select distinct cc.CmntCode_id, cc.strCmntCode_Nm as strCmntCode_Nm ' + char(10) +
        ' from Comments cm, CommentSelCodes cs, CommentCodes cc, QuestionForm qf, Survey_Def sd, Study st ' + char(10) +
        ' where cm.QuestionForm_id = qf.QuestionForm_id ' + char(10) +
        '   and qf.Survey_id = sd.Survey_id ' + char(10) +
        '   and sd.Study_id = st.Study_id ' + char(10) +
        '   and st.Client_id = 253 ' + char(10) +
        '   and cm.Cmnt_id = cs.Cmnt_id ' + char(10) +
        '   and cs.CmntCode_id = cc.CmntCode_id '

--print @strsql
exec (@strsql)


set @strsql = 'create view phase3_unscaled ' + char(10) +
	' as ' + char(10) +
	' select distinct sd.survey_id, qstncore, "Please provide comments/suggestions for improving services" as questionlabel, "C" as strcmntorhand ' + char(10) +
	' from survey_def sd, sel_qstns sq ' + char(10) +
	' where sd.survey_id = sq.survey_id ' + char(10) +
	' and sq.subtype = 4 ' + char(10) +
	' and sq.language = 1 ' + char(10) +
	' and sq.qstncore <> 0 ' + char(10) +
	' and sq.height > 0 ' + char(10) +
	' union ' + char(10) + 
	' select distinct sd.survey_id, 0 as qstncore, "Attached Comment" as questionlabel, "A" as strcmntorhand ' + char(10) +
	' from survey_def sd, sel_qstns sq ' + char(10) +
	' where sd.survey_id = sq.survey_id ' 

--print @strsql
exec (@strsql)


