ALTER PROCEDURE LD_DeletePackage  
 @strLogin_nm  VARCHAR(42),  
 @Package_id  INT  
AS  
  
BEGIN TRAN  
  
INSERT INTO Package_History (Package_id,intVersion,strPackage_nm,Client_id,Study_id,  
  intTeamNumber,strLogin_nm,datLastModified,bitArchive,datArchive,FileType_id,  
  FileTypeSettings,SignOffBy_id, strPackageFriendly_nm, bitActive)  
SELECT Package_id,intVersion,strPackage_nm,Client_id,Study_id,intTeamNumber,strLogin_nm,  
 datLastModified,bitArchive,datArchive,FileType_id,FileTypeSettings,SignOffBy_id, strPackageFriendly_nm, bitActive
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
  
--Now to clear the package from the live tables  
DELETE DestinationFunctions WHERE Package_id=@Package_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -2  
 ROLLBACK TRAN  
 RETURN  
END  
  
DELETE DTSMapping WHERE Package_id=@Package_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -2  
 ROLLBACK TRAN  
 RETURN  
END  
  
DELETE Destination WHERE Package_id=@Package_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -2  
 ROLLBACK TRAN  
 RETURN  
END  
  
DELETE Source WHERE Package_id=@Package_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -2  
 ROLLBACK TRAN  
 RETURN  
END  
  
DELETE PackageTable WHERE Package_id=@Package_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -2  
 ROLLBACK TRAN  
 RETURN  
END  
  
DELETE Package WHERE Package_id=@Package_id  
IF @@ERROR<>0  
BEGIN  
 SELECT -2  
 ROLLBACK TRAN  
 RETURN  
END  
  
COMMIT TRAN  
SELECT 1  
  
  