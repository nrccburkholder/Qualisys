/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It determines    
which records should be DQ'd because of newborn criteria.    
    
Created:  02/28/2006 by DC    
    
Modified:    
 04/11/2006 by DC - Added code to convert " to '    
 12/09/2009 by MWB - Added insert into Sampling_ExclusionLog.      
 03/15/2013 by CA - @vcSET needs to be excluded from the second query (Canadian Qualisys upgrade)
    
*/      
CREATE PROCEDURE [dbo].[QCL_SampleSetNewbornRule]    
 @Study_id int,    
 @vcBigView_Join varchar(8000),    
 @vcNewborn_Where varchar(8000),  
 @Survey_ID int=0,  
 @SampleSet_ID int =0  
AS    
 DECLARE @vcUPDATE varchar(8000)    
 DECLARE @vcSET varchar(8000)    
 DECLARE @vcFROM varchar(8000)    
 DECLARE @vcWHERE varchar(8000)    
    
SET @vcNewborn_Where=REPLACE(@vcNewborn_Where,'"','''')    
    
 /*Newborn rule Const*/    
 DECLARE @NewbornRemoveFlag tinyint    
 SET @NewbornRemoveFlag = 2    
 /*Format the 'INSERT', 'SELECT', 'FROM', and 'WHERE' elements of the SQL Statement*/    
 SET @vcUPDATE = 'UPDATE #Sampleunit_Universe'    
 SET @vcSET = ' SET Removed_Rule = ' + CONVERT(varchar, @NewbornRemoveFlag)    
 SET @vcFROM = ' FROM #Sampleunit_Universe X, S' + CONVERT(varchar, @Study_id) + '.Big_View BV'    
 SET @vcWHERE = ' WHERE Removed_Rule=0 and ' + @vcBigView_Join +  ' AND ' + @vcNewborn_Where    
print @vcUPDATE + @vcSET + @vcFROM + @vcWHERE  
EXECUTE (@vcUPDATE + @vcSET + @vcFROM + @vcWHERE)    
    
  

declare @EncTable int  
IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@Study_ID AND strTable_nm='Encounter')>0      
SELECT @EncTable=1      
ELSE       
SELECT @EncTable=0      

if @EncTable = 1
begin  
	SET @vcUPDATE = 'insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)  
	Select ' + cast(@survey_ID as varchar(10)) + ' as Survey_ID, ' + cast(@Sampleset_ID as varchar(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 2 as SamplingExclusionType_ID, Null as DQ_BusRule_ID'  
	SET @vcFROM = ' FROM #Sampleunit_Universe X, S' + CONVERT(varchar, @Study_id) + '.Big_View BV'    
	SET @vcWHERE = ' WHERE ' + @vcBigView_Join + ' AND ' + @vcNewborn_Where   
	print @vcUPDATE + @vcFROM + @vcWHERE  
	EXECUTE (@vcUPDATE + @vcFROM + @vcWHERE)    

end
else
begin
	SET @vcUPDATE = 'insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)  
	Select ' + cast(@survey_ID as varchar(10)) + ' as Survey_ID, ' + cast(@Sampleset_ID as varchar(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, null Enc_ID, 2 as SamplingExclusionType_ID, Null as DQ_BusRule_ID'  
	SET @vcFROM = ' FROM #Sampleunit_Universe X, S' + CONVERT(varchar, @Study_id) + '.Big_View BV'    
	SET @vcWHERE = ' WHERE ' + @vcBigView_Join + ' AND ' + @vcNewborn_Where   
	print @vcUPDATE + @vcFROM + @vcWHERE  
	EXECUTE (@vcUPDATE + @vcFROM + @vcWHERE)    

end


