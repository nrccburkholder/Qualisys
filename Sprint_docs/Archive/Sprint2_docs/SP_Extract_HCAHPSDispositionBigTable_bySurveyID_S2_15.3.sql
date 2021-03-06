USE [QP_Comments]
GO
/****** Object:  StoredProcedure [dbo].[SP_Extract_HCAHPSDispositionBigTable_bySurveyID]    Script Date: 6/16/2014 11:27:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Extract_HCAHPSDispositionBigTable_bySurveyID] @survey_id int, @indebug bit = 0                     
AS                          

 -- 8/9/2006 - SJS -                          
 -- Created to update the HDisposition disposition column in the BigTable each night during the extract.                          
 -- 10/19/09 - MWB -                  
 -- Split proc to only work with HCAHPS Surveys.  we have a new proc to deal with HHCAHPS surveyTypes.                  
 -- 12/02/11 - DRM -                  
 -- Added HNumAttempts.
 
 -- Modified 06/16/2014 TSB - update *CAHPSDisposition table references to use SurveyTypeDispositions table          

--declare @indebug bit    

set arithabort on      

 DECLARE @study VARCHAR(20), @SQL VARCHAR(1000), @rec INT, @BT VARCHAR(50), @study_id INT                          
 -- DRM 12/02/11 HNumAttempts           
 DECLARE @samplepop_id int, @datlogged datetime, @sentmail_id int          
 -- DRM 3/1/2011 HNumAttempts fix    
 DECLARE @tmp_count int    
                    

  -- Get distinct list of studies we will be working with                          
  CREATE TABLE #AllSP (study_id INT, samplepop_id INT)                    
  CREATE INDEX ix_AllSP ON #AllSP (samplepop_id)                          

  CREATE TABLE #DispoNew (study_id INT, samplepop_id INT)                      
  CREATE INDEX ix_DispoNew ON #disponew (samplepop_id)                          

  -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id.          
  CREATE TABLE #DispoWork (study_id INT, survey_id int, samplepop_id INT, Disposition_id INT, DatLogged DATETIME, DaysFromCurrent INT, DaysFromFirst INT, bitEvaluated BIT, ReceiptType_id int)          
  CREATE INDEX ix_DispoWork ON #DispoWork (samplepop_id, disposition_id, datLogged)                          

  CREATE TABLE #UpdateBT (rec INT IDENTITY(1,1), study_id INT, survey_id INT, samplepop_id INT, BT VARCHAR(100), bitEvaluated BIT DEFAULT 0)                          

  CREATE TABLE #ULoop (BT VARCHAR(100))                      

  CREATE TABLE #tblStudy (study_id INT, study VARCHAR(10))                          

  CREATE TABLE #Del (study_id INT, samplepop_id INT)                      

  -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id, sentmail_id, datlogged.          
  CREATE TABLE #Dispo (Study_id INT, survey_id int, SamplePop_id INT, Disposition_id INT, HCAHPSHierarchy INT, HCAHPSValue CHAR(2), ReceiptType_id int, Sentmail_id int, DatLogged datetime)          

  -- DRM 12/02/11 HNumAttempts - Added HNumAttempts, ReceiptType_id, survey_id, sentmail_id, datlogged, disposition_id.          
  CREATE TABLE #SampDispo (Study_id INT, survey_id int, SamplePop_id INT, HCAHPSValue CHAR(2), bitEvaluated BIT DEFAULT 0, LagTime int DEFAULT 0, HNumAttempts int, ReceiptType_id int, Sentmail_id int, DatLogged datetime, Disposition_id INT)          

  -- DRM 12/02/11 HNumAttempts - Added temp tables for iterating through affected samplepop_ids.          
  create table #tmp_samplepops (samplepop_id int, datlogged datetime)          

  create table #tmp_samplepops2 (samplepop_id int, sentmail_id int)          

 SET NOCOUNT ON                          

 -- GATHER WORK                
INSERT INTO #AllSP (study_id, samplepop_id)     
SELECT dl.study_id, dl.samplepop_id              
FROM DispositionLog dl, clientstudysurvey css               
WHERE dl.survey_ID = css.survey_ID and              
  css.surveyType_Id = 2 and              
  dl.bitEvaluated = 0                    
and css.survey_id = @survey_id

IF @@ROWCOUNT > 0                     
BEGIN                    
  --commented out 4/6/2010 MWB b/c we now have several SPs that work with Dispo log and they each only handle              
  --the correct surveyTypes worth of data via the #ALLSP temp table.  No need to remove invalid entries.              

  ---- First update DispositionLog for any dispositions that are NOT HCAHPS/HHCAHPS and have a bitEvaluated = 0 (SET=1)    
  --UPDATE dl SET bitEvaluated = 1, DateEvaluated = getdate()                    
  --FROM DispositionLog dl, Dispositions_view d, #AllSP sp, clientstudysurvey css                   
  --WHERE dl.disposition_id = d.disposition_id AND                   
  --dl.samplepop_id = sp.samplepop_id AND                   
  --css.survey_Id = dl.survey_ID AND         
  --d.HCAHPSValue IS NULL AND                  
  --css.surveyType_ID not in (2, 3) AND                    
  --dl.bitEvaluated = 0                  

  -- Update the bitEvaluated flag and set it to 1 for all dispositionlog table having DaysFromFirst > 42 (Don't Fit the HCAHPS Specs)                      
  UPDATE dl SET dl.bitEvaluated = 1, DateEvaluated = getdate()                   
  FROM DispositionLog dl, #AllSP sp, clientstudysurvey css                    
  WHERE dl.samplepop_id = sp.samplepop_id AND                   
  css.survey_ID = dl.survey_Id AND                  
  css.surveyType_ID = 2 AND                  
  dl.DaysFromFirst > 42 AND                   
  dl.bitEvaluated = 0                      

 -- PROCESS WORK                          
 -- Now lets work to update the Big_Table for the work we have identified.                          

  INSERT INTO #tblStudy (study_id, study)                   
  SELECT DISTINCT dl.study_id, 's' + CONVERT(VARCHAR,dl.study_id) AS study                   
  FROM dispositionlog dl, #AllSP sp                    
  WHERE dl.samplepop_id = sp.samplepop_id AND dl.bitEvaluated = 0                      
  CREATE CLUSTERED INDEX cix_study ON #tblstudy(study_id)                          

  SELECT DISTINCT table_schema + '.' + table_name studytbl, column_name                    
  INTO #HAV_HDISPCOL                      
  FROM INFORMATION_SCHEMA.COLUMNS c, #tblStudy s                    
  WHERE c.table_schema = s.study                    
  AND COLUMN_NAME = 'HDisposition' AND TABLE_NAME NOT LIKE '%VIEW%'                      

  -- Find out what base tables are home for the samplepop we will be working with.                          
  SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy                        
  WHILE @@ROWCOUNT > 0                          
  BEGIN                          

   -- GET samplepops that have HCAHPS dispositions that need to be evaluated (bitEvaluated = 0)                          
   TRUNCATE TABLE #DispoNew 
                        
   INSERT INTO #DispoNew (study_id, samplepop_id)                      
   SELECT DISTINCT dl.study_id, dl.samplepop_id                      
   FROM  DispositionLog dl, clientstudySurvey css, #AllSP sp                   
   WHERE dl.bitEvaluated = 0 and                   
   dl.study_id = @study_id  AND                   
   dl.samplepop_id = sp.samplepop_id and                  
   css.surveyType_ID = 2                  

   -- Find all logged dispositions for samplepops identified in #DispoNew                          
   TRUNCATE TABLE #DispoWork                      

   -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id          
   INSERT INTO #DispoWork (study_id, survey_id, samplepop_id, disposition_id, datLogged, DaysFromCurrent, DaysFromFirst, bitEvaluated, ReceiptType_id)                      
   SELECT dl.study_id, dl.survey_id, dl.samplepop_id, dl.disposition_id, dl.datLogged, dl.DaysFromCurrent, dl.DaysFromFirst, dl.bitEvaluated, dl.ReceiptType_id          
   FROM DispositionLog dl, #disponew dn, clientstudysurvey css                           
   WHERE dl.study_id = dn.study_id and dl.samplepop_id = dn.samplepop_id and css.survey_Id = dl.survey_Id and css.SurveyType_Id = 2        

    TRUNCATE TABLE #UpdateBT                      

    SET @SQL = 'INSERT INTO #UpdateBT (study_id, survey_id, samplepop_id, BT) SELECT DISTINCT n.study_Id, b.survey_id, n.samplepop_id, ''' +                       
  @study + '.'' + b.tablename AS BT FROM ' + @study + '.big_table_view b, #DispoNew n WHERE b.samplepop_id = n.samplepop_id and b.tablename >= ''big_table_2011_4'''                   

    if @indebug = 1 print @sql                          

    EXEC (@SQL)                          

--******** DRM
--and b.tablename >= ''big_table_2011_4''   
                   
   -- Update dispostionlog set bitEvaluated = 1 WHERE samplepops belong to a Non-HCAHPS survey                          

   TRUNCATE TABLE #DEL                      

   INSERT INTO #del (study_id, samplepop_id) SELECT u.study_id, u.samplepop_id                       
   FROM #updatebt u, clientstudysurvey c WHERE u.survey_id = c.survey_id and c.surveytype_id not in (2,3) AND u.study_id = @study_id                         

   INSERT INTO #DEL (study_id, samplepop_id)                       
   SELECT study_id, samplepop_id                       
   FROM #updatebt u                       
   LEFT JOIN #hav_hdispcol hc ON u.bt = hc.studytbl WHERE column_name IS NULL                          

   -- Update dispostionLog set bitEvaluated = 1 for dispostions that belong to samplepops prior to I1 HCAHPS samplesets (12/1/2005) - They don't have a column to Update                          
   --MWB 12-2-09 b/c of HCAHPS and HHCAHPS both sharing dispoLog we no longer set all non HCAHPS = bitEvaluated = 1 otherwise it would not evaulate the HHCHAPS Records                      
   --UPDATE dl SET dl.bitEvaluated = 1, DateEvaluated = getdate() FROM DispositionLog dl, #del d WHERE dl.samplepop_id = d.samplepop_id AND dl.bitEvaluated = 0                       

   -- Now delete the samplepops from #updateBT                          
   DELETE u FROM #updatebt u, #del d WHERE u.samplepop_id = d.samplepop_id                          

   --Calcuate the current the HCAHPSValue for the samplepop                          
   TRUNCATE TABLE #Dispo                      

   -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id, datlogged.
   -- TSB 06/16/2014 use surveytypedispositions table instead of hcahpsdispositions          
   INSERT INTO #Dispo (Study_id, survey_id, SamplePop_id, Disposition_id, HCAHPSHierarchy, HCAHPSVALUE, ReceiptType_id, datlogged)                          
   SELECT dw.study_id, dw.survey_id, dw.SamplePop_id, d.Disposition_id, hd.Hierarchy, hd.Value, dw.ReceiptType_id, dw.datlogged          
   FROM #dispowork dw, disposition d, surveytypedispositions hd, #updateBT u                            
   WHERE d.Disposition_id = dw.Disposition_id and                   
   d.disposition_ID = hd.disposition_ID AND                   
   dw.samplepop_id = u.samplepop_id AND                   
   dw.DaysFromFirst<43  
   AND hd.surveytype_id = 2                          

   TRUNCATE TABLE #SampDispo                            

   INSERT INTO #SampDispo (Study_id, survey_id, SamplePop_id, HCAHPSValue)                            
   SELECT t.Study_id, t.survey_id, t.SamplePop_id, HCAHPSValue          
   FROM #Dispo t, (SELECT SamplePop_id, MIN(HCAHPSHierarchy) HCAHPSHierarchy FROM #Dispo GROUP BY SamplePop_id) a                            
   WHERE t.SamplePop_id=a.SamplePop_id                            
   AND t.HCAHPSHierarchy=a.HCAHPSHierarchy                            
   GROUP BY t.Study_id, t.survey_id, t.SamplePop_id, HCAHPSValue          

  -- UPDATE BIG_TABLE DISPOSTION                          
   -- Loop through each study, and update the Big_Table HCAHPSValue field ONLY if the HCAHPSValue is NOT NULL (Meaning is has a previous value either a default or prior disposition value)                         

   TRUNCATE TABLE #ULoop                      

   INSERT INTO #ULoop (BT) SELECT DISTINCT BT FROM #UpdateBT WHERE study_id = @study_id                      
   SELECT TOP 1 @BT= bt FROM #ULoop                           
   WHILE @@ROWCOUNT > 0                          
   BEGIN                                           

     --LagTime calcs            

--  --Step 1: If initial "08" population, lagtime = datmailed + 42 - dischargedate            
--  select dateadd(dd,42,sm.datmailed) datmailed, schm.samplepop_id            
--  into #tmp            
--  from qualisys.qp_prod.dbo.sentmailing sm inner join qualisys.qp_prod.dbo.scheduledmailing schm            
--   on sm.sentmail_id = schm.sentmail_id            
--  inner join #SampDispo sd            
--   on schm.samplepop_id = sd.samplepop_id            
--  where sd.HCAHPSValue = '08'            

--  select max(datmailed) datmailed, samplepop_id             
--  into #tmp_datmailed            
--  from #tmp            
--  group by samplepop_id            

--  set @sql = 'UPDATE sd SET lagtime = abs(datediff(dd, dm.datmailed, bt.dischargedate)) FROM ' + @BT + ' bt, #SampDispo sd, #tmp_datmailed dm WHERE bt.samplepop_id = sd.samplepop_id AND bt.samplepop_id = dm.samplepop_id'            

--  if @indebug = 1 PRINT @SQL                          

--  EXEC (@SQL)                          

--select 'step 1'            
--select * from #sampdispo            

 --DRM 12/27/2011 Add check to make sure Lagtime exists in big_table            
 select @sql = 'if not exists (select 1 from information_schema.columns where column_name = ''lagtime'' and table_schema + ''.'' + table_name = ''' + @BT + ''' )           
 alter table ' + @BT + ' add LagTime int           
 exec sp_dbm_makeview ''s' + cast(@study_id as varchar) + ''', ''big_table'''            

 exec (@sql)          

  --Step 2: If returns exist, lagtime = returndate - dischargedate            
  set @sql = 'UPDATE sd SET lagtime = abs(datediff(dd, sr.datreturned, bt.dischargedate)) FROM ' + @BT + ' bt, ' + replace(@BT, 'big_table', 'study_results') + ' sr, #SampDispo sd     
 WHERE bt.samplepop_id = sd.samplepop_id AND bt.samplepop_id = sr.samplepop_id and sd.lagtime = 0'            
  --if @indebug = 1             
  PRINT @SQL            

  if exists (select 1 from information_schema.tables where table_schema+'.'+table_name = replace(@BT, 'big_table', 'study_results'))            

  EXEC (@SQL)                          

--select 'step 2'            

--select * from #sampdispo            

  --Step 3: If undeliverable, lagtime = datundeliverable - dischargedate            
  set @sql = 'UPDATE sd SET lagtime = isnull(abs(datediff(dd, bt.datundeliverable, bt.dischargedate)), 0) FROM ' + @BT + ' bt, #SampDispo sd WHERE bt.samplepop_id = sd.samplepop_id AND sd.lagtime = 0 and bt.datundeliverable is null'            
  --if @indebug = 1            
   PRINT @SQL                          
  EXEC (@SQL)                          

--select 'step 3'            
--select * from #sampdispo            

  --Step 4: Else, lagtime = disposition date - dischargedate  
  -- TSB 06/16/2014 use surveytypedispositions table instead of hcahpsdispositions          
  set @sql = 'UPDATE sd SET lagtime = abs(datediff(dd, dw.datLogged, bt.dischargedate)) FROM ' + @BT + ' bt, #SampDispo sd, #dispowork dw, dispositions hd     
 WHERE bt.samplepop_id = sd.samplepop_id and bt.samplepop_id = dw.samplepop_id and sd.hcahpsvalue = hd.value and hd.disposition_id = dw.disposition_id AND sd.lagtime = 0 and hd.surveytype_id = 2'            
  --if @indebug = 1             
  PRINT @SQL                          
  EXEC (@SQL)                          

--select 'step 4'            
--select * from #sampdispo            

--************************          

--**    HNumAttempts          

--************************    

if @indebug = 1 select 'one'  
if @indebug = 1 select * from #dispo   
if @indebug = 1 select * from #sampdispo   

update dw          
set sentmail_id = qdl.sentmail_id          
from #dispo dw inner join qualisys.qp_prod.dbo.dispositionlog qdl          
 on dw.samplepop_id = qdl.samplepop_id          
 and dw.disposition_id = qdl.disposition_id          
 and dw.datlogged = qdl.datlogged          

if @indebug = 1  
select *  
from #dispo dw inner join qualisys.qp_prod.dbo.dispositionlog qdl          
 on dw.samplepop_id = qdl.samplepop_id          
 and dw.disposition_id = qdl.disposition_id          
 and dw.datlogged = qdl.datlogged       

if @indebug = 1   
select *  
from #dispo dw inner join   
(select samplepop_id, max(sentmail_id) sentmail_id from #dispo group by samplepop_id) dw2  
 on dw.samplepop_id = dw2.samplepop_id  
where dw.sentmail_id is null  

update dw  
set sentmail_id = dw2.sentmail_id  
from #dispo dw inner join   
(select samplepop_id, max(sentmail_id) sentmail_id from #dispo group by samplepop_id) dw2  
 on dw.samplepop_id = dw2.samplepop_id  
where dw.sentmail_id is null  

if @indebug = 1   
begin  
 select 'hi'  
 select * from #dispo  
end  

if @indebug = 1 select 'two'  
if @indebug = 1 select * from #dispo   
if @indebug = 1 select * from #sampdispo   

update sd          
set sentmail_id = dw.sentmail_id,          
 receipttype_id = dw.receipttype_id,          
 datlogged = dw.datlogged          
from #sampdispo sd inner join #dispo dw          
 on sd.samplepop_id = dw.samplepop_id          
 and sd.hcahpsvalue = dw.hcahpsvalue          
-- and sd.datlogged = dw.datlogged          

if @indebug = 1   
select *  
from #sampdispo sd inner join #dispo dw          
 on sd.samplepop_id = dw.samplepop_id          
 and sd.hcahpsvalue = dw.hcahpsvalue      

if @indebug = 1 select 'three'  
if @indebug = 1 select * from #dispo   
if @indebug = 1 select * from #sampdispo   

--Phone methodology where receipttype_id = 12          

truncate table #tmp_samplepops          

insert into #tmp_samplepops (samplepop_id, datlogged)          
select distinct sd.samplepop_id, sd.datlogged          
from #sampdispo sd inner join qualisys.qp_prod.dbo.mailingmethodology mm           
 on sd.survey_id = mm.survey_id           
inner join qualisys.qp_prod.dbo.standardmethodology sm           
 on mm.standardmethodologyid = sm.standardmethodologyid           
where sd.receipttype_id = 12          
and mm.bitactivemethodology = 1          
and sm.standardmethodologyid in (2, 12)          

select top 1 @samplepop_id = samplepop_id, @datlogged = datlogged from #tmp_samplepops          

while (select count(*) from #tmp_samplepops) > 0      
begin          
-- DRM 3/1/2011 HNumAttempts fix    
 select @tmp_count = count(*) from dispositionlog --#dispo          
 where datlogged <= @datlogged          
 and samplepop_id = @samplepop_id          
 and receipttype_id = 12    
 and loggedby <> '#nrcsql'  

 if @tmp_count > 5 set @tmp_count = 5    


 update #sampdispo          
 set hnumattempts = @tmp_count    
 where samplepop_id = @samplepop_id          

 delete #tmp_samplepops where samplepop_id = @samplepop_id          

 select top 1 @samplepop_id = samplepop_id, @datlogged = datlogged from #tmp_samplepops          

end          

          

--Phone methodology where receipttype_id <> 12          

truncate table #tmp_samplepops          

insert into #tmp_samplepops (samplepop_id, datlogged)          
select distinct sd.samplepop_id, sd.datlogged          
from #sampdispo sd inner join qualisys.qp_prod.dbo.mailingmethodology mm           
 on sd.survey_id = mm.survey_id           
inner join qualisys.qp_prod.dbo.standardmethodology sm           
 on mm.standardmethodologyid = sm.standardmethodologyid  
where sd.receipttype_id <> 12          
and mm.bitactivemethodology = 1          
and sm.standardmethodologyid in (2, 12)          

select top 1 @samplepop_id = samplepop_id, @datlogged = datlogged from #tmp_samplepops          

while (select count(*) from #tmp_samplepops) > 0      
begin          
-- DRM 3/1/2011 HNumAttempts fix    
 select @tmp_count = count(*) from dispositionlog --#dispo          
 where datlogged < @datlogged          
 and samplepop_id = @samplepop_id          
 and receipttype_id = 12    
 and loggedby <> '#nrcsql'  

 if @tmp_count > 5 set @tmp_count = 5    

 update #sampdispo          
 set hnumattempts = @tmp_count    
 where samplepop_id = @samplepop_id         

 delete #tmp_samplepops where samplepop_id = @samplepop_id          

 select top 1 @samplepop_id = samplepop_id, @datlogged = datlogged from #tmp_samplepops          

end          

          

      

--Mail methodology          

truncate table #tmp_samplepops2          

insert into #tmp_samplepops2 (samplepop_id, sentmail_id)          
select distinct sd.samplepop_id, sd.sentmail_id          
from #sampdispo sd inner join qualisys.qp_prod.dbo.mailingmethodology mm           
 on sd.survey_id = mm.survey_id           
inner join qualisys.qp_prod.dbo.standardmethodology sm           
 on mm.standardmethodologyid = sm.standardmethodologyid           
where mm.bitactivemethodology = 1          
and sm.standardmethodologyid in (1, 9)          

if @indebug = 1 select * from #tmp_samplepops2      

select top 1 @samplepop_id = samplepop_id, @sentmail_id = sentmail_id from #tmp_samplepops2          

while (select count(*) from #tmp_samplepops2) > 0      
begin          
 select @tmp_count = count(*) from qualisys.qp_prod.dbo.scheduledmailing --#dispo      -- DRM 3/1/2011 HNumAttempts fix    
 where sentmail_id <= @sentmail_id          
 and samplepop_id = @samplepop_id          

 if @tmp_count = 0 begin select 'count=0' set @tmp_count = 1 end  

 update #sampdispo          
 set hnumattempts = @tmp_count  
 where samplepop_id = @samplepop_id          

 delete #tmp_samplepops2 where samplepop_id = @samplepop_id          

 select top 1 @samplepop_id = samplepop_id, @sentmail_id = sentmail_id from #tmp_samplepops2          

end          

if @indebug = 1 select * from #sampdispo    

 --DRM 12/02/2011 Add check to make sure HNumAttempts exists in big_table            
 select @sql = 'if not exists (select 1 from information_schema.columns where column_name = ''HNumAttempts'' and table_schema + ''.'' + table_name = ''' + @BT + ''' )           
 alter table ' + @BT + ' add HNumAttempts int           
 exec sp_dbm_makeview ''s' + cast(@study_id as varchar) + ''', ''big_table'''            

 exec (@sql)     

     -- Only update HCAHPS samplepops                          
     SET @SQL = 'UPDATE bt SET HDisposition = sd.HCAHPSValue, LagTime = sd.LagTime, HNumAttempts = sd.HNumAttempts FROM ' + @BT + ' bt, #SampDispo sd WHERE bt.samplepop_id = sd.samplepop_id AND bt.HDisposition IS NOT NULL'                          

  if @indebug = 1 PRINT @SQL                          

     EXEC (@SQL)                          

     UPDATE #sampdispo SET bitEvaluated = 1 FROM #UpdateBT bt, #SampDispo sd WHERE bt.samplepop_id = bt.samplepop_id AND bt.BT = @bt                          

     DELETE FROM #ULoop WHERE @BT= bt                       

     SELECT TOP 1 @BT= bt FROM #ULoop                           

   END                          

   -- Now we can update the bitEvaluated flag and set it to 1 for all dispositionlog table for which we have just updated Big_Table.                          
   UPDATE dl SET dl.bitEvaluated = sd.bitEvaluated, DateEvaluated = getdate() FROM DispositionLog dl, #SampDispo sd WHERE dl.study_id = sd.study_id AND dl.samplepop_id = sd.samplepop_id AND dl.bitEvaluated = 0                      

   DELETE FROM #tblStudy WHERE study_id = @study_id                      

   SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy                        

  END                          


 -- CLEAN UP                          
  DROP TABLE #UPDATEBT                          
  DROP TABLE #DEL                          
  DROP TABLE #ULOOP                          
  DROP TABLE #DISPONEW                          
  DROP TABLE #DISPOWORK                          
  DROP TABLE #DISPO                          
  DROP TABLE #SAMPDISPO                          
  DROP TABLE #tblStudy                      
  DROP TABLE #Hav_HDispCol                    
  drop table #tmp_samplepops        
  drop table #tmp_samplepops2        

  SET NOCOUNT OFF                      

END                     

  DROP TABLE #AllSP                    

RETURN                      

----------------------------------------------------------------------------------
