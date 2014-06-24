/*          
Business Purpose:           
This procedure is used to calculate the number of eligible discharges.  It          
is used IN the header record of the CMS export          
          
Created:  06/22/2006 by DC          
          
Modified:          
        
 Modified Export_SampleunitAvailableCount call to Export_HCAHPSSampleunitAvailableCount and         
 Export_HHCAHPSSampleunitAvailableCount to split out hcahps and hhcahps logic.        

Modified: MWB 5/19/2010
 Added delete from ExportSetCMSAvailableCount because
 with the change to using MedicareExportSets it is now possible to use the same GUID
 more than once.  Since we always want the data to be current we simply delete before the insert

Modified: CJB 6/19/2014
 Included Ineligible count (.big_table_view bt where HDisposition = ''03'') to be subtracted from AvailableCount (Export_HHCAHPSSampleunitAvailableCount)
          
*/            
ALTER PROCEDURE [dbo].[DCL_ExportFileCMSAvailableCount]          
 @exportsets VARCHAR(2000),          
 @exportfileguid UNIQUEIDENTIFIER,      
 @indebug bit = 0          
AS          
          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
DECLARE @Server VARCHAR(100), @sql nvarchar(max)          
          
SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'          
          
DECLARE @Ineligible INT = 0
DECLARE @study varchar(10)
DECLARE @sel VARCHAR(8000), @sampleunit_id INT, @startdate DATETIME, @enddate DATETIME, @ExportSetTypeID int          
CREATE TABLE #exportsets (sampleunit_id INT, startdate DATETIME, enddate DATETIME, ExportSetTypeID int)          
CREATE TABLE #counts (n INT)          
CREATE TABLE #unitcounts (sampleunit_id INT, n INT)          
          
SET @sel='INSERT INTO #exportsets (sampleunit_id, startdate, enddate, ExportSetTypeID)          
SELECT DISTINCT sampleunit_id, encounterstartdate, encounterenddate, ExportSetTypeID          
FROM exportset          
WHERE exportsetid IN ('+ @exportsets+')'          
if @indebug = 1 print @sel          
      
exec (@sel)          
      
if @indebug = 1 Select '#exportsets' as [#exportsets], * from #exportsets      
          
SELECT TOP 1 @sampleunit_id=sampleunit_Id, @startdate=startdate, @enddate=enddate,@ExportSetTypeID = ExportSetTypeID          
FROM #exportsets          
          
WHILE @@rowcount>0          
BEGIN          
 set @Ineligible = 0
      
 if @indebug = 1       
 begin      
 print '@ExportSetTypeID = ' + cast(@ExportSetTypeID as varchar(100))      
 print '@sampleunit_id = ' + cast(@sampleunit_id as varchar(100))      
 print '@startdate = ' + cast(@startdate as varchar(100))      
 print '@enddate = ' + cast(@enddate as varchar(100))      
 end      
         
 if @ExportSetTypeID in (2,3)        
 begin        
  SET @sel='INSERT INTO #counts (n)          
    exec ' + @Server+'qp_prod.dbo.Export_HCAHPSSampleunitAvailableCount ' +           
    convert(varchar,@sampleunit_id) +',' +          
    '''' + convert(varchar,@startdate) + '''' + ',' +          
    '''' + convert(varchar,@enddate) + ''''          
           
  if @indebug = 1 print (@sel)          
  exec (@sel)          

  select distinct top 1 @study=study_id from sampleunit where sampleunit_id = @sampleunit_id
  set @sql='select @ineligible = count (*) from s'+convert(nvarchar,@study)+'.big_table_view bt where HDisposition = ''03'' and bt.DatSampleEncounterDate between '''+convert(nvarchar,@startDate)+''' AND '''+convert(nvarchar,@EndDate)+ '''' 
  exec sp_executesql @sql, N'@ineligible int output', @Ineligible output;
         
 end        
 if @exportSetTypeID = 4        
 begin        
   SET @sel='INSERT INTO #counts (n)          
    exec ' + @Server+'qp_prod.dbo.Export_HHCAHPSSampleunitAvailableCount ' +           
    convert(varchar,@sampleunit_id) +',' +          
    '''' + convert(varchar,@startdate) + '''' + ',' +          
    '''' + convert(varchar,@enddate) + ''''          
           
  if @indebug = 1 print (@sel)          
  exec (@sel)          
 end        

 insert into #unitcounts (sampleunit_id, n)          
 select @sampleunit_id, n - @Ineligible        
 from #counts          
          
 Truncate table #counts          
           
 DELETE FROM #exportsets WHERE sampleunit_id=@sampleunit_Id          
  AND startdate=@startdate          
  AND enddate=@enddate          
          
 SELECT TOP 1 @sampleunit_id=sampleunit_Id, @startdate=startdate, @enddate=enddate          
 FROM #exportsets          
END          

--with the change to using MedicareExportSets it is now possible to use the same GUID
--more than once.  Since we always want the data to be current we simply delete before the insert
if @indebug = 1 print 'Delete ExportSetCMSAvailableCount Records found for existing ExportFileGUID'
Delete from ExportSetCMSAvailableCount where exportfileguid = @exportfileguid

if @indebug = 1 print 'Insert New ExportSetCMSAvailableCount Records'          
INSERT INTO ExportSetCMSAvailableCount (exportfileGUID, sampleunit_id, availablecount)          
SELECT @exportfileguid, sampleunit_id, n          
FROM #unitCounts          
          
DROP TABLE #Counts          
DROP TABLE #exportsets

GO