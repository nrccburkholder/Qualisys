ALTER PROCEDURE LD_SavePackage     
 @Package_id    INT,    
 @strPackage_nm   VARCHAR(42),    
 @Client_id    INT,    
 @Study_id    INT,    
 @intTeamNumber   INT,    
 @strLogin_nm   VARCHAR(42),    
 @FileType_id   INT,    
 @FileTypeSettings  VARCHAR(500),    
 @SignOffBy_id   INT,
 @strPackageFriendly_nm varchar(100) = '',
 @bitActive		BIT = 1
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DECLARE @strPackageFriendly_nm_Adjusted varchar(100)
    
IF @Package_id=0    
BEGIN    
    
 --If the study already has a package with the supplied name, return -2    
 IF EXISTS (    
   SELECT *     
   FROM Package     
   WHERE Client_id=@Client_id     
   AND Study_id=@Study_id     
   AND strPackage_nm=@strPackage_nm    
   )    
 BEGIN    
  SELECT -2    
  RETURN    
 END    
    
 --Added By Arman   
  SET @strPackageFriendly_nm_Adjusted = @strPackageFriendly_nm   
 --End Added By Arman  
 IF (@strPackageFriendly_nm = '') 
  SET @strPackageFriendly_nm_Adjusted = @strPackage_nm

 INSERT INTO Package (intVersion,strPackage_nm,Client_id,Study_id,bitArchive,    
  intTeamNumber,strLogin_nm,FileType_id,FileTypeSettings,SignOffBy_id,datCreated,  
  datLastModified, strPackageFriendly_nm, bitActive)    
 SELECT 0,@strPackage_nm,@Client_id,@Study_id,0,@intTeamNumber,    
  @strLogin_nm,@FileType_id,@FileTypeSettings,@SignOffBy_id,GETDATE(),  
  GETDATE(), @strPackageFriendly_nm_Adjusted, @bitActive
     
 SELECT @Package_id=SCOPE_IDENTITY()    
    
 GOTO Completed    
    
END    
    
--If the study already has another package with the supplied name, return -2    
IF EXISTS (    
  SELECT *     
  FROM Package     
  WHERE Client_id=@Client_id     
  AND Study_id=@Study_id     
  AND strPackage_nm=@strPackage_nm    
  AND Package_id<>@Package_id    
  )    
BEGIN    
 SELECT -2    
 RETURN    
END    
    
BEGIN TRAN    
    
UPDATE Package    
SET strPackage_nm=@strPackage_nm,intTeamNumber=@intTeamNumber,    
 FileType_id=@FileType_id,FileTypeSettings=@FileTypeSettings,    
 SignOffBy_id=@SignOffBy_id, datLastModified=GETDATE(), 
 strPackageFriendly_nm = @strPackageFriendly_nm,
 bitActive = @bitActive
WHERE Package_id=@Package_id    
AND Study_id=@Study_id    
AND Client_id=@Client_id    
    
IF @@ROWCOUNT<>1    
BEGIN     
 ROLLBACK TRAN    
 SELECT -1    
 RETURN    
END    
    
COMMIT TRAN    
    
Completed:    
SELECT @Package_id    
  
  