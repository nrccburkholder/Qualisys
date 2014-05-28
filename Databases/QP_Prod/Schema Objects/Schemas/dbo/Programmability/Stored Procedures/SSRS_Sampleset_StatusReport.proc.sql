CREATE proc SSRS_Sampleset_StatusReport (@Study_ID int, @Survey_ID varchar(8000) = null, @Samplesets varchar(8000) = null, @datEncStart Datetime = null, @datEncEnd DateTime = null)  
as  
  
  
--================================================================================  
--Debug Code  
--Declare @Study_ID int, @Survey_ID int   
--declare @Samplesets varchar(8000), @datEncStart Datetime, @datEncEnd DateTime  
--set @Study_ID =  1468  
--set @Survey_ID = '8498'  
----set @Samplesets = '349,275'  
----set @datEncStart = null  
----set @datEncEnd = null  
----or  
--set @Samplesets = null  
--set @datEncStart = '2009-01-01 00:00:00.000'  
--set @datEncEnd = '2009-06-01 00:00:00.000'  
  
--Eample Run code  
--run with dates  
--SSRS_Sampleset_StatusReport 1468, 8498, null, '2009-01-01 00:00:00.000', '2009-04-01 00:00:00.000'  
  
--run with selected samplesets  
--SSRS_Sampleset_StatusReport 11, 64, '477174,478795,481109'  
  
  
--================================================================================  
  
declare @SQL varchar(8000)  
  
Create Table #Results   
(  
Client_ID int,  
ClientName varchar(200),  
Study_ID int,  
StudyName varchar(200),  
Survey_ID int,  
SurveyName varchar(300),  
Sampleset_ID int,  
datSamplesetCreateDate datetime,  
datEncDate_From datetime,  
datEncDate_To datetime,  
datFileSent datetime,  
datFirstActionTaken datetime,  
datProjComplete datetime,  
SampledCount int,  
StartedCount int,  
FinalCount int,  
ReturnedCount int  
)  
  
Create Table #SampleSets (Sampleset_ID int)  
  
  
  
if @Samplesets is not null   
 begin  
  set @SQL = '  
  insert into #SampleSets  
  select distinct Sampleset_ID     
  from Sampleset  
  where Sampleset_ID in (' + @Samplesets + ')'  
  
  print @SQL  
  exec (@SQL)  
 end  
else if @datEncStart is not null and @datEncEnd is not null   
 begin  
  set @SQL = '  
  insert into #SampleSets  
  select distinct Sampleset_ID     
  from Sampleset  
  where ((datDateRange_FromDate >= ''' + cast(@datEncStart as varchar(100)) + ''' and datDateRange_FromDate <= ''' + cast(@datEncEnd as varchar(100)) + ''') or  
    (datDateRange_ToDate >= ''' + cast(@datEncStart as varchar(100)) + ''' and datDateRange_ToDate <= ''' + cast(@datEncEnd as varchar(100)) + ''')) and '  
   
 if @Survey_ID is not null  
  begin  
   set @SQL = @SQL + ' Survey_ID in (' + cast(@Survey_ID as varchar(100)) + ')'  
  end  
 else  
  begin  
   set @SQL = @SQL + ' Survey_ID in (select Survey_ID from css_view where Study_ID = ' + cast(@Study_ID as varchar(100)) + ')'  
  end  
    
  
  print @SQL  
  exec (@SQL)  
  
 end  
else  
 begin  
  set @SQL = '  
  insert into #SampleSets  
  select distinct Sampleset_ID     
  from Sampleset  
  where Survey_ID in (select Survey_ID from css_view where Study_ID = ' + cast(@Study_ID as varchar(100)) + ')'  
  
  print @SQL  
  exec (@SQL)  
   
 end   
  
  
insert into #Results (client_ID, ClientName, Study_ID, StudyName, Survey_ID, SurveyName, Sampleset_ID, datSamplesetCreateDate, SampledCount, datEncDate_From, datEncDate_To)  
Select C.Client_ID, c.strclient_nm + ' (' + cast(c.Client_ID as varchar(10)) + ')' as ClientName,  
  S.Study_ID, s.strStudy_nm + ' (' + cast(S.Study_ID as varchar(10)) + ')' as StudyName,  
  sd.Survey_ID, sd.strSurvey_nm + ' (' + cast(Sd.Survey_ID as varchar(10)) + ')' + ' (' + cast(sd.Contract as varchar(10)) + ')' as StudyName,  
  ss.Sampleset_ID, ss.datSampleCreate_DT, dbo.fn_GetNumPeopleSampled_PhoneOnly(ss.Sampleset_ID),  
  ss.datDateRange_FromDate, ss.datDateRange_ToDate  
from Client C, Study S, Survey_Def sd, Sampleset ss 
where c.Client_ID = s.Client_ID and  
  s.Study_ID = sd.study_ID and  
  sd.survey_ID = ss.survey_ID and 
  ss.sampleset_ID in (select Sampleset_ID from #samplesets)  
  
  
--update returnedCount  
select r.sampleset_ID, count(*) ReturnedCount  
into #ReturnedCounts  
from #Results r, samplepop sp, questionform qf  
where r.sampleset_ID = sp.sampleset_ID and   
  sp.samplepop_ID = qf.samplepop_ID and    
  qf.datreturned is not null  
group by r.Sampleset_ID  
  
Update r  
set  r.ReturnedCount = rc.ReturnedCount  
from #Results r, #ReturnedCounts rc  
where r.sampleset_ID = rc.sampleset_ID  
  
Update #Results  
set  ReturnedCount = 0  
where ReturnedCount is null  
  
  
--update DatFileSet  
select r.sampleset_ID, min(vfc.DateFileCreated) as datmailed  
into #DatFileSent  
from #Results r, VendorFileCreationQueue vfc
where r.sampleset_ID = vfc.sampleset_ID
group by r.sampleset_ID  
  

Update r  
set  r.datFileSent = d.datmailed  
from #Results r, #DatFileSent d  
where r.sampleset_ID = d.sampleset_ID and  
  datmailed is not null  
  
  
--Update datFirstActionTaken / StartedCount 
select r.sampleset_ID, min(vdl.DispositionDate) as datFirstActionTaken, count(distinct dl_Lithos.strlithocode) as StartedCount      
into #MinDateStartedCounts  
from #Results r, samplepop sp, scheduledmailing scm,       
  sentmailing sm, DL_lithoCodes dl_Lithos, vendordispositionlog vdl  
 where  r.sampleset_ID = sp.sampleset_ID and      
  sp.samplepop_ID = scm.samplepop_ID and      
  scm.sentmail_Id = sm.sentmail_ID and      
  sm.strlithocode = dl_lithos.strlithocode and      
  dl_lithos.DL_LithoCode_ID = vdl.DL_LithoCode_ID and  
  dl_lithos.bitSubmitted = 1     
 group by r.sampleset_ID  
 order by r.sampleset_ID  
  
  
Update	r  
set		r.datFirstActionTaken  = m.datFirstActionTaken,  
		r.StartedCount = m.StartedCount
from	#Results r, #MinDateStartedCounts m
where	r.Sampleset_ID = m.Sampleset_ID   
  
update #Results  
set  StartedCount = 0  
where StartedCount is null  
  
--update datProjComplete  
select	mm.survey_ID, sum(isnull(daysInfield, ExpireInDays)) daysInfield
into #DaysInField
from	mailingmethodology mm, mailingstep ms
where	mm.methodology_Id = ms.methodology_Id and
		mm.bitActiveMethodology = 1
group by mm.Survey_Id

Update	r  
set		r.datProjComplete  = dateadd(d, m.daysInfield, r.datFirstActionTaken)
from	#Results r, #DaysInField m
where	r.Survey_Id = m.Survey_Id   


--Update FinalCount  
select r.sampleset_ID, count(distinct dl_Lithos.strlithocode) as FinalCount      
into #FinalCounts  
from #Results r, samplepop sp, scheduledmailing scm,       
  sentmailing sm, DL_lithoCodes dl_Lithos, vendordispositionlog vdl  
 where  r.sampleset_ID = sp.sampleset_ID and      
  sp.samplepop_ID = scm.samplepop_ID and      
  scm.sentmail_Id = sm.sentmail_ID and      
  sm.strlithocode = dl_lithos.strlithocode and      
  dl_lithos.DL_LithoCode_ID = vdl.DL_LithoCode_ID and  
  dl_lithos.bitSubmitted = 1 and  
  vdl.isFinal = 1    
 group by r.sampleset_ID  
 order by r.sampleset_ID  
  
  
Update r  
set  r.FinalCount = m.FinalCount   
from #Results r, #FinalCounts m  
where r.Sampleset_ID = m.Sampleset_ID   
  
update #Results  
set  FinalCount = 0  
where FinalCount is null  
  
  
select *   
from #Results  
order by Client_ID, Study_ID, Survey_ID, Sampleset_Id  
  
  
IF OBJECT_ID('tempdb..#Results') IS NOT NULL  drop table #Results  
IF OBJECT_ID('tempdb..#SampleSets') IS NOT NULL  drop table #SampleSets  
IF OBJECT_ID('tempdb..#ReturnedCounts') IS NOT NULL  drop table #ReturnedCounts  
IF OBJECT_ID('tempdb..#DatFileSent') IS NOT NULL  drop table #DatFileSent  
IF OBJECT_ID('tempdb..#MinDateStartedCounts') IS NOT NULL  drop table #MinDateStartedCounts  
IF OBJECT_ID('tempdb..#FinalCounts') IS NOT NULL  drop table #FinalCounts


