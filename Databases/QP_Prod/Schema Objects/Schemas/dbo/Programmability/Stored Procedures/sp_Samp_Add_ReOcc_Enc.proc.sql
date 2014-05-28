/****** Object:  Stored Procedure dbo.sp_Samp_Add_ReOcc_Enc    Script Date: 9/28/99 2:57:10 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_Add_ReOcc_Enc 
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_Add_ReOcc_Enc 
 @intStudy_id int,
 @vcPopID_EncID_Select varchar(8000),
 @vcBigView_Join varchar(8000),
 @vcReOcc_Where varchar(8000)
AS
 DECLARE @vcINSERT varchar(8000)
 DECLARE @vcSELECT varchar(8000)
 DECLARE @vcFROM varchar(8000)
 DECLARE @vcWHERE varchar(8000)
 /*Format the 'INSERT', 'SELECT', 'FROM', and 'WHERE' elements of the SQL Statement*/
 SET @vcINSERT = "INSERT INTO #UNIVERSE"
 SET @vcSELECT  = " SELECT DISTINCT " + @vcPopID_EncID_Select + ", NULL, NULL"
 SET @vcFROM = " FROM Data_Set DS, DataSetMember X, S" + CONVERT(varchar, @intStudy_id) + ".Big_View BV"
 SET @vcWHERE = " WHERE DS.DataSet_id = X.DataSet_id
      AND " + @vcBigView_Join +
    " AND " + @vcReOcc_Where +
    " AND DS.Study_id = " + CONVERT(varchar, @intStudy_id)
 EXECUTE (@vcINSERT + @vcSELECT + @vcFROM + @vcWHERE)


