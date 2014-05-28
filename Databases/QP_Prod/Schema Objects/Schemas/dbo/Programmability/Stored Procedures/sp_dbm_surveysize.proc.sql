CREATE procedure sp_dbm_surveysize @month int, @year int
as

set transaction isolation level read uncommitted

declare @strsql varchar(8000)
set @strsql = 'delete surveysize where genmonth = ' + convert(varchar,@month) + ' and genyear = ' + convert(varchar,@year) + char(10) +
	' insert into surveysize (genyear, genmonth, study_id, papersize, numberofsurveys, totalpages) ' + char(10) +
	' select datepart(year,datprinted), datepart(month,datprinted), study_id,  ' + char(10) +
	'      papersize_nm, count(*), sum(sm.intpages) ' + char(10) +
	' from sentmailing sm, (select distinct paperconfig_id, papersize_id from paperconfigsheet) pcs, papersize ps, ' + char(10) +
	' (select distinct methodology_id, survey_id from mailingstep) ms, survey_def sd ' + char(10) +
	' where sm.paperconfig_id = pcs.paperconfig_id ' + char(10) +
	'    and pcs.papersize_id = ps.papersize_id ' + char(10) +
	'    and datepart(month,datprinted) = ' + convert(varchar,@month) + char(10) +
	'    and datepart(year,datprinted) = ' + convert(varchar,@year) + char(10) +
	'    and sm.methodology_id = ms.methodology_id ' + char(10) +
	'    and ms.survey_id = sd.survey_id ' + char(10) +
	' group by datepart(year,datprinted) , datepart(month,datprinted), study_id, papersize_nm  ' + char(10) +
	' union  ' + char(10) +
	' select datepart(year,datprinted), datepart(month,datprinted), study_id,  ' + char(10) +
	'      ''PostCard'', count(*), sum(sm.intpages) ' + char(10) +
	' from sentmailing sm, (select distinct methodology_id, survey_id from mailingstep) ms, survey_def sd ' + char(10) +
	' where paperconfig_id = 23 ' + char(10) +
	'    and datepart(month,datprinted) = ' + convert(varchar,@month) + char(10) +
	'    and datepart(year,datprinted) = ' + convert(varchar,@year) + char(10) +
	'    and sm.methodology_id = ms.methodology_id ' + char(10) +
	'    and ms.survey_id = sd.survey_id ' + char(10) +
	' group by datepart(year,datprinted) , datepart(month,datprinted) , study_id ' + char(10) +
	' order by datepart(year,datprinted) , datepart(month,datprinted) , papersize_nm  ' +char(10) +
	' select papersize_nm, study_id, count(*) as returns ' + char(10) +
	' into #ret ' + char(10) +
	' from sentmailing sm, (select distinct paperconfig_id, papersize_id from paperconfigsheet) pcs, papersize ps, questionform qf, survey_def sd ' + char(10) +
	' where sm.paperconfig_id = pcs.paperconfig_id ' + char(10) +
	'    and pcs.papersize_id = ps.papersize_id ' + char(10) +
	'    and datepart(month,datprinted) = ' + convert(varchar,@month) + char(10) +
	'    and datepart(year,datprinted) = ' + convert(varchar,@year) + char(10) +
	'    and sm.sentmail_id = qf.sentmail_id ' + char(10) +
	'    and qf.survey_id = sd.survey_id ' + char(10) +
	'    and qf.datreturned is not null ' + char(10) +
	' group by papersize_nm, study_id ' + char(10) +
	' select ''PostCard'' as papersize, study_id, count(*) as undeliverables ' + char(10) +
	' into #undel ' + char(10) +
	' from sentmailing sm, scheduledmailing schm, mailingstep ms, survey_def sd ' + char(10) +
	' where sm.paperconfig_id = 23 ' + char(10) +
	'    and datepart(month,datprinted) = ' + convert(varchar,@month) + char(10) +
	'    and datepart(year,datprinted) = ' + convert(varchar,@year) + char(10) +
	'    and sm.sentmail_id = schm.sentmail_id ' + char(10) +
	'    and schm.mailingstep_id = ms.mailingstep_id ' + char(10) +
	'    and ms.survey_id = sd.survey_id ' + char(10) +
	'    and sm.datundeliverable is not null ' + char(10) +
	' group by study_id ' + char(10) +
	' union ' + char(10) +
	' select papersize_nm, study_id, count(*) as undeliverables ' + char(10) +
	' from sentmailing sm, (select distinct paperconfig_id, papersize_id from paperconfigsheet) pcs, papersize ps, questionform qf, survey_def sd ' + char(10) +
	' where sm.paperconfig_id = pcs.paperconfig_id ' + char(10) +
	'    and pcs.papersize_id = ps.papersize_id ' + char(10) +
	'    and datepart(month,datprinted) = ' + convert(varchar,@month) + char(10) +
	'    and datepart(year,datprinted) = ' + convert(varchar,@year) + char(10) +
	'    and sm.sentmail_id = qf.sentmail_id ' + char(10) +
	'    and qf.survey_id = sd.survey_id ' + char(10) +
	'    and sm.datundeliverable is not null ' + char(10) +
	' group by papersize_nm, study_id ' + char(10) +
	' select study_id, count(*) as targets ' + char(10) +
	' into #t ' + char(10) +
	' from survey_def sd, sampleplan sp, sampleunit su ' + char(10) +
	' where sd.survey_id = sp.survey_id ' + char(10) +
	' and sp.sampleplan_id = su.sampleplan_id ' + char(10) +
	' and su.inttargetreturn > 0 ' + char(10) +
	' group by study_id ' + char(10) +
	' select study_id, count(*) as notargets ' + char(10) +
	' into #n ' + char(10) +
	' from survey_def sd, sampleplan sp, sampleunit su ' + char(10) +
	' where sd.survey_id = sp.survey_id ' + char(10) +
	' and sp.sampleplan_id = su.sampleplan_id ' + char(10) +
	' and su.inttargetreturn = 0 ' + char(10) +
	' group by study_id ' + char(10) +
	' update ss ' + char(10) +
	' set targetunits = targets ' + char(10) +
	' from surveysize ss, #t t ' + char(10) +
	' where t.study_id = ss.study_id ' + char(10) +
	' and genmonth = ' + convert(varchar,@month) + char(10) +
	' and genyear = ' + convert(varchar,@year) + char(10) +
	' update ss ' + char(10) +
	' set notargetunits = notargets ' + char(10) +
	' from surveysize ss, #n t ' + char(10) +
	' where t.study_id = ss.study_id ' + char(10) +
	' and genmonth = ' + convert(varchar,@month) + char(10) +
	' and genyear = ' + convert(varchar,@year) + char(10) +
	' update surveysize ' + char(10) +
	' set notargetunits = 0 ' + char(10) +
	' where notargetunits is null ' + char(10) +
	' update ss ' + char(10) +
	' set ss.returns = tr.returns ' + char(10) +
	' from surveysize ss, #ret tr ' + char(10) +
	' where tr.study_id = ss.study_id ' + char(10) +
	' and tr.papersize_nm = ss.papersize ' + char(10) +
	' and genmonth = ' + convert(varchar,@month) + char(10) +
	' and genyear = ' + convert(varchar,@year) + char(10) +
	' update ss ' + char(10) +
	' set ss.undeliverable = tr.undeliverables ' + char(10) +
	' from surveysize ss, #undel tr ' + char(10) +
	' where tr.study_id = ss.study_id ' + char(10) +
	' and tr.papersize = ss.papersize ' + char(10) +
	' and genmonth = ' + convert(varchar,@month) + char(10) +
	' and genyear = ' + convert(varchar,@year) + char(10) +
	' update surveysize ' + char(10) +
	' set returns = 0 ' + char(10) +
	' where returns is null ' + char(10) +
	' update surveysize ' + char(10) +
	' set undeliverable = 0 ' + char(10) +
	' where undeliverable is null ' + char(10) +
	' update ss ' + char(10) +
	' set ss.client_id = s.client_id, ss.strclient_nm = c.strclient_nm ' + char(10) +
	' from surveysize ss, study s, client c ' + char(10) +
	' where ss.study_id = s.study_id ' + char(10) +
	' and s.client_id = c.client_id ' + char(10) +
	' drop table #ret ' + char(10) +
	' drop table #undel ' + char(10) +
	' drop table #t ' + char(10) +
	' drop table #n ' 
--print @strsql
exec (@strsql)


