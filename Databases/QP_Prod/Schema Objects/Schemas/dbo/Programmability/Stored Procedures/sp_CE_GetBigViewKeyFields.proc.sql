/****** Object:  Stored Procedure dbo.sp_CE_GetBigViewKeyFields    Script Date: 6/9/99 4:36:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_CE_GetBigViewKeyFields    Script Date: 3/12/99 4:16:07 PM ******/
CREATE PROCEDURE sp_CE_GetBigViewKeyFields 
@Study_id int
AS
DECLARE @strINList varchar(200)
DECLARE @strSQL varchar(255)
EXEC sp_CE_GetBigViewInList @Study_id, @strINList output
SELECT @strSQL = "SELECT Table_id, strTable_nm + strField_nm as KeyField
    FROM MetaData_View
                  WHERE strTable_nm IN (" +  @strINList + ") AND
   Study_id = " + CONVERT(varchar, @Study_id) + "AND
   bitKeyField_flg = 1"
EXECUTE(@strSQL)


