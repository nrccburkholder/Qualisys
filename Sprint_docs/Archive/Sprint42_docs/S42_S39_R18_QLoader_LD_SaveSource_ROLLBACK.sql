/*

S39 RS18 QLoader - Increase default field size in QLoader 

As an Atlas team member, I need to analyze new way to fix Service needs on QLoader that doesn't break the 50 to 100 file text


Tim Butler

ROLLBACK

- DROP FUNCTION [dbo].[FN_SplitDelimitedArray] 

- ALTER PROCEDURE [dbo].[LD_SaveSource]

*/

USE [QP_LOAD]

GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  [name] = 'FN_SplitDelimitedArray'
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' )
				  )
		DROP FUNCTION [dbo].[FN_SplitDelimitedArray]

GO


USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_SaveSource]    Script Date: 12/16/2015 12:53:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LD_SaveSource]
 @Package_id  INT,     
 @Version   INT,     
 @Source_id   INT,    
 @strSource_nm  VARCHAR(42),     
 @strAlias   VARCHAR(42),     
 @DataType_id  INT,     
 @Length   INT,     
 @Ordinal   INT    
AS    
  
--At this point in time, we will not allow a source field to be updated.  
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
--Make sure the package and version exist    
IF (SELECT COUNT(*) FROM Package WHERE Package_id=@Package_id AND intVersion=@Version)=0    
BEGIN    
     
 SELECT -3    
 GOTO COMPLETED    
     
END    
    
IF @Source_id=0    
BEGIN    
    
 IF EXISTS (SELECT *     
    FROM Source     
      WHERE Package_id=@Package_id     
     AND intVersion=@Version     
     AND strName=@strSource_nm)    
  BEGIN    
   SELECT -2    
   RETURN    
  END    
    
 IF EXISTS (SELECT *     
    FROM Source     
      WHERE Package_id=@Package_id     
     AND intVersion=@Version     
     AND strAlias=ISNULL(@strAlias,''))    
  BEGIN    
   SELECT -2    
   RETURN    
  END    
    
 --If the source exists in the previous version, we want to maintain the source_id    
 SELECT @Source_id=Source_id    
 FROM Source_History    
 WHERE Package_id=@Package_id    
 AND intVersion=(@Version-1)    
 AND strName=@strSource_nm    
 AND strAlias=@strAlias    
 AND DataType_id=@DataType_id    
 AND intLength=@Length    
    
 IF @Source_id=0   
  INSERT INTO Source (Package_id,intVersion,strName,strAlias,DataType_id,intLength,Ordinal)    
   SELECT @Package_id,@Version,@strSource_nm,@strAlias,@DataType_id,@Length,@Ordinal    
 ELSE    
 BEGIN    
  SET IDENTITY_INSERT Source ON    
  INSERT INTO Source (Source_id,Package_id,intVersion,strName,strAlias,DataType_id,intLength,Ordinal)    
   SELECT @Source_id,@Package_id,@Version,@strSource_nm,@strAlias,@DataType_id,@Length,@Ordinal    
  SET IDENTITY_INSERT Source OFF    
 END    
    
 SELECT SCOPE_IDENTITY()    
 GOTO COMPLETED    
    
END    
ELSE    
BEGIN  
 SELECT -2  
 RETURN  
END  
/*  
BEGIN    
    
 IF EXISTS (SELECT *     
    FROM Source     
      WHERE Package_id=@Package_id     
     AND intVersion=@Version     
     AND strName=@strSource_nm    
     AND Source_id<>@Source_id)    
  BEGIN    
   SELECT -2    
   RETURN    
  END    
     
 UPDATE Source    
   SET strName=@strSource_nm,DataType_id=@DataType_id,intLength=@Length,Ordinal=@Ordinal    
  WHERE Package_id=@Package_id    
    AND intVersion=@Version    
    AND Source_id=@Source_id    
    
 --Since the name and/or datatype have changed, clear out any mappings    
 UPDATE d    
 SET d.Formula=NULL    
 FROM Destination d, DTSMapping m    
 WHERE m.Package_id=@Package_id    
 AND m.intVersion=@Version    
 AND m.Source_id=@Source_id    
 AND m.Destination_id=d.Destination_id    
    
 DELETE DTSMapping    
 WHERE Package_id=@Package_id    
 AND intVersion=@Version    
 AND Source_id=@Source_id    
    
 SELECT @Source_id    
    
END    
*/    
COMPLETED:    
    
  







