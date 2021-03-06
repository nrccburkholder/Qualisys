/****** Object:  StoredProcedure [dbo].[jn_build_column_list]    Script Date: 08/11/2006 13:12:43 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_column_list]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_build_column_list]
GO
/****** Object:  StoredProcedure [dbo].[jn_build_column_list]    Script Date: 08/11/2006 13:12:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_column_list]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE jn_build_column_list 
   ( @tablename varchar(255),@prefix varchar(100))
as
/* this will print out the following section of code:

prefix.[col1] 
,prefix.[col2]

for all columns of the given table name.

Copyright (C) Hibbard M. Engler 2002

*/
begin


DECLARE @printline varchar(2000)


DECLARE print_cursor CURSOR FOR
SELECT 	CASE colorder WHEN 1 THEN '' '' ELSE '','' END +
	@prefix + ''['' + c.name + '']''   AS PrintResult
FROM         sysobjects u, syscolumns c
WHERE     u.name = @tablename AND u.type = ''U'' AND u.id = c.id
ORDER BY colorder

OPEN print_cursor

FETCH NEXT FROM print_cursor INTO @printline

WHILE @@FETCH_STATUS = 0
BEGIN
print @printline
   	FETCH NEXT FROM print_cursor INTO @printline
END

CLOSE print_cursor
DEALLOCATE print_cursor

end


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_build_column_list] TO [reporter]
GO
