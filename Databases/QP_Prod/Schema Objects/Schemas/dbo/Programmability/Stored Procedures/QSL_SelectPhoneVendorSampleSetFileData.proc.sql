/*********************************************************************************************************    
QSL_SelectPhoneVendorSampleSetFileData    
Created by: Michael Beltz     
Purpose: This proc is used to create a phone vendor file and is called from both a SSRS report and an    
   internal application service that creates and sends files to non-mail vendors.    
    
History Log:    
Created on: 05/14/09    
Modified  : 07/06/09 MWB    
   Added Optional Variables:    
   @SaveData controls if records will be written to the perm. table    
   @VendorFileID is required if @SaveData = 1 as the data must tie back to a vendor file record    
   @inDebug is just that.  Creates extra print statements for debug.    
   @UseWorkTable used only in formgen to join to a work table for seconds (or any subset of a sampleset)    
   @bitUpdate used if we need to update records already in the system instead of create new records.    
  
modified  : 2/15/10 MWB  
 Added mailingstep inner join to #samplepop table because prenote IVR surveys were duplicating respondents  

modified  : 9/10/10 DRM
 Changed addr field to len of 60 in temp table
*********************************************************************************************************/    
    
CREATE proc QSL_SelectPhoneVendorSampleSetFileData (@Sampleset_ID int, @SaveData bit = 0, @bitUpdate int = 0, @VendorFileID int = 0, @UseWorkTable bit =0,  @inDebug int = 0)      
as      
      
begin      
      
Declare @Study_ID VARCHAR(50), @Survey_ID VARCHAR(50),  @SQL Varchar(8000), @ordername VARCHAR(30)         
    
/*    
--Debug Code    
declare @inDebug bit, @Sampleset_ID int, @SaveData bit, @VendorFileID int, @bitUpdate bit, @UseWorkTable bit    
set @inDebug = 1      
set @SaveData = 0    
set @Sampleset_ID = 466    
set @VendorFileID = 26    
set @bitUpdate = 0     
set @UseWorkTable = 0    
    
sp_helptext QSL_SelectPhoneVendorSampleSetFileData    
    
--To get just Result Data back    
--QSL_SelectPhoneVendorSampleSetFileData 525753, 0,0, 0, 0, 1    
    
    
--update data sql    
--QSL_SelectPhoneVendorSampleSetFileData 524401, 1,0, 2, 0, 1    
    
--To test all variables like calling from SP_FG_Nonmailgen    
--drop table #FG_NonMailingWork    
--Create table #FG_NonMailingWork (Samplepop_ID int)    
--insert into #FG_NonMailingWork select 12001    
--insert into #FG_NonMailingWork select 12002    
--exec QSL_SelectPhoneVendorSampleSetFileData 524401, 1,0, 2, 0, 1    
    
--select * from VendorPhoneFile_Data where vendorFile_ID = 26    
--select * from vendorFile_freqs where vendorFile_ID = 26    
--select * from vendorFile_nullcounts where vendorFile_ID = 26    
*/    
    
    
if @indebug = 1 print 'Start QSL_SelectPhoneVendorSampleSetFileData'    
    
if @SaveData <> 0 and  @VendorFileID = 0    
 begin     
  RAISERROR ('Cannot update data if VendorFile_ID is 0.  Contact system administrator.', -- Message text.    
          16, -- Severity.    
       1 -- State.    
     )    
  return    
 end    
    
    
declare @RecordCount int, @NoLithoCount int    
    
set @RecordCount = 0    
set @NoLithoCount = 0    

Create table #Results       
(      
HCAHPSSamp int,       
Litho  Varchar(42),       
Survey_ID int,       
Sampleset_ID int ,      
Phone Varchar(42),       
AltPhone Varchar(42),       
FName Varchar(42),       
LName Varchar(42),       
Addr  Varchar(60),      
Addr2 Varchar(42),       
City  Varchar(42),       
St  Varchar(42),       
Zip5  Varchar(42),       
PhServDate varchar(42),       
LangID  Varchar(42),       
Telematch Varchar(42),      
--DischargeUnit Varchar(42),      
PhFacName Varchar(100),      
PhServInd1 Varchar(100),      
PhServInd2 Varchar(100),      
PhServInd3 Varchar(100),      
PhServInd4 Varchar(100),       
PhServInd5 Varchar(100),       
PhServInd6 Varchar(100),       
PhServInd7 Varchar(100),       
PhServInd8 Varchar(100),       
PhServInd9 Varchar(100),       
PhServInd10 Varchar(100),       
PhServInd11 Varchar(100),       
PhServInd12 Varchar(100)       
)       
      
select @Study_ID = sd.Study_ID, @Survey_ID = ss.survey_ID      
from Sampleset ss, survey_Def sd      
where ss.survey_ID = sd.survey_ID and      
  ss.sampleset_ID = @Sampleset_ID      
      
    
      
if @inDebug = 1          
 begin            
  print '@Study_id ' + cast(@Study_id as varchar(100))          
  print '@Survey_id ' + cast(@Survey_id as varchar(100))          
 end          
      
--Get Sampleset Info.      
SELECT SampleSet_id, CONVERT(VARCHAR(19),datSampleCreate_dt,120) AS 'Date Sampled', survey_ID            
INTO #Sampleset            
FROM SampleSet            
WHERE Survey_id=@Survey_id            
AND Sampleset_ID = @Sampleset_ID      
      
--Get all SamplePops          
SELECT sp.SamplePop_id, cast(ISNULL(MIN(strLithoCode),'NotPrinted') as varchar(12)) Litho, [Date Sampled], ss.survey_ID, NULL as HCAHPS, schm.mailingstep_ID                
INTO #SamplePop                 
FROM #SampleSet ss, SamplePop sp   
   LEFT OUTER JOIN ScheduledMailing schm ON sp.SamplePop_id=schm.SamplePop_id                
    inner join MAILINGSTEP mm on schm.MAILINGSTEP_ID = mm.MAILINGSTEP_ID                
   LEFT OUTER JOIN SentMailing sm ON schm.SentMail_id=sm.SentMail_id                
WHERE ss.SampleSet_id=sp.SampleSet_id and mm.MailingStepMethod_id in (1,3)             
GROUP BY sp.SamplePop_id, [Date Sampled],ss.survey_ID, schm.mailingstep_ID                   
    
if @UseWorkTable = 1    
begin    
 delete from #samplepop where mailingstep_ID not in (select mailingstep_ID from #FG_nonMailingWork)    
end    
    
if @inDebug = 1     
 select '#SamplePop' [#SamplePop], * from #SamplePop    
    
      
--Check to see if Samplepop was sampled for HCAHPS      
select sp.Samplepop_ID, max(cast(su.bitHCAHPS as tinyint)) HCAHPS      
into #maxHCAHPS      
from #SamplePop s, samplepop sp, selectedSample ss, sampleunit su      
where s.samplepop_ID = sp.samplepop_ID and      
  sp.sampleset_ID = ss.sampleset_ID and      
  sp.study_ID = ss.study_Id and      
  sp.pop_ID = ss.pop_ID and      
  ss.sampleunit_ID = su.sampleunit_ID      
group by sp.Samplepop_ID      
      
--update Samplepop HCAHPS value      
update s      
set  s.HCAHPS = h.HCAHPS      
from #SamplePop s, #maxHCAHPS h      
where s.samplepop_ID = h.samplepop_ID       
      
--in case we still have nulls make sure they get set to 0      
update #SamplePop set HCAHPS = 0 where HCAHPS is null      
      
SET @SQL=''          
          
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'AreaCode') and          
   exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'Phone')      
 begin          
  set @SQL = @SQL + ', ISNULL(LTRIM(RTRIM(LEFT(p.AreaCode,3))),'''')+LTRIM(RTRIM(p.Phone)) as Phone '          
 end          
else      
 begin      
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because Area Code or Phone Number is not mapped properly.',    
   vendorfileStatus_Id = 6     
  where VendorFile_ID = @VendorFileID    
 end    
  RAISERROR (N'File cannot be created because Area Code or Phone Number is not mapped properly.', 16, 1)      
  set @SQL = @SQL + ', '''' as Phone '      
  goto CLEANUP      
 end      
          
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhAltAreaCd') and          
   exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhAltPhone')      
 begin          
  set @SQL = @SQL + ', ISNULL(LTRIM(RTRIM(LEFT(p.PhAltAreaCd,3))),'''')+LTRIM(RTRIM(p.PhAltPhone)) as AltPhone '          
 end          
else      
 set @SQL = @SQL + ', '''' as AltPhone '      
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'FName')          
 set @SQL = @SQL + ', p.FName '          
else      
 begin      
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because First Name metafield (FName) is not mapped properly.',    
   vendorfileStatus_Id = 6     
  where VendorFile_ID = @VendorFileID    
 end     
  RAISERROR (N'File cannot be created because First Name metafield (FName) is not mapped properly.', 10, 1)          
  set @SQL = @SQL + ', '''' as FName '         
  goto CLEANUP      
 end      
      
          
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'LName')          
 set @SQL = @SQL + ', p.LName '          
else        
 begin        
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because Last Name metafield (LName) is not mapped properly.',    
   vendorfileStatus_Id = 6     
  where VendorFile_ID = @VendorFileID    
 end      
  RAISERROR (N'File cannot be created because Last Name metafield (LName) is not mapped properly.', 10, 1)          
  set @SQL = @SQL + ', '''' as LName '          
  goto CLEANUP      
 end      
      
          
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'Addr')          
 set @SQL = @SQL + ', p.Addr '          
else      
 begin          
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because Address metafield (Addr) is not mapped properly.',    
   vendorfileStatus_Id = 6     
  where VendorFile_ID = @VendorFileID    
 end       
  RAISERROR (N'File cannot be created because Address metafield (Addr) is not mapped properly.', 10, 1)          
  set @SQL = @SQL + ', '''' as Addr '          
  goto CLEANUP      
 end      
      
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'Addr2')          
 set @SQL = @SQL + ', p.Addr2 '          
else          
 set @SQL = @SQL + ', '''' as Addr2 '          
      
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'City')          
 set @SQL = @SQL + ', p.City '          
else      
 begin      
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because City metafield (City) is not mapped properly.',    
   vendorfileStatus_Id = 6     
  where VendorFile_ID = @VendorFileID    
 end       
  RAISERROR (N'File cannot be created because City metafield (City) is not mapped properly.', 10, 1)              
  --set @SQL = @SQL + ', '''' as City '          
  goto CLEANUP      
 end      
          
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'St')          
 set @SQL = @SQL + ', p.St '          
else         
 begin       
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because State metafield (St) is not mapped properly.',    
   vendorfileStatus_Id = 6     
  where VendorFile_ID = @VendorFileID    
 end       
  RAISERROR (N'File cannot be created because State metafield (St) is not mapped properly.', 10, 1)              
  set @SQL = @SQL + ', '''' as St '          
  goto CLEANUP      
 end      
          
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'Zip5')          
 set @SQL = @SQL + ', p.Zip5 '          
else        
 begin        
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because Zip code metafield (Zip5) is not mapped properly.',    
   vendorfileStatus_Id = 6     
  where VendorFile_ID = @VendorFileID    
 end        
  RAISERROR (N'File cannot be created because Zip code metafield (Zip5) is not mapped properly.', 10, 1)              
  set @SQL = @SQL + ', '''' as Zip5 '          
  goto CLEANUP      
 end      
          
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServDate')          
 set @SQL = @SQL + ', CONVERT(VARCHAR, PhServDate, 101) '          
else        
 begin      
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because Phone Service Date metafield (PhServDate) is not mapped properly.'    
  where VendorFile_ID = @VendorFileID    
 end          
  RAISERROR (N'File cannot be created because Phone Service Date metafield (PhServDate) is not mapped properly.', 10, 1)              
  set @SQL = @SQL + ', '''' as PhServDate '          
  goto CLEANUP      
 end      
          
if exists(select 'x' from MetaData_View v, metafield m where strTable_nm = 'POPULATION' AND  m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'LangID')          
 set @SQL = @SQL + ', p.LangID '          
else        
 begin     
  if @VendorFileID <> 0    
 begin    
  Update VendorFileCreationQueue    
  set ErrorDesc = 'File cannot be created because Language ID code metafield (LangID) is not mapped properly.'    
  where VendorFile_ID = @VendorFileID    
 end           
  RAISERROR (N'File cannot be created because Language ID code metafield (LangID) is not mapped properly.', 10, 1)              
  set @SQL = @SQL + ', '''' as LangID '          
  goto CLEANUP      
 end      
          
--hard coded for now until we start doing telematch in house          
set @SQL = @SQL + ', '''' as Telematch'          
          
--if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'DischargeUnit')          
-- set @SQL = @SQL + ', DischargeUnit '          
--else          
-- set @SQL = @SQL + ', '''' as DischargeUnit '          
      
--new fields start here:      
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhFacName')          
 set @SQL = @SQL + ', PhFacName '          
else          
 set @SQL = @SQL + ', '''' as PhFacName '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd1')          
 set @SQL = @SQL + ', PhServInd1 '         
else          
 set @SQL = @SQL + ', '''' as PhServInd1 '          
          
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd2')          
 set @SQL = @SQL + ', PhServInd2 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd2 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd3')          
 set @SQL = @SQL + ', PhServInd3 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd3 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd4')          
 set @SQL = @SQL + ', PhServInd4 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd4 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd5')          
 set @SQL = @SQL + ', PhServInd5 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd5 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd6')          
 set @SQL = @SQL + ', PhServInd6 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd6 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd7')          
 set @SQL = @SQL + ', PhServInd7 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd7 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd8')          
 set @SQL = @SQL + ', PhServInd8 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd8 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd9')          
 set @SQL = @SQL + ', PhServInd9 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd9 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd10')          
 set @SQL = @SQL + ', PhServInd10 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd10 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd11')          
 set @SQL = @SQL + ', PhServInd11 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd11 '          
      
if exists(select 'x' from MetaData_View v, metafield m where m.field_ID = v.field_ID and v.study_ID = @Study_ID and m.strfield_nm = 'PhServInd12')          
 set @SQL = @SQL + ', PhServInd12 '          
else          
 set @SQL = @SQL + ', '''' as PhServInd12 '          
      
if @inDebug = 1 print @SQL             
        
          
SET @ordername = ' LName, FName '            
      
IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')            
 begin    
     
   SET @SQL='INSERT INTO #RESULTS (HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone , '+CHAR(10)+  
   'FName , LName , Addr , Addr2 , City , St , Zip5 , PhServDate, LangID ,  Telematch,  PhFacName ,  '+CHAR(10)+  
   'PhServInd1 ,  PhServInd2 ,  PhServInd3 ,  PhServInd4 ,  PhServInd5 ,  PhServInd6 ,  PhServInd7 , '+CHAR(10)+  
   'PhServInd8 ,  PhServInd9 ,  PhServInd10 ,  PhServInd11 ,  PhServInd12)'+CHAR(10)+       
   'SELECT DISTINCT t.HCAHPS, Litho, t.Survey_ID, sp.Sampleset_ID '+@SQL+' ' +CHAR(10)+            
   'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t, SelectedSample sel, S'+CONVERT(VARCHAR,@Study_id)+'.Encounter e'    
    
   if @UseWorkTable = 1    
   set @SQL = @SQL + ', #FG_NonMailingWork nmw ' +CHAR(10)    
    
   set @SQL = @SQL + ' WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+            
   ' AND sp.Pop_id=p.Pop_id'+CHAR(10)+            
   ' AND sp.Pop_id=sel.Pop_id'+CHAR(10)+            
   ' AND sp.SampleSet_id=sel.SampleSet_id'+CHAR(10)+            
   ' AND sel.Enc_id=e.Enc_id' +CHAR(10)    
    
  if @UseWorkTable = 1    
   set @SQL = @SQL + ' AND nmw.Samplepop_ID = sp.samplepop_ID  AND nmw.mailingStep_ID = t.mailingStep_ID ' + CHAR(10)    
              
   set @SQL = @SQL + ' ORDER BY ' + @Ordername            
 end    
ELSE       
 begin         
     
   SET @SQL='INSERT INTO #RESULTS (HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone , '+CHAR(10)+  
   'FName , LName , Addr , Addr2 , City , St , Zip5 , PhServDate, LangID ,  Telematch,  PhFacName ,  '+CHAR(10)+  
   'PhServInd1 ,  PhServInd2 ,  PhServInd3 ,  PhServInd4 ,  PhServInd5 ,  PhServInd6 ,  PhServInd7 ,  '+CHAR(10)+  
   'PhServInd8 ,  PhServInd9 ,  PhServInd10 ,  PhServInd11 ,  PhServInd12) '+CHAR(10)+         
   'SELECT DISTINCT t.HCAHPS, t.Litho, t.Survey_ID, sp.Sampleset_ID  '+@SQL+' ' +CHAR(10)+            
   'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t'            
   if @UseWorkTable = 1    
   set @SQL = @SQL + ', #FG_NonMailingWork nmw ' +CHAR(10)    
    
   set @SQL = @SQL + ' WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+            
   'AND sp.Pop_id=p.Pop_id' + CHAR(10)    
    
  if @UseWorkTable = 1    
   set @SQL = @SQL + ' AND nmw.Samplepop_ID = sp.samplepop_ID  AND nmw.mailingStep_ID = t.mailingStep_ID ' + CHAR(10)    
              
   set @SQL = @SQL + 'ORDER BY ' + @Ordername            
 end    
    
      
if @inDebug = 1 print @sql            
      
    
EXEC (@sql)            
      
      
if @SaveData = 0    
 begin            
  select count(*) NotPrintedCount      
  from #Results       
  where litho = 'NotPrinted'      
 end    
else    
 begin    
  select @NoLithoCount = count(*)     
  from #Results       
  where litho = 'NotPrinted'      
     
 end    
      
Delete from #Results      
where litho = 'NotPrinted'      
      
if @inDebug = 1 print '@VendorFileID = '  + cast(@VendorFileID as varchar(100))    
    
if @SaveData = 0    
 begin    
     
  if @inDebug = 1 print 'No Save just Return Data'    
  select HCAHPSSamp,Litho,Survey_ID,Sampleset_ID,Phone,AltPhone,FName,LName,Addr,Addr2,City,St,    
    Zip5,PhServDate,LangID,Telematch,PhFacName,PhServInd1,PhServInd2,PhServInd3,PhServInd4,    
    PhServInd5,PhServInd6,PhServInd7,PhServInd8,PhServInd9,PhServInd10,PhServInd11,PhServInd12     
  from #Results      
 end    
else    
 begin    
      
  --we want to force an insert if there are no values in the table.    
  --even if the user selected to update the data.    
  if (select count(*) from VendorPhoneFile_Data where VendorFile_Id = @VendorFileID) = 0    
  begin    
   select @bitUpdate = 0    
  end    
     
  if @bitUpdate = 0    
   begin    
       
    if @inDebug = 1 print 'Insert new data'    
        
    --usually there will be nothing here, but it is possible to have records already in the    
    --system.  In that case we only want 1 set of data.    
    delete from VendorPhoneFile_Data where VendorFile_Id = @VendorFileID    
    
    insert into VendorPhoneFile_Data     
      (VendorFile_ID,HCAHPSSamp,Litho,Survey_ID,Sampleset_ID,Phone,AltPhone, FName,LName,Addr,Addr2,    
      City,St,Zip5,PhServDate,LangID,Telematch,PhFacName,PhServInd1,PhServInd2,PhServInd3,    
      PhServInd4,PhServInd5,PhServInd6,PhServInd7,PhServInd8,PhServInd9,PhServInd10,PhServInd11,    
      PhServInd12)    
    select @VendorFileID as VendorFile_ID,HCAHPSSamp,Litho,Survey_ID,Sampleset_ID,Phone,AltPhone,FName,    
      LName,Addr,Addr2,City,St,Zip5,PhServDate,LangID,Telematch,PhFacName,PhServInd1,PhServInd2,    
      PhServInd3,PhServInd4,PhServInd5,PhServInd6,PhServInd7,PhServInd8,PhServInd9,PhServInd10,    
      PhServInd11,PhServInd12     
    from #Results      
    
    select @RecordCount = @@RowCount    
    
    update VendorFileCreationQueue     
    set dateDataCreated = getdate(), VendorFileStatus_ID = 2,    
     RecordsInFile = @RecordCount, RecordsNoLitho = @NoLithoCount,    
     ErrorDesc = ''    
    where VendorFile_ID = @VendorFileID    
    
   end    
  else    
   begin    
       
    if @inDebug = 1 print 'Update existing data'    
        
    Update VPF    
    set     
     VPF.HCAHPSSamp = r.HCAHPSSamp,    
     VPF.Survey_ID = r.Survey_ID,    
     VPF.Sampleset_ID = r.Sampleset_ID,    
     VPF.Phone = r.Phone,    
     VPF.AltPhone = r.AltPhone,    
     VPF.FName = r.FName,    
     VPF.LName = r.LName,    
     VPF.Addr = r.Addr,    
     VPF.Addr2 = r.Addr2,    
     VPF.City = r.City,    
     VPF.St = r.St,    
     VPF.Zip5 = r.Zip5,    
     VPF.PhServDate = r.PhServDate,    
     VPF.LangID = r.LangID,    
     VPF.Telematch = r.Telematch,    
     VPF.PhFacName = r.PhFacName,    
     VPF.PhServInd1 = r.PhServInd1,    
     VPF.PhServInd2 = r.PhServInd2,    
     VPF.PhServInd3 = r.PhServInd3,    
     VPF.PhServInd4 = r.PhServInd4,    
     VPF.PhServInd5 = r.PhServInd5,    
     VPF.PhServInd6 = r.PhServInd6,    
     VPF.PhServInd7 = r.PhServInd7,    
     VPF.PhServInd8 = r.PhServInd8,    
     VPF.PhServInd9 = r.PhServInd9,    
     VPF.PhServInd10 = r.PhServInd10,    
     VPF.PhServInd11 = r.PhServInd11,    
     VPF.PhServInd12 = r.PhServInd12    
    from VendorPhoneFile_Data VPF, #results r    
    where VPF.litho = r.litho and    
      VPF.VendorFile_ID = @VendorFileID    
    
    select @RecordCount = @@RowCount     
    
    update VendorFileCreationQueue     
    set dateDataCreated = getdate(), VendorFileStatus_ID = 2,    
     RecordsInFile = isnull(@RecordCount, 0), RecordsNoLitho = isnull(@NoLithoCount, 0),    
     ErrorDesc = ''    
    where VendorFile_ID = @VendorFileID    
      
    
   end    
 end    
    
    
if @VendorFileID <> 0    
 begin    
  if @inDebug = 1 print 'calling QSL_VendorFileCreateCounts'    
  exec QSL_VendorFileCreateCounts @VendorFileID, @inDebug    
  if @inDebug = 1 print 'calling QSL_VendorFileValidation'    
  exec QSL_VendorFileValidation @VendorFileID, @inDebug    
 end    
    
    
CLEANUP:         
DROP TABLE #SAMPLESET            
DROP TABLE #SAMPLEPOP      
DROP TABLE #Results      
DROP TABLE #maxHCAHPS      
end


