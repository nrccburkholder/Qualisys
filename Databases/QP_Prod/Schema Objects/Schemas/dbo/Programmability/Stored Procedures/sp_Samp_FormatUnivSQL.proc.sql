/****** Object:  Stored Procedure dbo.sp_Samp_FormatUnivSQL    Script Date: 9/28/99 2:57:15 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_FormatUnivSQL
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_FormatUnivSQL 
 @intStudy_id int,
 @intSSDR_Table_id int,
 @intSSDR_Field_id int,
 @vcSSDR_From_Date varchar(10),
 @vcSSDR_To_Date varchar(10),
 @vcPopID_EncID_Select varchar(8000),
 @vcBigView_Join varchar(8000),
 @vcSQL varchar (8000) OUTPUT
AS
 DECLARE @vcINSERT varchar(8000)
 DECLARE @vcSELECT varchar(8000)
 DECLARE @vcFROM varchar(8000)
 DECLARE @vcWHERE varchar (8000)
 DECLARE @vcSSDR_Table_Field_nm varchar (8000)
 DECLARE @vcSSDR_WHERE varchar (8000)
 
 /*Format the 'INSERT', 'SELECT', 'FROM', and 'WHERE' elements of the SQL Statement*/
 SET @vcINSERT = 'INSERT INTO #UNIVERSE'
 SET @vcSELECT  = ' SELECT ' + @vcPopID_EncID_Select + ', NULL, NULL'
 SET @vcFROM = ' FROM #DataSet DS, dbo.DataSetMember  X (nolock)'
 SET @vcWHERE = ' WHERE DS.DataSet_id = X.DataSet_id'
 /*Modify the 'FROM', and 'WHERE' elements of the SQL Statement if a Sample Set Date Range (SSDR) was passed in*/
 IF @intSSDR_Table_id <> -1
 BEGIN
  /*Add 'BigView' to the statement*/
  SET @vcFROM = @vcFROM + ', S' + CONVERT(varchar, @intStudy_id) + '.Big_View BV'
  /*Retrieve the Field used to evaluate the Sample Set Date Range*/
  SELECT @vcSSDR_Table_Field_nm = MT.strTable_nm + MF.strField_nm
   FROM dbo.metaStructure MS, dbo.metaTable MT, dbo.metaField MF
   WHERE MS.Table_id = MT.Table_id
    AND MS.Field_id = MF.field_id
    AND MS.Table_id = @intSSDR_Table_id
    AND MS.Field_id = @intSSDR_Field_id
  /*Format the SSDR portion of the 'WHERE' statement*/
  SET @vcSSDR_WHERE = "BV." + @vcSSDR_Table_Field_nm +
      " BETWEEN '" + @vcSSDR_From_Date + " 0:00:00'  
      AND '" + @vcSSDR_To_Date +  " 23:59:59'"
  
  /*Add the 'BigView' Join and the SSDR criteria to the 'WHERE' clause*/
  SET @vcWHERE = @vcWHERE + ' AND ' + @vcBigView_Join + ' AND ' + @vcSSDR_WHERE
 END
 SET @vcSQL = @vcINSERT + @vcSELECT + @vcFROM + @vcWHERE


