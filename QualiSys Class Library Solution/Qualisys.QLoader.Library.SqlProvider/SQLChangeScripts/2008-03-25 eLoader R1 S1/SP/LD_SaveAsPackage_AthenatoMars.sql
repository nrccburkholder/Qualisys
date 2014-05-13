ALTER PROCEDURE LD_SaveAsPackage_AthenatoMars  
 @OrigPackage_id  INT,  
 @strPackage_nm  VARCHAR(42),  
 @Client_id   INT,  
 @Study_id   INT,  
 @intTeamNumber  INT,  
 @strLogin_nm  VARCHAR(42),  
 @FileType_id  INT,  
 @FileTypeSettings VARCHAR(500),  
 @SignOffBy_id  INT,
 @strPackageFriendly_nm varchar(100) = ''
AS  
  
DECLARE @Package_id INT, @Version INT, @Source_id INT, @sql VARCHAR(8000), @strLoadingDest VARCHAR(200), @strNewLoadingDest VARCHAR(200), @OrigStudy_id INT  
DECLARE @Destination_id INT  
  
SELECT @Package_id=0  
  
SELECT @OrigStudy_id=Study_id FROM Package WHERE Package_id=@OrigPackage_id  
  
SELECT @strLoadingDest=strParam_Value FROM Loading_Params WHERE strParam_nm='Loading Destination'    
SELECT @strNewLoadingDest=strParam_Value FROM QP_Load.dbo.Loading_Params WHERE strParam_nm='Loading Destination'    
  
--Determine what tables the studies have in common  
--First get the tables for the new study  
CREATE TABLE #NewMetaTable (Table_id INT, strTable_nm VARCHAR(42))            
            
SET @sql='INSERT INTO #NewMetaTable            
EXEC '+@strNewLoadingDest+'SP_SYS_MetaTable '+LTRIM(STR(@Study_id))  
EXEC (@sql)            
  
CREATE TABLE #OrigMetaTable (Table_id INT, strTable_nm VARCHAR(42))            
            
SET @sql='INSERT INTO #OrigMetaTable            
EXEC '+@strLoadingDest+'SP_SYS_MetaTable '+LTRIM(STR(@OrigStudy_id))  
EXEC (@sql)            
  
SELECT n.Table_id NewTable_id, n.strTable_nm+'_Load' strTable_nm, o.Table_id OrigTable_id  
INTO #TableCrossWalk  
FROM #NewMetaTable n, #OrigMetaTable o  
WHERE n.strTable_nm=o.strTable_nm  
  
BEGIN TRAN  
  
--The #ProcStatus table will save the output from the procedures  
CREATE TABLE #ProcStatus (Status INT)  
--Need to save the crosswalk for when I save the destinations  
CREATE TABLE #SourceCrossWalk (OrigSource_id INT, NewSource_id INT)  
  
INSERT INTO #ProcStatus  
EXEC QP_Load.dbo.LD_SavePackage @Package_id,@strPackage_nm,@Client_id,@Study_id,@intTeamNumber,@strLogin_nm,@FileType_id,@FileTypeSettings,@SignOffBy_id, @strPackageFriendly_nm
  
--If Status<0 the procedure didn't add a package.  
IF (SELECT TOP 1 Status FROM #ProcStatus)<0  
BEGIN  
 SELECT -1  
 ROLLBACK TRAN  
 RETURN  
END  
  
SELECT TOP 1 @Package_id=Status FROM #ProcStatus  
IF @@ERROR<>0  
BEGIN  
 SELECT -1  
 ROLLBACK TRAN  
 RETURN  
END  
  
UPDATE QP_Load.dbo.Package SET intVersion=1 WHERE Package_id=@Package_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -1  
 ROLLBACK TRAN  
 RETURN  
END  
  
SELECT @Version=intVersion FROM QP_Load.dbo.Package WHERE Package_id=@OrigPackage_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -1  
 ROLLBACK TRAN  
 RETURN  
END  
  
TRUNCATE TABLE #ProcStatus  
IF @@ERROR<>0  
BEGIN  
 SELECT -1  
 ROLLBACK TRAN  
 RETURN  
END  
  
DELETE t  
FROM #TableCrossWalk t LEFT OUTER JOIN PackageTable pt  
ON pt.Table_id=t.OrigTable_id  
AND pt.Package_id=@OrigPackage_id  
AND pt.intVersion=@Version  
WHERE pt.Table_id IS NULL  
  
--Now to populate packagetable  
INSERT INTO QP_Load.dbo.PackageTable  
SELECT NewTable_id, 1, @Package_id  
FROM #TableCrossWalk   
  
--Now to save the sources to the new package  
SELECT Source_id,@Package_id Package_id,1 intVersion,strName,strAlias,intLength,DataType_id,Ordinal  
INTO #Sources   
FROM Source   
WHERE Package_id=@OrigPackage_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -1  
 ROLLBACK TRAN  
 RETURN  
END  
  
--Loop thru to add each source individually  
SELECT TOP 1 @Source_id=Source_id FROM #Sources ORDER BY Source_id  
WHILE @@ROWCOUNT>0  
BEGIN  
   
 SELECT @sql='EXEC QP_Load.dbo.LD_SaveSource '+  
   CONVERT(VARCHAR,Package_id)+','+  
   CONVERT(VARCHAR,intVersion)+',  
   0,'''+  
   strName+''','''+  
   strAlias+''','+  
   CONVERT(VARCHAR,DataType_id)+','+  
   CONVERT(VARCHAR,intLength)+','+  
   CONVERT(VARCHAR,Ordinal)  
 FROM #Sources  
 WHERE Source_id=@Source_id  
   
 INSERT INTO #ProcStatus  
 EXEC (@sql)  
   
 IF (SELECT STATUS FROM #ProcStatus)<0  
 BEGIN  
  SELECT -1  
  ROLLBACK TRAN  
  RETURN  
 END  
  
 --Populate the crosswalk  
 INSERT INTO #SourceCrossWalk (OrigSource_id,NewSource_id)  
 SELECT @Source_id,Status  
 FROM #ProcStatus  
   
 TRUNCATE TABLE #ProcStatus  
   
 DELETE #Sources WHERE Source_id=@Source_id  
   
 SELECT TOP 1 @Source_id=Source_id FROM #Sources ORDER BY Source_id  
  
END  
  
--Loop to add each destination  
--First get the destination fields for the new study  
--Get the Destination fields            
CREATE TABLE #MetaData (            
 Table_id       INT,            
 strTable_nm     VARCHAR(42),            
 Field_id      INT,            
 strField_nm     VARCHAR(42),            
 bitMatchField_flg  BIT,            
 DataType_id     INT,            
 intLength     INT,  
 bitPII    BIT,  
 bitAllowUS   BIT  
)            
            
SET @sql='INSERT INTO #MetaData            
EXEC '+@strNewLoadingDest+'SP_SYS_DestinationFields '+LTRIM(STR(@Study_id))  
EXEC (@sql)  
  
SELECT t.Table_id, t.Field_id, d.Table_id OrigTable_id, d.Field_id OrigField_id, d.Destination_id, Formula, bitNULLCount, intFreqLimit  
INTO #Dest  
FROM #MetaData t, Destination d, #TableCrossWalk tcw  
WHERE d.Package_id=@OrigPackage_id  
AND d.Table_id=tcw.OrigTable_id  
AND tcw.NewTable_id=t.Table_id  
AND t.Field_id=d.Field_id  
  
SELECT TOP 1 @Destination_id=Destination_id FROM #Dest  
WHILE @@ROWCOUNT>0  
BEGIN  
  
SELECT @sql=''  
  
SELECT @sql=@sql+CONVERT(VARCHAR,NewSource_id)+','  
FROM #SourceCrossWalk s, DTSMapping d  
WHERE d.Destination_id=@Destination_id  
AND d.Source_id=s.OrigSource_id  
  
IF LEN(@sql)>0  
SELECT @sql=SUBSTRING(@sql,1,(LEN(@sql)-1))  
  
SELECT @sql='EXEC QP_Load.dbo.LD_SaveDestination '+LTRIM(STR(@Package_id))+',1,'+LTRIM(STR(Table_id))+','+LTRIM(STR(Field_id))+','''+Formula+''','''+@sql+''','+LTRIM(STR(bitNULLCount))+','+LTRIM(STR(intFreqLimit))  
FROM #Dest   
WHERE Destination_id=@Destination_id  
EXEC (@sql)  
  
DELETE #Dest WHERE Destination_id=@Destination_id  
  
SELECT TOP 1 @Destination_id=Destination_id FROM #Dest  
  
END  
  
COMMIT TRAN  
  
SELECT @Package_id  
  
DROP TABLE #Dest  
DROP TABLE #MetaData  
DROP TABLE #ProcStatus  
DROP TABLE #NewMetaTable  
DROP TABLE #OrigMetaTable  
DROP TABLE #TableCrossWalk  
DROP TABLE #SourceCrossWalk  
