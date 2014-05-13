ALTER PROCEDURE LD_IncrementVersion    
 @Package_id  INT,    
 @NewSource  BIT,    
 @FileType_id INT    
AS    
    
DECLARE @Version INT    
    
IF @NewSource=0 AND (SELECT bitArchive FROM Package WHERE Package_id=@Package_id) IS NULL    
BEGIN    
 SELECT -1    
 RETURN    
END    
    
BEGIN TRAN    
    
INSERT INTO Package_History (Package_id,intVersion,strPackage_nm,Client_id,Study_id,    
  intTeamNumber,strLogin_nm,datLastModified,bitArchive,datArchive,FileType_id,    
  FileTypeSettings,SignOffBy_id,datCreated, strPackageFriendly_nm, bitActive)    
SELECT Package_id,intVersion,strPackage_nm,Client_id,Study_id,intTeamNumber,strLogin_nm,    
 datLastModified,bitArchive,datArchive,FileType_id,FileTypeSettings,SignOffBy_id,  
 datCreated, strPackageFriendly_nm, bitActive
FROM Package    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
IF @NewSource=1    
UPDATE Package    
SET intVersion=intVersion+1, bitArchive=0,datArchive=NULL,FileType_id=@FileType_id    
WHERE Package_id=@Package_id    
ELSE    
UPDATE Package    
SET intVersion=intVersion+1, bitArchive=0,datArchive=NULL    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
SELECT @Version=intVersion    
FROM Package    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
INSERT INTO PackageTable_History (Table_id,intVersion,Package_id)    
SELECT Table_id,intVersion,Package_id    
FROM PackageTable    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
UPDATE PackageTable    
SET intVersion=intVersion+1    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
INSERT INTO Source_History (Source_id,Package_id,intVersion,strName,strAlias,intLength,DataType_id,Ordinal)    
SELECT Source_id,Package_id,intVersion,strName,strAlias,intLength,DataType_id,Ordinal    
FROM Source    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
IF @NewSource=1    
DELETE Source    
WHERE Package_id=@Package_id    
ELSE    
UPDATE Source    
SET intVersion=intVersion+1    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
INSERT INTO Destination_History (Destination_id,Package_id,intVersion,Table_id,Field_id,Formula,    
 bitNULLCount,intFreqLimit,Sources)    
SELECT Destination_id,Package_id,intVersion,Table_id,Field_id,Formula,bitNULLCount,    
 intFreqLimit,Sources    
FROM Destination    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
UPDATE Destination    
SET intVersion=intVersion+1    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
INSERT INTO DTSMapping_History (intVersion,Source_id,Destination_id,Package_id)    
SELECT intVersion,Source_id,Destination_id,Package_id    
FROM DTSMapping    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
UPDATE DTSMapping    
SET intVersion=intVersion+1    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
INSERT INTO DestinationFunctions_History (Package_id,intVersion,Function_id)    
SELECT Package_id,intVersion,Function_id    
FROM DestinationFunctions    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
/*    
IF @NewSource=1    
DELETE DestinationFunctions    
WHERE Package_id=@Package_id    
ELSE    
*/    
UPDATE DestinationFunctions    
SET intVersion=intVersion+1    
WHERE Package_id=@Package_id    
    
IF @@ERROR<>0    
BEGIN    
 SELECT -2    
 ROLLBACK TRAN    
 RETURN    
END    
    
COMMIT TRAN    
SELECT @Version    
  
  