--=======================================================


CREATE procedure qp_rep_CommentsKeyed  
@Associate varchar(50),  
@StartDate datetime,  
@EndDate datetime  
as  

-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  


set transaction isolation level read uncommitted  
declare @SQL varchar(1000)  
  
create table #results (Contract_Number varchar(9), Project_Number varchar(5), Comments_Keyed int)  
  
set @SQL = 'insert into #results' +char(10)+  
'select isnull(sd.Contract, ''Missing'') as ContractNumber, left(ss.strsamplesurvey_nm,4) as Project_Number, count(*)' +char(10)+  
'from comments c, questionform qf, samplepop sp, sampleset ss, survey_Def sd' +char(10)+  
'where c.questionform_id = qf.questionform_id' +char(10)+  
'and qf.samplepop_id = sp.samplepop_id' +char(10)+  
'and sp.sampleset_id = ss.sampleset_id' +char(10)+  
'and ss.Survey_Id = sd.survey_ID' +char(10)+ 
'and convert(varchar(10),c.datentered,120) between ''' + convert(varchar(10),@StartDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + '''' +char(10)+  
'group by sd.Contract, left(ss.strsamplesurvey_nm,4)' +char(10)+  
'order by sd.Contract, left(ss.strsamplesurvey_nm,4)'  
exec(@SQL)  
  
set @SQL = 'insert into #results' +char(10)+  
'select ''Total'', ''Total'', count(*)' +char(10)+  
'from comments c, questionform qf, samplepop sp, sampleset ss' +char(10)+  
'where c.questionform_id = qf.questionform_id' +char(10)+  
'and qf.samplepop_id = sp.samplepop_id' +char(10)+  
'and sp.sampleset_id = ss.sampleset_id' +char(10)+  
'and convert(varchar(10),c.datentered,120) between ''' + convert(varchar(10),@StartDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + ''''   
exec(@SQL)  
  
select * from #results  
drop table #results  
  
set transaction isolation level read committed


