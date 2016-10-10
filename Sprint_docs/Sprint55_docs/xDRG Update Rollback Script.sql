

use qp_prod



 IF OBJECT_ID('tempdb..#SPs') IS NOT NULL DROP TABLE #SPs
    
  IF OBJECT_ID('tempdb..#fields') IS NOT NULL DROP TABLE #fields
 IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work 
 IF OBJECT_ID('tempdb..#Log') IS NOT NULL DROP TABLE #Log  

 --CREATE TABLE [dbo].[HCAHPSUpdateLog]([samplepop_id] [int],[field_name] [varchar](42),[old_value] [varchar](42),[new_value] [varchar](42),[Change_Date] [datetime], [DataFile_ID] [int], [isRollback] [bit])

 CREATE TABLE #log (RecordType varchar(150), RecordsValue Varchar(50)) 
 ----CREATE TABLE #Work (DRG varchar(3),HServiceType varchar(42), HVisitType varchar(42), HAdmissionSource varchar(42), HDischargeStatus varchar(42), HAdmitAge int, HCatAge varchar(42), Enc_id int, Pop_id int) 

 -- --SELECT distinct h.samplepop_id, ss.STUDY_ID, ss.POP_ID, ss.enc_id,h.field_name, h.old_value, h.new_value, h.DataFile_ID  
 -- --INTO #Work
 -- --FROM [dbo].[HCAHPSUpdateLog] h
 -- --INNER JOIN SamplePop sp on h.samplepop_id = sp.SAMPLEPOP_ID
 -- --INNER JOIN SELECTEDSAMPLE ss on ss.Sampleset_id = sp.Sampleset_id and ss.Pop_id = sp.Pop_id 
 -- --INNER JOIN SampleUnit su on su.SampleUnit_id = ss.SampleUnit_id  
 -- --where old_value <> new_value
 -- --and Change_Date > '2016-08-08' -- change to Datafile_id

  DECLARE @DataFile_ID int = 3893
   DECLARE @Study_ID int = 4883
  DECLARE @DRGOption varchar(10) = 'MSDRG'

  --SELECt *
  --FROM [dbo].[HCAHPSUpdateLog] h
  --where Change_Date > '2016-08-08' 


  SELECT h.samplepop_id 
  INTO #Sps
  FROM [HCAHPSUpdateLog] h
  where DataFile_ID = @Datafile_ID  

SELECT distinct h.field_name
INTO #fields
FROM [HCAHPSUpdateLog] h
where DataFile_ID = @Datafile_ID  
and ISNULL(old_value,'NULL') <> ISNULL(new_value,'NULL')


  select * from #fields

SELECT distinct h.samplepop_id, ss.STUDY_ID, ss.POP_ID, ss.enc_id,h.field_name, h.old_value, h.new_value, h.DataFile_ID, dm.Disposition_id, h.Change_Date 
	INTO #Work
	FROM dbo.HCAHPSUpdateLog h
	LEFT JOIN dbo.HCAHPSUpdateLog h1 on h1.samplepop_id = h.samplepop_id and h1.field_name = h.field_name and h1.DataFile_id = h.DataFile_id and h1.bitRollback = 1
	INNER JOIN SamplePop sp on h.samplepop_id = sp.SAMPLEPOP_ID
	INNER JOIN SELECTEDSAMPLE ss on ss.Sampleset_id = sp.Sampleset_id and ss.Pop_id = sp.Pop_id 
	INNER JOIN SampleUnit su on su.SampleUnit_id = ss.SampleUnit_id  
	LEFT Join dbo.DRGUpdateDispositionMapping dm on dm.FieldName = h.field_name and dm.UpdateValue = h.new_value
	where h.DataFile_ID = @Datafile_ID  
	and ISNULL(h.old_value,'NULL') <> ISNULL(h.new_value,'NULL')
	and h1.DataFile_ID is null -- if it has NOT already been rolledback



  select *
  from #Work


 DECLARE @sql varchar(8000)




 DECLARE @Owner varchar(10)

 SELECT top 1 @Study_ID = Study_id FROM #Work

 SET @Owner = 'S'+RTRIM(LTRIM(STR(@Study_ID)))  

 DECLARE @myRowCount int

 PRINT 'Updating Encounter table'  
 
 DECLARE @fieldName varchar(20)
 
 SELECT TOP 1 @fieldName = field_name FROM #fields
 WHILE @@ROWCOUNT > 0
    BEGIN

	 IF EXISTS (select 1
	from QP_PROD.information_schema.columns c
	where table_schema = @Owner and table_name = 'encounter' and column_name = @fieldName)
	BEGIN
	                                     
		--SET @Sql = 'UPDATE e SET e.' + @fieldName + ' = w.old_value ' + 
		--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
		--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
		--   'where w.field_name = ''' + @fieldName + '''' 


		SET @Sql = 'SELECT w.samplepop_id, e.pop_id, e.enc_id, e.' + @fieldName + ', w.old_value ' + 
		   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
		   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.enc_ID ' +
		   'where w.field_name = ''' + @fieldName + '''' 

		print @sql

		EXEC (@Sql)    

		set @myRowCount = @@ROWCOUNT   
  
		if @myRowCount > 0
		begin
         
		   INSERT INTO #Log (RecordType, RecordsValue)                      
		   Select @DRGOption + ': Encounter ' + @fieldName + ' Records Updated (rollback): ',LTRIM(STR(@myRowCount))  
		   --Log data changes                      
		   --INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, datafile_id, bitRollback)                       
		   SELECT DISTINCT w.SamplePop_id, @fieldName, w.new_value, w.old_value, w.datafile_id, 1                      
		   FROM #Work w
		   where w.field_name = @fieldName                      

			set @myRowCount = @@ROWCOUNT 
			insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog ' + @fieldName + ' Records Updated (rollback): ' + + LTRIM(STR(@myRowCount))     
		end  

	END  

	DELETE FROM #fields WHERE  field_name = @fieldName
     SELECT TOP 1 @fieldName = field_name FROM #fields
  END



  
  --DELETE dl
  SELECT dl.*
  FROM dbo.DispositionLog dl
  INNER JOIN #Work w on w.samplepop_id = dl.SamplePop_id and w.disposition_id = dl.Disposition_id and w.Change_Date = dl.datLogged 
  WHERE w.Disposition_id is not null
  and dl.LoggedBy = 'DBA'


 
  select *
  from #log

  select *
  from DRGDebugLogging
  where DataFile_ID = @DataFile_ID
 
-- IF EXISTS (select 1
--	from QP_PROD.information_schema.columns c
--	where table_schema = @Owner and table_name = 'encounter' and
--			column_name = 'DRG')
--BEGIN
	                                     
--	SET @Sql = 'UPDATE e SET e.DRG  = w.old_value ' + 
--	   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--	   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--	   'where w.field_name = ''DRG''' 
--	EXEC (@Sql)    

--	set @myRowCount = @@ROWCOUNT   
  
--	if @myRowCount > 0
--	begin
         
--	   INSERT INTO #Log (RecordType, RecordsValue)                      
--	   Select 'DRG: Encounter Records Updated (rollback): ',LTRIM(STR(@myRowCount))  
--	--Log DRG data changes                      
--	   INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, datafile_id, isRollback)                       
--	   SELECT DISTINCT w.SamplePop_id, 'DRG', w.new_value, w.old_value, w.datafile_id, 1                      
--	   FROM #Work w
--	   where w.field_name = 'DRG'                       

--		set @myRowCount = @@ROWCOUNT 
--		insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog DRG Records Updated (rollback): ' + + LTRIM(STR(@myRowCount))     
--	end  


--END  
 
              
----Update Encounter table -- DRG                                        
--SET @Sql = 'UPDATE e SET e.DRG  = w.old_value ' + 
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''DRG''' 
--EXEC (@Sql)    

--set @myRowCount = @@ROWCOUNT   
  
--if @myRowCount > 0
--begin
         
--   INSERT INTO #Log (RecordType, RecordsValue)                      
--   Select 'DRG: Encounter Records Updated (rollback): ',LTRIM(STR(@myRowCount))  
----Log DRG data changes                      
--   INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, datafile_id, isRollback)                       
--   SELECT DISTINCT w.SamplePop_id, 'DRG', w.new_value, w.old_value, w.datafile_id, 1                      
--   FROM #Work w
--   where w.field_name = 'DRG'                       

--	set @myRowCount = @@ROWCOUNT 
--	insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog DRG Records Updated (rollback): ' + + LTRIM(STR(@myRowCount))     
--end  

 

--SET @Sql = 'UPDATE e SET e.MSDRG  = w.old_value ' + 
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''MSDRG''' 
--EXEC (@Sql)   

--set @myRowCount = @@ROWCOUNT   
  
--if @myRowCount > 0
--begin
         
--   INSERT INTO #Log (RecordType, RecordsValue)                      
--   Select 'MSDRG: Encounter Records Updated (rollback): ',LTRIM(STR(@myRowCount))  
----Log DRG data changes                      
--   INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, datafile_id, isRollback)                       
--   SELECT DISTINCT w.SamplePop_id, 'MSDRG', w.new_value, w.old_value, w.datafile_id, 1                      
--   FROM #Work w
--   where w.field_name = 'MSDRG'                       

--	set @myRowCount = @@ROWCOUNT 
--	insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog MSDRG Records Updated (rollback): ' + + LTRIM(STR(@myRowCount))     
--end   

--SET @Sql = 'UPDATE e SET e.APRDRG  = w.old_value ' + 
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''APRDRG''' 
--EXEC (@Sql)  

--set @myRowCount = @@ROWCOUNT   
  
--if @myRowCount > 0
--begin
         
--   INSERT INTO #Log (RecordType, RecordsValue)                      
--   Select 'APRDRG: Encounter Records Updated (rollback): ',LTRIM(STR(@myRowCount))  
----Log DRG data changes                      
--   INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, datafile_id, isRollback)                       
--   SELECT DISTINCT w.SamplePop_id, 'APRDRG', w.new_value, w.old_value, w.datafile_id, 1                      
--   FROM #Work w
--   where w.field_name = 'APRDRG'                       

--	set @myRowCount = @@ROWCOUNT 
--	insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog APRDRG Records Updated (rollback): ' + + LTRIM(STR(@myRowCount))     
--end  

--SET @Sql = 'UPDATE e SET e.HServiceType = w.HServiceType' + --, HVisitType = w.HVisitType, HAdmissionSource = w.HAdmissionSource, HDischargeStatus = w.HDischargeStatus, HAdmitAge = w.HAdmitAge, HCatAge = w.HCatAge ' +                      
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''HServiceType''' 
--EXEC (@Sql)    

--SET @Sql = 'UPDATE e SET e.HVisitType = w.HVisitType' + --, HAdmissionSource = w.HAdmissionSource, HDischargeStatus = w.HDischargeStatus, HAdmitAge = w.HAdmitAge, HCatAge = w.HCatAge ' +                      
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''HVisitType''' 
--EXEC (@Sql)    

--SET @Sql = 'UPDATE e SET e.HAdmissionSource = w.HAdmissionSource' + --, HDischargeStatus = w.HDischargeStatus, HAdmitAge = w.HAdmitAge, HCatAge = w.HCatAge ' +                      
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''HAdmissionSource''' 
--EXEC (@Sql)    

--SET @Sql = 'UPDATE e SET e.HDischargeStatus = w.HDischargeStatus' + --, HAdmitAge = w.HAdmitAge, HCatAge = w.HCatAge ' +                      
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''HDischargeStatus''' 
--EXEC (@Sql)    

--SET @Sql = 'UPDATE e SET e.HAdmitAge = w.HAdmitAge' + --, HCatAge = w.HCatAge ' +                      
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''HAdmitAge''' 
--EXEC (@Sql)    


--SET @Sql = 'UPDATE e SET e.HCatAge = w.HCatAge ' +                      
--   ' FROM S' +RTRIM(LTRIM(STR(@Study_ID)))  + '.ENCOUNTER e ' +
--   'inner join #work w on e.pop_id = w.POP_ID and e.enc_id = w.POP_ID ' +
--   'where w.field_name = ''HCatAge''' 
--EXEC (@Sql)    



