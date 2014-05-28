CREATE procedure [dbo].[sp_dbm_CheckSamplesetExtraction]     
as     
/*************************************************************  
This procedure is to check if a sampleset flagged extracted,   
all samplepop background info should be extracted. Otherwise   
send an alert message to DBA team.  
**************************************************************/  
-- 12/10/2007 DK Created  
--MB 3/17/08
--	Added delete here to remove study_IDs that don't actually exist in the data mart.
--	This does not happen alot but even 1 study will kill the job everytime it runs.

DECLARE @d datetime, @Msg varchar(2000), @DBAs varchar(255), @Sub varchar(255), @Study_id int  
DECLARE @Datamart varchar(50), @Sql varchar(8000)  
DECLARE @SSID TABLE (SampleSet_ID int)    
DECLARE @S TABLE (Study_id int)  
CREATE TABLE #Out (Study_id int, SampleSet_id int, NotExtracted int)  
  
SELECT @DataMart = strParam_Value FROM QualPro_Params WHERE strParam_nm = 'DataMart'  
SET @d = DateAdd(day, -14, getdate())    
INSERT @SSID SELECT SampleSet_id FROM SampleSet WHERE datSampleCreate_dt>=@d    
  
SELECT @DBAs = 'dba@nationalresearch.com'  
  
select Study_id, sampleset_id, count(distinct pop_id) as PopCount    
INTO #SPC   
from selectedsample (nolock)     
where SampleSet_id in (Select SampleSet_id from @SSID) and intExtracted_flg is not null    
group by Study_id, sampleset_id  
having Sum(intExtracted_flg)>0 -- to indicate that the sampleset has been extracted    
  
INSERT @S  
SELECT Distinct Study_id  
FROM #SPC  
order by Study_id  

--MB 3/17/08
--Added delete here to remove study_IDs that don't actually exist in the data mart.
delete from @S
where 's' + cast(Study_ID as varchar(100)) not in
(select su.name from datamart.Qp_Comments.dbo.sysobjects so, datamart.Qp_Comments.dbo.sysusers su 
where so.uid = su.uid and so.name = 'Big_Table_View' and so.type = 'v')

  
SELECT top 1 @Study_id = Study_id FROM @S  
  
WHILE @@Rowcount>0  
BEGIN  
   
 SET @Sql = 'INSERT #Out ' +   
    ' SELECT ' +LTRIM(RTRIM(str(@Study_id)))+', s.SampleSet_id, MAX(s.PopCount)-Count(distinct b.SamplePop_id) ' +  
    ' FROM #SPC s inner join '+@DataMart+'.Qp_Comments.S'+LTRIM(RTRIM(str(@Study_id)))+'.Big_Table_View b ' +  
    ' ON s.SampleSet_id=b.SampleSet_id '+  
    ' GROUP BY s.SampleSet_id'  
 EXEC (@Sql)  
  
 DELETE FROM @S WHERE Study_id = @Study_id  
 SELECT top 1 @Study_id = Study_id FROM @S  
END  
  
SELECT Study_id from #Out where NotExtracted>0  
    
if @@Rowcount>0    
 BEGIN    
  SET @Msg =  '**************************************************************' +CHAR(10) + CHAR(13) +    
  'The following SampleSets not extracted properly.' +CHAR(10) + CHAR(13)     
  Select @Msg = @Msg +     
    '  Study_id: '+LTRIM(str(Study_id)) +    
    '  SampleSet_id: ' + LTRIM(str(SampleSet_id)) +    
    '  Not Extracted: ' + LTRIM(str(NotExtracted)) + CHAR(10) + CHAR(13)     
  from #Out      
  where NotExtracted>0    
 END    
else    
 BEGIN    
  SET @Msg = 'Sampleset created in the past 14 days have been checked. None of them found with extraction problem.'    
 END    
  
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
exec qp_prod.dbo.sp_getemailsubject 'Check sample set extraction for server:',@country, @environment, 'Qualisys', @osubject=@Sub output

if (SELECT count(*) from #Out where NotExtracted>0) > 0
begin
	--EXEC Master..xp_sendmail @recipients = @DBAs, @message = @Msg, @subject = @Sub  
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='QualisysEmail',
	@recipients=@DBAs,
	@subject=@Sub,
	@body=@Msg,
	@body_format='Text',
	@importance='High'   
end   
drop table #SPC  
drop table #Out


