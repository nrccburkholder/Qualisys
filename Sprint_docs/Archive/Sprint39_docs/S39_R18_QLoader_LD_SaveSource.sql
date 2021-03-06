/*

S39 RS18 QLoader - Increase default field size in QLoader 

As an Atlas team member, I need to analyze new way to fix Service needs on QLoader that doesn't break the 50 to 100 file text


Tim Butler

- CREATE FUNCTION [dbo].[FN_SplitDelimitedArray]  (Add function for splitting a string by delimiter and return value by index)

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

CREATE FUNCTION dbo.FN_SplitDelimitedArray(
 @TEXT      varchar(8000)
,@COLUMN    tinyint
,@SEPARATOR char(1)
)RETURNS varchar(8000)
AS
  BEGIN
       DECLARE @POS_START  int 
	   SET @POS_START = 1
       DECLARE @POS_END    int 
	   SET @POS_END = CHARINDEX(@SEPARATOR, @TEXT, @POS_START)

        WHILE (@COLUMN >1 AND  @POS_END> 0)
         BEGIN
             SET @POS_START = @POS_END + 1
             SET @POS_END = CHARINDEX(@SEPARATOR, @TEXT, @POS_START)
             SET @COLUMN = @COLUMN - 1
         END 

        IF @COLUMN > 1  SET @POS_START  = LEN(@TEXT) + 1
       IF @POS_END = 0 SET @POS_END = LEN(@TEXT) + 1 

        RETURN SUBSTRING  (@TEXT,  @POS_START, @POS_END - @POS_START)
  END
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


  DECLARE @IsDelimited bit
  DECLARE @FileType_id int
  SELECT @FileType_id = FileType_id,
		@IsDelimited = CASE LTRIM(RTRIM(dbo.FN_SplitDelimitedArray(FileTypeSettings,2,CHAR(1)))) -- the delimited indicator is in the 2nd position
				WHEN '0' THEN 0 
				WHEN '1' THEN 1
				ELSE 0 
			 END   
  FROM [QP_Load].[dbo].[Package]
  WHERE Package_id=@Package_id AND intVersion=@Version
    
 --If the source exists in the previous version, we want to maintain the source_id    
 IF @FileType_id = 1 and @IsDelimited = 0
 BEGIN
 /*If this is a text file and it is not a delimited file (that is, it's fixed width), 
 then the old length and the new length must match, otherwise it unmaps */

	 SELECT @Source_id=Source_id    
	 FROM Source_History    
	 WHERE Package_id=@Package_id    
	 AND intVersion=(@Version-1)    
	 AND strName=@strSource_nm    
	 AND strAlias=@strAlias    
	 AND DataType_id=@DataType_id    
	 AND intLength=@Length 

	
END
ELSE
BEGIN
/* If it is a delimited file or any of the other file types then if the old length is less than
or equal to the new length, it will keep mapping, otherwise it unmaps*/

	 SELECT @Source_id=Source_id    
	 FROM Source_History    
	 WHERE Package_id=@Package_id    
	 AND intVersion=(@Version-1)    
	 AND strName=@strSource_nm    
	 AND strAlias=@strAlias    
	 AND DataType_id=@DataType_id
	 AND intLength <= @Length   
END
    
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
    
COMPLETED:    
    
 GO







