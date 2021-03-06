/****** Object:  StoredProcedure [dbo].[jn_build_declare_datatype]    Script Date: 08/11/2006 13:12:50 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_declare_datatype]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_build_declare_datatype]
GO
/****** Object:  StoredProcedure [dbo].[jn_build_declare_datatype]    Script Date: 08/11/2006 13:12:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_declare_datatype]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE jn_build_declare_datatype
   ( @tablename varchar(255))
as
/* this will print out the following section of code:

declare @[varname] int

for all columns of the given table name.

Copyright (C) Hibbard M. Engler 2002, 2005
Version 1.3

Changes:
V1.3 - hib - made a check for status != 1 because some types are not unique - namely sysname datatype
Also made it handle nvarchar correctly
V1.2 - Hib - made the number and decimal datatype come out correctly
*/
begin


DECLARE @printline varchar(2000)


DECLARE print_cursor CURSOR FOR
SELECT 	''declare @'' + c.name + '' '' + t .name  +
	CASE t .name WHEN ''varchar'' THEN ''('' + cast(c.length AS varchar) + '')''
	WHEN ''nvarchar'' THEN ''('' + cast(c.length/2 AS varchar) + '')''
            WHEN ''char'' THEN ''('' + cast(c.length AS varchar) + '')''
	WHEN ''decimal'' THEN ''('' + cast(c.prec AS varchar) + '','' + cast(c.scale AS
varchar) + '')''
	WHEN ''number'' THEN ''('' + cast(c.prec AS varchar) + '','' + cast(c.scale AS
varchar) + '')''
	ELSE '''' END  AS PrintResult
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
GRANT EXECUTE ON [dbo].[jn_build_declare_datatype] TO [reporter]
GO
