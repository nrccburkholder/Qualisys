USE [QP_Load]
GO
/*
   Monday, July 09, 20072:02:04 PM
   User: qpsa
   Server: Wonderwoman
   Database: QP_Load
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DataFile ADD
	IsDRGUpdate bit NOT NULL CONSTRAINT DF_DataFile_IsDRGUpdate DEFAULT 0
GO
COMMIT

GO

USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_AddDataFile]    Script Date: 07/09/2007 14:17:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LD_AddDataFile]      
 @Package_id      	INT,      
 @Version      		INT,      
 @FileType_id     	INT,      
 @strFileLocation   VARCHAR(200),      
 @strOrigFile_nm    VARCHAR(100),      
 @strFile_nm      	VARCHAR(42),      
 @intFileSize     	INT,      
 @intRecords      	INT,
 @IsDRGUpdate		BIT      
AS      
      
DECLARE @DataFile_id INT      
      
INSERT INTO DataFile (Package_id,intVersion,FileType_id,strFileLocation,strOrigFile_nm,strFile_nm,intFileSize,intRecords,datReceived,IsDRGUpdate)      
 SELECT @Package_id,@Version,@FileType_id,@strFileLocation,@strOrigFile_nm,@strFile_nm,@intFileSize,@intRecords,GETDATE(),@IsDRGUpdate      
      
SELECT @DataFile_id=SCOPE_IDENTITY()      
      
UPDATE DataFile SET strFile_nm=LTRIM(STR(@DataFile_id))+strFile_nm WHERE DataFile_id=@DataFile_id    
    
EXEC LD_BuildSourceTable @Package_id,@Version,@DataFile_id      
  
GO

USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_GetDataFile]    Script Date: 07/09/2007 14:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LD_GetDataFile]
@DataFile_id INT
AS

SELECT df.DataFile_id, df.intVersion, df.FileType_id, df.Package_id, df.strFileLocation, df.strFile_nm,
 df.intFileSize, df.intRecords, df.datReceived, df.datBegin, df.datEnd, df.intLoaded, df.datMinDate,
 df.datMaxDate, df.DataSet_id, df.IsDRGUpdate, dfs.State_id, dfs.StateDescription, p.Client_id, p.Study_id,
 AssocDataFiles, CONVERT(VARCHAR,datReceived)+' ('+df.strFile_nm+')' DisplayName, strOrigFile_nm FileName
FROM DataFile df, DataFileState dfs, Package p
WHERE df.DataFile_id=@DataFile_id
AND dfs.DataFile_id=df.DataFile_id
AND df.Package_id=p.Package_id

GO

USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_GetDataFilesByDatasetId]    Script Date: 07/09/2007 14:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LD_GetDataFilesByDatasetId]
@DataSet_id INT
AS

SELECT df.DataFile_id, df.intVersion, df.FileType_id, df.Package_id, df.strFileLocation, df.strFile_nm,
 df.intFileSize, df.intRecords, df.datReceived, df.datBegin, df.datEnd, df.intLoaded, df.datMinDate,
 df.datMaxDate, df.DataSet_id, df.IsDRGUpdate, dfs.State_id, dfs.StateDescription, p.Client_id, p.Study_id,
 AssocDataFiles, CONVERT(VARCHAR,datReceived)+' ('+df.strFile_nm+')' DisplayName, strOrigFile_nm FileName
FROM DataFile df, DataFileState dfs, Package p
WHERE df.DataSet_id=@DataSet_id
AND dfs.DataFile_id=df.DataFile_id
AND df.Package_id=p.Package_id

GO

USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_GetFileQueue]    Script Date: 07/31/2007 11:02:46 ******/
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
 CASE WHEN Associate IS NULL THEN 0 ELSE 1 END Locked, df.AssocDataFiles, strOrigFile_nm FileName  
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
  CASE WHEN Associate IS NULL THEN 0 ELSE 1 END Locked, df.AssocDataFiles, strOrigFile_nm FileName  
 FROM DataFile df, DataFileState dfs, Package_view p LEFT OUTER JOIN PackageLock pl  
 ON p.Package_id=pl.Package_id
 WHERE dfs.DataFile_id = df.DataFile_id
 AND df.Package_id = p.Package_id
 AND df.intVersion = p.intVersion
 AND dfs.State_id NOT IN (10,11)
 AND dfs.datOccurred BETWEEN @BeginDate AND @EndDate
 ORDER BY df.DataFile_id
END  
  
GO

USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG]    Script Date: 07/31/2007 13:37:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LD_UpdateDRG]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LD_UpdateDRG]

USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG]    Script Date: 07/31/2007 13:26:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LD_UpdateDRG] @Study_ID int, @DataFile_id int
AS
-- New wrapper that calls LD_UpdateDRG from Qualisys.QP_Prod. This runs
-- from QP_LOAD
SET NOCOUNT ON
EXEC QUALISYS.QP_PROD.DBO.LD_UpdateDRG   @Study_ID , @DataFile_id 
