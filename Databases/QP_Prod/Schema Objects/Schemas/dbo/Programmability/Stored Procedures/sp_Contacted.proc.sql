/****** Object:  Stored Procedure dbo.sp_Contacted    Script Date: 6/9/99 4:36:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_Contacted    Script Date: 3/12/99 4:16:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_Contacted    Script Date: 12/7/98 2:34:53 PM ******/
CREATE PROCEDURE sp_Contacted
@Study_id int
As
DECLARE @strSQL varchar(255)
SELECT @strSQL = 'SELECT PP.* FROM RM_Contact_View RC
INNER JOIN S' + CONVERT(varchar(10),@Study_id) + '.Population PP
ON RC.Pop_id = PP.Pop_id
WHERE RC.Study_id = ' + CONVERT(varchar(10),@Study_id)
EXECUTE (@strSQL)


