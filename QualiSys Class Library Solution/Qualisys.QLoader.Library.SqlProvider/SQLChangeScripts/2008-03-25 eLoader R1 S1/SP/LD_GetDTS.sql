USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_GetDTS]    Script Date: 03/27/2008 16:00:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LD_GetDTS]
 @Package_id  INT, @Version INT=NULL
AS          
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
DECLARE @Study_id INT, @strLoadingDest VARCHAR(200), @sql VARCHAR(8000)
          
SELECT @strLoadingDest=strParam_Value FROM Loading_Params WHERE strParam_nm='Loading Destination'  

IF ISNULL(@Version,-22)=-22
SELECT @Version=intVersion FROM Package WHERE Package_id=@Package_id

--Get a list of all clients the person has rights to.          
--This is used to get the client and study names for the package info.          
CREATE TABLE #ClientList (          
 strClient_nm   VARCHAR(42),          
 Client_id    INT,          
 strStudy_nm    VARCHAR(42),          
 Study_id    INT          
)          
          
SET @sql='INSERT INTO #ClientList          
EXEC '+@strLoadingDest+'SP_SYS_ClientList'
EXEC (@sql)
    
DECLARE @Associate VARCHAR(42), @datLocked DATETIME    
    
--Get the ClientUser_id and datLocked for the package    
SELECT @Associate=Associate, @datLocked=datLocked    
FROM PackageLock    
WHERE Package_id=@Package_id    
    
--Select the package information          
SELECT Package_id,intVersion,strPackage_nm,p.Client_id,strClient_nm,          
 p.Study_id,strStudy_nm,intTeamNumber,SignOffBy_id,FileType_id,FileTypeSettings,    
 @Associate Associate,@datLocked LockDate,strPackageFriendly_nm
FROM Package_View p, #ClientList c          
WHERE p.Package_id=@Package_id          
AND p.intVersion=@Version          
AND p.Study_id=c.Study_id          
          
SELECT TOP 1 @Study_id=Study_id           
 FROM Package
  WHERE Package_id=@Package_id          
          
CREATE TABLE #MetaTable (Table_id INT, strTable_nm VARCHAR(42))          
          
SET @sql='INSERT INTO #MetaTable          
EXEC '+@strLoadingDest+'SP_SYS_MetaTable '+LTRIM(STR(@Study_id))
EXEC (@sql)          
      
DECLARE @mfv TABLE (Table_id INT)      
      
INSERT INTO @mfv (Table_id)      
SELECT DISTINCT Table_id      
FROM MatchFieldValidation      
WHERE Study_id=@Study_id      
      
SELECT t.Table_id, strTable_nm, CASE WHEN p.Table_id IS NULL THEN 0 ELSE 1 END Included,       
 CASE WHEN mfv.Table_id IS NULL THEN 0 ELSE 1 END bitDupCheck          
 FROM #MetaTable t LEFT OUTER JOIN PackageTable_View p          
  ON p.Table_id=t.Table_id          
  AND p.Package_id=@Package_id 
  AND p.intVersion=@Version     
 LEFT OUTER JOIN @mfv mfv      
  ON p.Table_id=mfv.Table_id      
          
--Get the source fields          
SELECT s.Source_id,strName,strAlias,intLength,DataType_id,Ordinal,COUNT(DISTINCT Destination_id) MapCount          
 FROM (SELECT * FROM Source_View WHERE Package_id=@Package_id AND intVersion=@Version) s           
  LEFT OUTER JOIN           
  (SELECT * FROM DTSMapping_View WHERE Package_id=@Package_id AND intVersion=@Version) d          
  ON s.Source_id=d.Source_id          
 GROUP BY s.Source_id,strName,strAlias,intLength,DataType_id,Ordinal       
 ORDER BY Ordinal
          
--Get the Destination fields          
CREATE TABLE #MetaData (          
 Table_id 	   		INT,          
 strTable_nm   		VARCHAR(42),          
 Field_id   	 	INT,          
 strField_nm   		VARCHAR(42),          
 bitMatchField_flg  BIT,          
 DataType_id   		INT,          
 intLength   		INT,
 bitPII				BIT,
 bitAllowUS			BIT          
)          
          
SET @sql='INSERT INTO #MetaData          
EXEC '+@strLoadingDest+'SP_SYS_DestinationFields '+LTRIM(STR(@Study_id))
EXEC (@sql)
          
SELECT t.Table_id,strTable_nm,t.Field_id,strField_nm,DataType_id,intLength,bitMatchField_flg,          
 Destination_id,Formula,ISNULL(intFreqLimit,0) intFreqLimit,ISNULL(bitNULLCount,0) bitNULLCount,          
 ISNULL(bitDupCheck,0) bitDupCheck, ISNULL(Sources,'') Sources, CONVERT(BIT,0) bitSystem,
 bitPII, bitAllowUS          
INTO #Destinations
FROM #MetaData t LEFT OUTER JOIN           
 (SELECT Table_id,Field_id,Destination_id,Formula,intFreqLimit,bitNULLCount,0 bitDupCheck,Sources           
  FROM Destination_View 
   WHERE Package_id=@Package_id           
    AND intVersion=@Version) d          
ON t.Table_id=d.Table_id          
AND t.Field_id=d.Field_id
UNION        
SELECT Table_id,strTable_nm,-1,'DF_id',1,1,0,-1,'DTSDestination("DF_id") = DTSSource("DF_id")',0,0,0,'',1,0,0        
FROM #MetaTable        
UNION        
SELECT Table_id,strTable_nm,-2,'DataFile_id',1,1,0,-2,'DTSDestination("DataFile_id") = DTSSource("DataFile_id")',0,0,0,'',1,0,0        
FROM #MetaTable        
--UNION        
--SELECT Table_id,strTable_nm,-3,'NewRecordDate',1,1,0,-3,'DTSDestination("NewRecordDate") = Now',0,0,0,'',1        
--FROM #MetaTable        

UPDATE t
SET t.bitDupCheck=1
FROM #Destinations t, MatchFieldValidation mfv
WHERE t.Table_id=mfv.Table_id
AND t.Field_id=mfv.Field_id
AND t.bitMatchField_flg=0

UPDATE #Destinations
SET Formula='DTSDestination("NewRecordDate") = Now()'
WHERE Field_id=24
AND (Formula IS NULL
OR Formula='')
          
SELECT * FROM #Destinations

DROP TABLE #MetaTable        
DROP TABLE #MetaData          
DROP TABLE #ClientList
DROP TABLE #Destinations


