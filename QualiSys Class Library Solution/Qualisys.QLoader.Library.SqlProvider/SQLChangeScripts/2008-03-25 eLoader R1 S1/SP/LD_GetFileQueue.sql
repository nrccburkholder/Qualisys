USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_GetFileQueue]    Script Date: 03/27/2008 16:40:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LD_GetFileQueue] 
@FilterByState  VARCHAR(50),
@BeginDate  DATETIME='1/1/1900',
@EndDate  DATETIME='1/1/2010'

AS
  
SELECT @BeginDate=ISNULL(@BeginDate,'1/1/1900'),@EndDate=ISNULL(@EndDate,'1/1/2010')  
    
IF DATEDIFF(DAY,@BeginDate,@EndDate)<0
BEGIN
 SELECT -1
 RETURN
END  

SELECT @EndDate=DATEADD(DAY,1,@EndDate)  

DECLARE @SQL VARCHAR(6000)  
IF @FilterByState != ''  
BEGIN  
 SET @SQL = '  
 SELECT p.strPackage_nm, df.DataFile_id, df.intVersion, df.FileType_id, df.Package_id, df.strFileLocation, CONVERT(VARCHAR,datReceived)+'' (''+df.strFile_nm+'')'' strFile_nm,   
 df.intFileSize, df.intRecords, df.datReceived, df.datBegin, df.datEnd, df.intLoaded, df.datMinDate,   
 df.datMaxDate, df.DataSet_id, dfs.State_id, dfs.StateDescription, datOccurred,   
 CASE WHEN Associate IS NULL THEN 0 ELSE 1 END Locked, df.AssocDataFiles, strOrigFile_nm FileName, strPackageFriendly_nm 
 FROM DataFile df, DataFileState dfs, Package_view p  LEFT OUTER JOIN PackageLock pl  
 ON p.Package_id=pl.Package_id     
 WHERE dfs.DataFile_id = df.DataFile_id
 AND df.Package_id = p.Package_id
 AND df.intVersion=p.intVersion    
 AND dfs.State_id IN ('+@FilterByState+')  
 AND dfs.datOccurred BETWEEN '''+CONVERT(VARCHAR(10),@BeginDate,120)+''' AND '''+CONVERT(VARCHAR(10),@EndDate,120)+'''
 ORDER BY df.DataFile_id'
 EXEC(@SQL)  
END  
ELSE  
BEGIN  
 SELECT p.strPackage_nm, df.DataFile_id, df.intVersion, df.FileType_id, df.Package_id, df.strFileLocation, CONVERT(VARCHAR,datReceived)+' ('+df.strFile_nm+')' strFile_nm,   
  df.intFileSize, df.intRecords, df.datReceived, df.datBegin, df.datEnd, df.intLoaded, df.datMinDate,   
  df.datMaxDate, df.DataSet_id, dfs.State_id, dfs.StateDescription, datOccurred,   
  CASE WHEN Associate IS NULL THEN 0 ELSE 1 END Locked, df.AssocDataFiles, strOrigFile_nm FileName, strPackageFriendly_nm 
 FROM DataFile df, DataFileState dfs, Package_view p LEFT OUTER JOIN PackageLock pl  
 ON p.Package_id=pl.Package_id
 WHERE dfs.DataFile_id = df.DataFile_id
 AND df.Package_id = p.Package_id
 AND df.intVersion = p.intVersion
 AND dfs.State_id NOT IN (10,11)
 AND dfs.datOccurred BETWEEN @BeginDate AND @EndDate
 ORDER BY df.DataFile_id
END  
  


