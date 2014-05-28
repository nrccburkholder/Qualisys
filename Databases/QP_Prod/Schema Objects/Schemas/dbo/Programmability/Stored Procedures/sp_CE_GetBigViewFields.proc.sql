﻿/****** Object:  Stored Procedure dbo.sp_CE_GetBigViewFields    Script Date: 6/9/99 4:36:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_CE_GetBigViewFields    Script Date: 3/12/99 4:16:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_CE_GetBigViewFields    Script Date: 12/7/98 2:34:53 PM ******/
CREATE PROCEDURE sp_CE_GetBigViewFields 
 @Study_id int
AS
DECLARE @strStudy varchar(10)
DECLARE @strTable_nm varchar(40)
DECLARE @objid int   /* the id of the object we want */
DECLARE @objname varchar(20)
DECLARE @strINList varchar(2000)
DECLARE @strSQL varchar(8000)
DECLARE @dbname varchar(30)
SELECT @strStudy = 'S' + CONVERT(varchar, @Study_id)
select @objname = @strStudy + '.Big_View'
select @objid = object_id(@objname),
 @dbname=db_name()
DECLARE sp_depends_Cursor CURSOR for
  select  distinct substring((o1.name), 1, 40)
                from  sysobjects  o1
   ,master.dbo.spt_values v2
   ,sysdepends  d3
   ,master.dbo.spt_values u4
   ,master.dbo.spt_values w5 --11667
   ,sysusers  s6
  where  o1.id = d3.depid
  and  o1.sysstat & 0xf = v2.number and v2.type = 'O'
  and  u4.type = 'B' and u4.number = d3.resultobj
  and  w5.type = 'B' and w5.number = d3.readobj|d3.selall
  and  d3.id = @objid
  and  o1.uid = s6.uid
  and  substring(v2.name, 1, 16) = 'user table'
OPEN sp_depends_Cursor 
FETCH NEXT FROM sp_depends_Cursor INTO @strTable_nm
SELECT @strINList = "'" + @strTable_nm + "'"
FETCH NEXT FROM sp_depends_Cursor INTO @strTable_nm
WHILE (@@FETCH_STATUS = 0)
BEGIN
 SELECT @strINList = @strINList + ", '" + @strTable_nm +"'"
 FETCH NEXT FROM sp_depends_Cursor INTO @strTable_nm
END
CLOSE sp_depends_cursor
DEALLOCATE sp_depends_cursor
SELECT @strSQL = 'SELECT Table_id, Field_id, strTable_nm, strField_nm, strFieldDataType
    FROM MetaData_View
                  WHERE strTable_nm IN (' +  @strINList + ') AND
   Study_id = ' + CONVERT(varchar, @Study_id)
EXECUTE(@strSQL)


