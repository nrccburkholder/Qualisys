CREATE procedure qp_rep_CommentsQASurvey
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @StartDate datetime,
 @EndDate datetime
as
set transaction isolation level read uncommitted

declare @SQL varchar(500)--, @intsurvey_id int, @startdate datetime, @enddate datetime
--set @intsurvey_id = 1441
--set @startdate = '4/25/02'
--set @enddate = '4/29/02'

Declare @intSurvey_id int, @intStudy_id int
select @intSurvey_id=sd.survey_id, @intStudy_id=sd.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

create table #QFList (DateEntered char(10), strLithoCode varchar(10), QuestionForm_id int, Cmnt_id int, BitDone bit)
create table #Results (DateEntered char(10), LithoCode varchar(10), CmntType varchar(15), CmntValence varchar(10), CmntCode varchar(50), CmntTextUM text)
set @sql = 'insert into #QFList' +char(10)+
'select convert(char(10),c.datentered,120), sm.strlithocode, qf.questionform_id, c.cmnt_id, 0'+char(10)+
'from comments c, questionform qf, sentmailing sm'+char(10)+
'where c.questionform_id = qf.questionform_id'+char(10)+
'and qf.sentmail_id = sm.sentmail_id'+char(10)+
'and qf.survey_id =' + convert(varchar,@intsurvey_id)+char(10)+
'and c.datentered >= '''+convert(char(10),@StartDate,120)+''''+char(10)+
'and c.datentered <= '''+convert(char(10),@EndDate,120)+''''+char(10)+
'order by c.datentered, sm.strlithocode'
exec(@SQL)

declare @QFID int, @Cmnt_id int
set nocount on
declare qflist cursor for select questionform_id,cmnt_id from #QFList where bitdone = 0 order by convert(datetime,dateentered) asc, strlithocode
open qflist
fetch next from qflist into @QFID, @Cmnt_id
while @@fetch_status = 0 
begin
 insert into #Results 
 select convert(char(10),q.dateentered,120), q.strlithocode, ct.strcmnttype_nm, cv.strCmntValence_nm, '', case when convert(varchar,c.strcmnttextum) is null or convert(varchar,c.strcmnttextum) = '' then c.strCmntText else c.strcmnttextUM end
 from #QFlist q, comments c, commentvalences cv, commenttypes ct
 where q.questionform_id = c.questionform_id
 and q.cmnt_id = c.cmnt_id
 and c.CmntValence_id = cv.CmntValence_id
 and c.cmnttype_id = ct.cmnttype_id
 and c.questionform_id = @qfid
 and c.cmnt_id = @cmnt_id

 insert into #Results 
 select '','','','', cc.strCmntCode_nm + ' ('+convert(varchar,cc.cmntcode_id)+')', ''
 from comments c, commentcodes cc, commentselcodes cs
 where c.cmnt_id = cs.cmnt_id
 and cs.cmntcode_id = cc.cmntcode_id
 and c.questionform_id = @qfid
 and c.cmnt_id = @cmnt_id

 fetch next from qflist into @QFID, @Cmnt_id
end
set nocount off
close qflist
deallocate qflist
select * from #results

drop table #results
drop table #qflist

set transaction isolation level read committed


