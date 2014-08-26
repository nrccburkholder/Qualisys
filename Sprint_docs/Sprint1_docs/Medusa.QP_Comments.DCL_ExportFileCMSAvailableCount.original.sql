USE [QP_Comments]
GO

/****** Object:  StoredProcedure [dbo].[DCL_ExportFileCMSAvailableCount]    Script Date: 6/26/2014 8:18:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
          
*/            
ALTER PROCEDURE [dbo].[DCL_ExportFileCMSAvailableCount]          
 @exportsets VARCHAR(2000),          
 @exportfileguid UNIQUEIDENTIFIER,      
 @indebug bit = 0          
AS          
          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
DECLARE @Server VARCHAR(100), @sql VARCHAR(8000)          
          
SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'          
          
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
 select @sampleunit_id, n          
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

