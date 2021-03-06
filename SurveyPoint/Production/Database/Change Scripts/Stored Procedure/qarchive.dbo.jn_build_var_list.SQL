/****** Object:  StoredProcedure [dbo].[jn_build_var_list]    Script Date: 08/11/2006 14:09:20 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_var_list]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_build_var_list]
GO
/****** Object:  StoredProcedure [dbo].[jn_build_var_list]    Script Date: 08/11/2006 14:09:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_var_list]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE jn_build_var_list
   ( @tablename varchar(255))
as
/* this will print out the following section of code:

 @[varname]
,@[var2name]
,@[var3name]
...

for all columns of the given table name.

Copyright (C) Hibbard M. Engler 2002, 2005
Version 1.1

Changes:

*/
begin


DECLARE @printline varchar(2000)


DECLARE print_cursor CURSOR FOR
SELECT 	CASE colorder WHEN 1 THEN '' '' ELSE '','' END + ''@'' + c.name + '''' AS PrintResult
FROM         sysobjects u, syscolumns c, systypes t
WHERE     u.name = @tablename AND u.type = ''U'' AND u.id = c.id AND c.xtype =
t.xtype
and t.status != 1
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
GRANT EXECUTE ON [dbo].[jn_build_var_list] TO [reporter]
GO
