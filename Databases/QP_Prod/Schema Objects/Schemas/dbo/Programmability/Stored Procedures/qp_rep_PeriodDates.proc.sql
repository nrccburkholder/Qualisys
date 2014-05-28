/*********************************************************************************************  
 qp_rep_PeriodDates  
  
 This SP will return the schedule date information for any period that has one or more samples  
 between the min and max projected sample dates.  
  
*********************************************************************************************/  
  
CREATE PROCEDURE qp_rep_PeriodDates  
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
  
select distinct p.perioddef_id, strperioddef_nm  
into #periods  
from perioddef p, perioddates pd  
where p.survey_id=@survey_id and  
 p.perioddef_id=pd.perioddef_id and  
 datscheduledsample_dt >= @MinSampleDate and  
 datscheduledsample_dt <@MaxSampleDate  
  
  
select p.perioddef_id,   
  p.strperioddef_nm,  
  samplenumber,  
  datscheduledsample_dt,  
  datsamplecreate_dt    
into #dates  
from perioddates pd, #periods p  
where pd.perioddef_id=p.perioddef_id  
order by pd.perioddef_id, samplenumber  
  
select strperioddef_nm   
into #names  
from #dates  
  
declare @name varchar(42), @sql varchar(5000), @maxSamples int, @i int  
  
set @sql=''  
  
create table #perioddates ([Sample Number] int)  
  
set @maxsamples=0  
set @i=1  
select @maxSamples=max(samplenumber)  
from #dates  
  
While @i<=@maxsamples  
Begin  
 insert into #perioddates ([Sample Number]) values (@i)  
 set @i=@i+1  
End  
  
select top 1 @name=strperioddef_nm  
from #names  
  
while @@rowcount > 0  
Begin  
  
 set @sql='alter table #perioddates add [(Projected) ' +@name + '] varchar(20)'  
 exec (@sql)  
 set @sql='update pd set [(Projected) ' +@name + ']=convert(varchar,month(datscheduledsample_dt))+''/'' + convert(varchar,day(datscheduledsample_dt)) + ''/'' + convert(varchar,year(datscheduledsample_dt))' +  
    ' from #perioddates pd, #dates d' +  
    ' where d.strperioddef_nm=''' + @name + ''' and' +  
    '  pd.[Sample Number]=d.samplenumber'  
 exec (@sql)  
  
 set @sql='alter table #perioddates add [(Actual) ' +@name + '] varchar(20)'  
 exec (@sql)  
 set @sql='update pd set [(Actual) ' +@name + ']=convert(varchar,month(datsamplecreate_dt))+''/'' + convert(varchar,day(datsamplecreate_dt)) + ''/'' + convert(varchar,year(datsamplecreate_dt))' +  
    ' from #perioddates pd, #dates d' +  
    ' where d.strperioddef_nm=''' + @name + ''' and' +  
    '  pd.[Sample Number]=d.samplenumber'  
 exec (@sql)  
  
 delete from #names where strperioddef_nm=@name  
  
 select top 1 @name=strperioddef_nm  
 from #names  
  
End  

IF EXISTS (SELECT 'Period Properties' AS SheetNameDummy, *  FROM #perioddates)
	SELECT 'Period Properties' AS SheetNameDummy, *  FROM #perioddates
ELSE
	SELECT 'Period Properties' AS SheetNameDummy, '' AS [Sample Number]


