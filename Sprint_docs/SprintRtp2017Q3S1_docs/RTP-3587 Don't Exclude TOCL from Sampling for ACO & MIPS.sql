/*
	RTP-3587 Don't Exclude TOCL from Sampling for ACO & MIPS.sql

	Lanny Boswell

	ALTER TABLE [dbo].[SurveyType]
	ALTER PROCEDURE [dbo].[QCL_SampleSetTOCLRule] 

*/

USE [QP_Prod]
GO

IF NOT EXISTS(SELECT * FROM sys.columns	
	WHERE object_id = OBJECT_ID(N'[dbo].[SurveyType]') AND ([Name] = 'BypassToclExclusion'))
BEGIN
	ALTER TABLE [dbo].[SurveyType] 
		ADD [BypassToclExclusion] BIT NOT NULL 
		CONSTRAINT DF_SurveyType_BypassToclExclusion DEFAULT(0)
END
GO

UPDATE [dbo].[SurveyType] SET [BypassToclExclusion] = 1 WHERE SurveyType_ID IN (10, 13)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*        
Business Purpose:         
This procedure is used to support the Qualisys Class Library.  It determines        
which records should be DQ'd because of Take off call list.        
        
Created:  02/28/2006 by DC        
        
Modified:        
  12/10/2009 by MWB       
  Added inserts into SamplingExclusion_Log to log all occurances of exclusions for all Static Plus Samples      
  
  7/12/2010 by MWB  
  Added dbl check for enc_ID for studies that are pop only    
  Dynamic sql b/c for some reason even though it is a temp table if there is no enc_Id it will throw an  
  error if enc_ID is not defined.  This is only a problem with the old sampling and has to do with how  
  the table is created.        
*/          
ALTER PROCEDURE [dbo].[QCL_SampleSetTOCLRule]        
 @Study_ID int,      
 @survey_ID int = 0,      
 @Sampleset_ID int = 0,      
 @LogExclusion int = 0      
         
AS        
        
 DECLARE @TOCLRemoveRule tinyint, @EncTable int, @indebug int, @sql varchar(8000)        
 SET @TOCLRemoveRule = 3      
         
 set @indebug = 0  
   
 if @indebug = 1  
 begin  
 print 'Begin QCL_SampleSetTOCLRule'  
 print '@Study_ID = ' + cast(@Study_ID as varchar(10))  
 print '@survey_ID = ' + cast(@survey_ID as varchar(10))  
 print '@Sampleset_ID = ' + cast(@Sampleset_ID as varchar(10))  
 print '@LogExclusion = ' + cast(@LogExclusion as varchar(10))  
 end  
         
 UPDATE #Sampleunit_Universe        
  SET Removed_Rule = @TOCLRemoveRule        
  FROM #Sampleunit_Universe U, dbo.TOCL T        
  WHERE U.Pop_id = T.Pop_id        
   AND T.Study_id = @Study_id        
        
if @LogExclusion = 1      
BEGIN      
  
  
 IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@Study_ID AND strTable_nm='Encounter')>0        
 SELECT @EncTable=1        
 ELSE         
 SELECT @EncTable=0        
  
 if @indebug = 1 print '@EncTable = ' + cast(@EncTable as varchar(10))  
     
  if @EncTable = 1    
  begin  
    SET @SQL = 'insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)      
    Select ' + cast(@survey_ID as varchar(10)) + ' as Survey_ID, ' + cast(@Sampleset_ID as varchar(10)) + ' as Sampleset_ID, U.Sampleunit_ID, U.Pop_ID, U.Enc_ID, 3 as SamplingExclusionType_ID, Null as DQ_BusRule_ID      
    FROM #Sampleunit_Universe U, dbo.TOCL T        
    WHERE U.Pop_id = T.Pop_id        
    AND T.Study_id = ' + CAST(@Study_id AS VARCHAR(10))  
      
    if @indebug = 1 print @SQL  
    EXEC (@sql)  
 end    
 else    
 begin  
    SET @SQL = 'insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)      
    Select ' + cast(@survey_ID as varchar(10)) + ' as Survey_ID, ' + cast(@Sampleset_ID as varchar(10)) + ' as Sampleset_ID, U.Sampleunit_ID, U.Pop_ID, NULL as Enc_ID, 3 as SamplingExclusionType_ID, Null as DQ_BusRule_ID      
    FROM #Sampleunit_Universe U, dbo.TOCL T        
    WHERE U.Pop_id = T.Pop_id        
    AND T.Study_id = ' + CAST(@Study_id AS VARCHAR(10))        
  
    if @indebug = 1 print @SQL  
    EXEC (@sql)  
 end    
END    
     
    
if @indebug = 1 print 'End QCL_SampleSetTOCLRule'
GO