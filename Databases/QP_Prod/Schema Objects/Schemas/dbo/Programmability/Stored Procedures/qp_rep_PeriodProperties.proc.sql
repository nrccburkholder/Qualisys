/*********************************************************************************************  
 qp_rep_PeriodProperties  
  
 This SP will return property information for any period that has one or more samples  
 between the min and max projected sample dates.  
  
*********************************************************************************************/  
  
  
CREATE  PROCEDURE qp_rep_PeriodProperties  
  @associate varchar(50),  
  @Client varchar(50),  
  @Study varchar(50),  
  @Survey varchar(50),  
  @MinSampleDate datetime,  
  @MaxSampleDate datetime  
as  

Set @MaxSampleDate=dateadd(day,1,@MaxSampleDate)  
declare @survey_id int  
  
select @survey_id=sd.survey_id   
from survey_def sd, study s, client c  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and sd.strsurvey_nm=@survey  
  and c.client_id=s.client_id  
  and s.study_id=sd.study_id  
  
select distinct p.perioddef_id, strperioddef_nm, datExpectedEncStart, datExpectedEncEnd,
	intexpectedsamples, samplingmethod_id, monthweek
into #periods  
from perioddef p, perioddates pd  
where p.survey_id=@survey_id and  
 p.perioddef_id=pd.perioddef_id and  
 datscheduledsample_dt >= @MinSampleDate and  
 datscheduledsample_dt <@MaxSampleDate  
  
IF EXISTS (select top 1 perioddef_id
	from #periods)

	select 'Period Properties' AS SheetNameDummy, 
		--pd.perioddef_id as [Period ID],  
	  p.strperioddef_nm as [Period Name],  
	  intexpectedsamples as [Expected Samples],  
	  strsamplingmethod_nm as [Sampling Method],
	  datExpectedEncStart as [Encounter Range Start], 
	  datExpectedEncEnd as [Encounter Range End],    
	  case  
	   when monthweek='W' then 'Weekly'  
	   when monthweek='D' then 'Daily'  
	   when monthWeek='B' then 'Bi-Monthly'  
	   when monthWeek='M' then 'Monthly'  
	  end as Recurrence, 
	datscheduledsample_dt as [First Scheduled Sample] 
	from #periods p, perioddates pds, samplingmethod sm  
	where p.perioddef_id=pds.perioddef_id and  
	  pds.samplenumber=1 and  
	  p.samplingmethod_id=sm.samplingmethod_id  
	order by p.perioddef_id  

ELSE 
	select 'Period Properties' AS SheetNameDummy, /*''  as [Period ID],*/ '' as [Period Name],  '' as [Expected Samples],  '' as [Sampling Method],
	'' as [Encounter Range Start], '' as [Encounter Range End],  
	'' as Recurrence,  '' as [First Scheduled Sample]  
DROP TABLE #periods


