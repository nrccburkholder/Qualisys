create procedure dbo.sp_TestPrintLitho
  @strLithos varchar(1000), @employee varchar(20)
as
set @strLithos=replace(@strLithos,'''','')
set @strLithos=replace(@strLithos,' ','')
set @strLithos=''''+replace(@strLithos,',',''',''')+''''

declare @sql varchar(8000)
set @SQL='insert into scheduled_tp
select sp.study_id, mm.survey_id, sp.sampleset_id, sp.pop_id, sm.methodology_id, sc.mailingstep_id, null as overrideitem_id, sm.langid, 
0 as bitMockup,  null as strSections, e.stremail, e.employee_id, 0 as bitDone, dateadd(ms,mm.survey_id,getdate()) as datScheduled
from sentmailing sm, mailingmethodology mm, samplepop sp, scheduledmailing sc, employee e
where sm.strlithocode in ('+@strlithos+')
and sm.methodology_id=mm.methodology_id
and sm.sentmail_id=sc.sentmail_id
and sc.samplepop_id=sp.samplepop_id
and e.strNTLogin_nm='''+@employee+''''

exec (@SQL)


