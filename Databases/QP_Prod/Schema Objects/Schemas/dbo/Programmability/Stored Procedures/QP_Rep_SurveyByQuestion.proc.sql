CREATE procedure QP_Rep_SurveyByQuestion
 @Associate varchar(50),
 @Client varchar(50)
as
set transaction isolation level read uncommitted
select distinct sq.QstnCore, sq.Label
into #XQstn
from sel_qstns sq, survey_def sd, study s, client c
where subtype=1
  and sq.survey_id=sd.survey_id
  and sd.study_id=s.study_id
  and s.client_id=c.client_id
  and c.strclient_nm = @Client

declare curSvy cursor for
  select convert(varchar,survey_id), rtrim (strSurvey_nm) --case when strsurvey_nm = '' then 'XXXX' else rtrim(strSurvey_nm) end
  from survey_def sd, study s, client c
  where sd.study_id=s.study_id
    and s.client_id=c.client_id
    and c.strclient_nm = @Client
    and sd.strsurvey_nm <> ''

declare @survey_id varchar(10), @survey_nm varchar(15), @SQL varchar(8000)

open curSvy
fetch next from curSvy into @survey_id, @survey_nm
while @@fetch_status = 0
begin
  select @SQL = 'Alter table #XQstn add [' + @survey_nm+' ('+@survey_id+')] char(6) NULL Constraint [' + @survey_id+@survey_nm+'Dflt] Default '' '' with values'
print @sql  
  exec (@SQL)
  select @SQL = 'update #XQstn set [' + @survey_nm+' ('+@survey_id+')] = convert(varchar,sq.section_id)+''.''+right(''0''+convert(varchar,sq.subsection),2) from sel_qstns sq where #xqstn.qstncore=sq.qstncore and sq.survey_id='+@survey_id+' and subtype=1'




  exec (@SQL)
  fetch next from curSvy into @survey_id, @survey_nm
end

close curSvy
deallocate curSvy

select * from #XQstn
drop table #xQstn
set transaction isolation level read committed


