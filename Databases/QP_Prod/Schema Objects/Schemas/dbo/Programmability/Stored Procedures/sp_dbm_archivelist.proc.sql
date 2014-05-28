CREATE procedure sp_dbm_archivelist    
@intmonths int    
as    
    
declare @strsql varchar(2000)    
    
create table #archive    
(study_id int, survey_id int, lastmailed datetime)    
    
insert into #archive (study_id, survey_id)    
select s.study_id, survey_id    
from survey_def sd, study s    
where s.DATCONTRACTEND < dateadd(month,-intarchive_months,getdate())    
and s.study_id = sd.study_id    
and s.datarchived is null    
    
select a.survey_id, max(datmailed) as lastmailed    
into #lastmailed    
from sentmailing sm, scheduledmailing schm, mailingstep ms, #archive a    
where a.survey_id = ms.survey_id    
and ms.mailingstep_id = schm.mailingstep_id    
and schm.sentmail_id = sm.sentmail_id    
group by a.survey_id    
    
update a    
set a.lastmailed = l.lastmailed    
from #archive a, #lastmailed l    
where l.survey_id = a.survey_id    
    
update #archive    
set lastmailed = '8/6/4'    
where lastmailed is null    
    
select study_id, max(lastmailed) as lastmailed    
into #archive2    
from #archive    
group by study_id    
    
delete #archive2    
where lastmailed > dateadd(month,-@intmonths, getdate())    
    
delete archive    
where study_id not in (select study_id from #archive2)    
and archived = 0    
    
insert into archive (study_id, warning, archived)    
select study_id, 0, 0 from #archive2    
where study_id not in (select study_id from archive)    
    
drop table #archive    
drop table #archive2    
    
update a    
set a.ad = strntlogin_nm, client = strclient_nm, study = strstudy_nm    
from archive a, study s, client c, employee e    
where a.study_id = s.study_id    
and s.client_id = c.client_id    
and s.ademployee_id = e.employee_id    
    
update archive    
set warning = warning + 1    
    
delete a    
from archive a, data_set ds    
where a.study_id = ds.study_id    
and datload_dt > dateadd(month,-3,getdate())    
    
delete a    
from archive a, sampleset ss, survey_def sd    
where a.study_id = sd.study_id    
and sd.survey_id = ss.survey_id    
and ss.datsamplecreate_dt > dateadd(month,-3,getdate())    
    
declare @tolist varchar(256), @emp varchar(42)    
    
set @tolist = ''    
    
if (select count(*) from archive where warning = 1) > 0    
    
begin    
    
declare fw cursor for    
select distinct ad    
from archive where warning = 1    
and ad not in ('DCopper','JKuhr','KRinaker','KMalo','DDahab')    
    
open fw    
    
fetch next from fw into @emp    
while @@fetch_status = 0    
    
begin    
    
set @tolist = @tolist + @emp + '; '    
    
fetch next from fw into @emp    
    
end    
    
close fw    
deallocate fw    
    
set @tolist = @tolist + 'QualisysDBAEmailAlerts@NationalResearch.com'    
    
set @strsql = 'master.dbo.xp_sendmail @recipients = "' + @tolist + '", @Subject = "First Warning", @message = ' + char(10) +    
 '"The attached studies will be archived in two weeks.  To prevent this or to learn more about archiving, please reference ' +    
 'the following document: Q:\Production\Archiving.doc.", @width = 255, @query = "select ad, client, study, study_id from ' + char(10) +    
 ' qp_prod.dbo.archive where warning = 1" , @attach_results = "true"'    
    
--print @strsql    
exec (@strsql)    
    
end    
    
if (select count(*) from archive where warning = 2) > 0    
    
begin    
    
set @tolist = ''    
    
declare sw cursor for    
select distinct ad    
from archive where warning = 2    
and ad not in ('DCopper','JKuhr','KRinaker','KMalo','DDahab')    
    
open sw    
    
fetch next from sw into @emp    
while @@fetch_status = 0    
    
begin    
    
set @tolist = @tolist + @emp + '; '    
    
fetch next from sw into @emp    
    
end    
    
close sw    
deallocate sw    
    
set @tolist = @tolist + 'jfortune; QualisysDBAEmailAlerts@NationalResearch.com'    
    
set @strsql = 'master.dbo.xp_sendmail @recipients = "' + @tolist + '", @Subject = "Second and Last Warning", @message = ' + char(10) +    
 '"The attached studies will be archived in one week.  To prevent this or to learn more about archiving, please reference ' +    
 'the following document: Q:\Production\Archiving.doc.", @width = 255, @query = "select ad, client, study, study_id from ' + char(10) +    
 ' qp_prod.dbo.archive where warning = 2" , @attach_results = "true"'    
    
--print @strsql    
exec (@strsql)    
    
end    
    
if (select count(*) from archive where warning > 2) > 0    
    
begin    
    
set @strsql = 'master.dbo.xp_sendmail @recipients = "QualisysDBAEmailAlerts@NationalResearch.com", ' + char(10) +     
 ' @subject = "Studies to be archived", ' + char(10) +    
 ' @query = "select * from qp_prod.dbo.archive where warning > 2", ' + char(10) +    
 ' @attach_results = "true", @width = 255 '    
    
--print @strsql    
exec (@strsql)    
    
end


