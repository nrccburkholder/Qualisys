/*  
Business Purpose:   
This procedure is used to support the Qualisys Class Library.  It determines  
which records should be DQ'd because there encounter have previously been sampled.  
  
This bug was created by a short term fix and has allowed the same encounter to be sampled twice.  
  
Created:	09/02/08 by MWB  
  
Modified:  
			12/10/2009 by MWB
			Added insert into Sampling_ExclusionLog
*/    
CREATE PROCEDURE [dbo].[QCL_RemovePreviousSampledEncounters]  
 @Study_id int,
 @survey_ID int = 0,
 @Sampleset_ID int = 0  
AS  
  
 DECLARE @RemoveRule tinyint  
 SET @RemoveRule = 9  
 
 UPDATE #Sampleunit_Universe  
  SET Removed_Rule = @RemoveRule  
  FROM #Sampleunit_Universe U, dbo.SelectedSample T  
  WHERE U.enc_ID = T.enc_ID  
   AND T.Study_id = @Study_id
   and U.Removed_Rule = 0  
  

declare @EncTable int  
IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@Study_ID AND strTable_nm='Encounter')>0      
SELECT @EncTable=1      
ELSE       
SELECT @EncTable=0      

if @EncTable = 1
begin
	insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
	Select distinct @survey_ID as Survey_ID, @Sampleset_ID as Sampleset_ID, U.Sampleunit_ID, U.Pop_ID, U.Enc_ID, @RemoveRule as SamplingExclusionType_ID, Null as DQ_BusRule_ID
	FROM #SampleUnit_Universe U, dbo.SelectedSample T  
	WHERE U.enc_ID = T.enc_ID  
	AND T.Study_id = @Study_id  
end
else
begin
	insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
	Select distinct @survey_ID as Survey_ID, @Sampleset_ID as Sampleset_ID, U.Sampleunit_ID, U.Pop_ID, null Enc_ID, @RemoveRule as SamplingExclusionType_ID, Null as DQ_BusRule_ID
	FROM #SampleUnit_Universe U, dbo.SelectedSample T  
	WHERE U.enc_ID = T.enc_ID  
	AND T.Study_id = @Study_id  
end


