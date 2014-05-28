CREATE procedure qp_rep_TOCLFreq  
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50),  
 @Survey varchar(50),  
 @FirstSampleSet datetime,  
 @LastSampleSet datetime  
as  
set transaction isolation level read uncommitted  
  
declare @SQL varchar(2000), @Study_id int, @Survey_id int  
select @survey_id = survey_id from clientstudysurvey_view where strclient_nm = @client and strstudy_nm = @study and strsurvey_nm = @survey  
select @study_id = study_id from survey_def where survey_id = @survey_id  

--DRM 9/13/2010 Moved "if exists" outside of dynamic sql to keep query from failing.
if exists(select strfield_nm from metadata_view where study_id = @Study_id and strfield_nm = 'TOCL')
begin
set @SQL = '
 select strDisposition_nm as Reason, count (*) as Amount   
 from s'+convert(varchar,@Study_id)+'.population p, samplepop sp, tocldispositions td, sampleset ss  
 where sp.pop_id = p.pop_id   
 and p.tocl = td.disposition_id  
 and sp.sampleset_id = ss.sampleset_id  
 and convert(varchar,ss.datsamplecreate_dt,120) between '''+convert(varchar,@FirstSampleSet,120)+''' and '''+convert(varchar,@LastSampleSet,120)+'''  
 group by strDisposition_nm, TOCL  
 order by strDisposition_nm, TOCL  
 compute sum(count(*))  
'  
exec(@SQL)  
--select (@SQL)  
end
else select 'No TOCL field for this study'  

set transaction isolation level read committed  
/*  
sp_helptext qp_rep_people_sampled  
  
*/


