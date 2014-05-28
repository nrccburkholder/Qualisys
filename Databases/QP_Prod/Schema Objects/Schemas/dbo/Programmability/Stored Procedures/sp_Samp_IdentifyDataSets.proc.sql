/****** Object:  Stored Procedure dbo.sp_Samp_IdentifyDataSets    Script Date: 9/28/99 2:57:16 PM ******/  
/***********************************************************************************************************************************  
SP Name: sp_Samp_IdentifyDataSets  
Part of:  Sampling Tool  
Purpose:    
Input:    
   
Output:    
Creation Date: 09/08/1999  
Author(s): DA, RC   
Revision: First build - 09/08/1999  
 05/13/2009 DRM -Changed @DataSet parm to accept 500 char
***********************************************************************************************************************************/  
CREATE PROCEDURE sp_Samp_IdentifyDataSets   
 @strDataSet_ids varchar(500)  
AS  
 DECLARE @strTempDataSets varchar(255)  
 DECLARE @intCommaPos int  
 DECLARE @intCurrentDataSet int  
 /*Loop through the strDataSet_ids parameter and add each Data Set to the Data Set table*/  
 WHILE CHARINDEX(',', @strDataSet_ids) <> 0  
 BEGIN  
  SELECT @intCommaPos = CHARINDEX(',', @strDataSet_ids)  
  SELECT @intCurrentDataSet = LEFT(@strDataSet_ids, @intCommaPos -1)  
  INSERT INTO #DataSet VALUES (@intCurrentDataSet)  
  SELECT @strDataSet_ids = RIGHT(@strDataSet_ids, LEN(@strDataSet_ids) - @intCommaPos)   
 END  
 /*Add the last data set of the strDataSet_ids parameter to the Data Set table*/  
 INSERT INTO #DataSet VALUES (@strDataSet_ids)


