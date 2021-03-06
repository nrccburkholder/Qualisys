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
  


