CREATE procedure [dbo].[sp_dbm_CheckCommentExtractFlag]       
as       
-- 06/12/2007 DK Created    
DECLARE @d datetime, @Msg varchar(2000), @DBAs varchar(255), @Sub varchar(255)    
DECLARE @SSID TABLE(SampleSet_ID int)      
SET @d = DateAdd(day, -14, getdate())      
INSERT @SSID SELECT SampleSet_id FROM SampleSet WHERE datSampleCreate_dt>=@d      
    
--SELECT @DBAs = dbo.GetDBAEmailGroup()    
-- Change made by S.Walls 8/7/08 12:24pm    
SELECT @DBAs = 'itsoftwareengineeringlincoln@nationalresearch.com'    
      
select sampleset_id, count(distinct pop_id) as PopCount       
into #ssdcnt       
from selectedsample (nolock)       
where SampleSet_id in (Select SampleSet_id from @SSID) and intExtracted_flg is not null      
group by sampleset_id      
      
select SampleSet_id, Sum(intExtracted_flg) as Flag1Count      
into #w      
from SelectedSample ss (nolock)      
where SampleSet_id in (Select SampleSet_id from @SSID) and intExtracted_flg is not null      
group by SampleSet_id      
      
select ss.datsamplecreate_dt, w.SampleSet_id, w.Flag1Count, d.PopCount        
from #w w, #ssdcnt d, sampleset ss        
where ss.sampleset_id = w.sampleset_Id and w.sampleset_id = d.sampleset_id and w.Flag1Count <> d.PopCount       
order by 1 desc      
      
if @@Rowcount>0      
BEGIN      
 SET @Msg =  '**************************************************************' +CHAR(10) + CHAR(13) +      
 'The following SampleSets not flagged properly in intExtract_flag field.' +CHAR(10) + CHAR(13)       
 Select @Msg = @Msg + Convert(varchar(30), ss.datsamplecreate_dt,120) +      
   '  SampleSet: '+LTRIM(str(w.SampleSet_id)) +      
   '  Flag1 Count: ' + LTRIM(str(w.Flag1Count)) +      
   '  Pop Count: ' + LTRIM(str(d.PopCount)) + CHAR(10) + CHAR(13)       
 from #w w, #ssdcnt d, sampleset ss        
 where ss.sampleset_id = w.sampleset_Id and w.sampleset_id = d.sampleset_id and w.Flag1Count <> d.PopCount       
 order by 1 desc      
END      
else      
BEGIN      
 SET @Msg = 'Sampleset created in the past 14 days have been checked. None of them found with intExtracted_Flg problem.'      
END      
    
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
exec qp_prod.dbo.sp_getemailsubject 'Check intExtracted_Flg report for server:',@country, @environment, 'Qualisys', @osubject=@Sub output

EXEC msdb..sp_send_dbmail @recipients = @DBAs, @body = @Msg, @subject = @Sub    
      
drop table #W      
drop table #ssdcnt


