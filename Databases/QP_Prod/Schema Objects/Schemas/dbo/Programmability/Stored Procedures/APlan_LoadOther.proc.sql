CREATE procedure APlan_LoadOther
  @cutoff int, @OtherCutoff int, @WhereClause varchar(255) = 'samptype=''D'''
as
declare @survey_id int, @OtherSurvey_id int, @study_id int, @OtherStudy_id int
select @othersurvey_id=survey_id from cutoff where cutoff_id=@otherCutoff
select @otherstudy_id=study_id from survey_def where survey_id=@othersurvey_id
select @survey_id=survey_id from cutoff where cutoff_id=@Cutoff
select @study_id=study_id from survey_def where survey_id=@survey_id
if @survey_id=@othersurvey_id
  declare curQstn cursor for
    select right('00000'+convert(varchar,qstncore),6) from sel_qstns where survey_id=@survey_id and subtype=1 and language=1
else
  declare curQstn cursor for
    select right('00000'+convert(varchar,qstncore),6) from sel_qstns where survey_id in (@survey_id,@othersurvey_id) and subtype=1 and language=1 group by qstncore having count(*)=2

declare @strCore char(6), @SQL varchar(8000)
Open curQstn
Fetch next from curQstn
  into @strCore  
set @SQL='SampUnit, SampType, lithocd, age, sex'
while @@fetch_status=0
begin
  set @SQL = @SQL + ', Q' + @strCore
  Fetch next from curQstn
    into @strCore  
end
close curQstn
deallocate curQstn
declare @SampSet int
-- #aggregate uses the SampSet column to find the survey_id
select top 1 @SampSet = sampleset_id from sampleset where survey_id=@survey_id
set @SQL = 'INSERT INTO #MRD (SampSet, ' + @SQL + ') SELECT '+convert(varchar,@sampset)+','+@SQL+' FROM S'+convert(varchar,@otherstudy_id)+'.MRD_'+convert(varchar,@othercutoff) + ' where ' + @WhereClause
exec (@SQL)


