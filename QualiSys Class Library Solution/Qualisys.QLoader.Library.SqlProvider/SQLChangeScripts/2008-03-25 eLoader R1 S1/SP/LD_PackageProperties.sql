ALTER PROCEDURE LD_PackageProperties  
 @strLogin_nm VARCHAR(50),  
 @Package_id  INT,  
 @Version  INT=-1  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
    
DECLARE @sql VARCHAR(8000), @strLoadingDest VARCHAR(200)    
  
IF @Version=-1  
SELECT @Version=intVersion FROM Package WHERE Package_id=@Package_id  
    
SELECT @strLoadingDest=strParam_Value FROM Loading_Params WHERE strParam_nm='Loading Destination'      
  
SELECT @strLogin_nm=SUBSTRING(@strLogin_nm,PATINDEX('%\%',@strLogin_nm)+1,8000)  
      
CREATE TABLE #ClientList (      
 strClient_nm   VARCHAR(42),      
 Client_id   INT,      
 strStudy_nm   VARCHAR(42),      
 Study_id   INT      
)      
      
SET @sql='INSERT INTO #ClientList      
EXEC '+@strLoadingDest+'SP_SYS_ClientList '''+@strLogin_nm+''''    
EXEC (@sql)    
  
CREATE TABLE #TeamName (Team_id INT, TeamName VARCHAR(42))  
  
INSERT INTO #TeamName  
EXEC LD_Teams  
  
SELECT cl.strClient_nm ClientName, cl.Client_id, cl.strStudy_nm StudyName, cl.Study_id, p.strPackage_nm PackageName,
 p.strPackageFriendly_nm [FriendlyName],  
 p.Package_id, tn.TeamName, p.strLogin_nm CreatedBy, p.datLastModified LastModified,   
-- ft.strFileType_dsc FileTypeName,  
 ft.strFileType_dsc+CASE ft.FileType_id WHEN 1 THEN ' - '+dbo.LDFN_Delimeter(FileTypeSettings) ELSE '' END FileTypeName,  
 sob.strSignOffBy_nm FinalApproval, datCreated Created  
FROM Package_View p, SignOffBy sob, FileType ft, #TeamName tn, #ClientList cl  
WHERE P.Package_id=@Package_id  
AND p.intVersion=@Version  
AND p.Study_id=cl.Study_id  
AND p.SignOffBy_id=sob.SignOffBy_id  
AND p.FileType_id=ft.FileType_id  
AND p.intTeamNumber=tn.team_id  
  
DROP TABLE #ClientList  
DROP TABLE #TeamName  
  
  