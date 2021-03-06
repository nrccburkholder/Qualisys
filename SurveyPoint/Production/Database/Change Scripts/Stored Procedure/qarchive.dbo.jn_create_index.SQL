/****** Object:  StoredProcedure [dbo].[jn_create_index]    Script Date: 08/11/2006 14:10:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_create_index]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_create_index]
GO
/****** Object:  StoredProcedure [dbo].[jn_create_index]    Script Date: 08/11/2006 14:10:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_create_index]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE jn_create_index
   ( @tablename varchar(255),
@indexname varchar(255),
@newtablename varchar(255),
@newindexname varchar(255),
@douniqueflag int
)
as
/* this will print out the following section of code:
create index <newindexname>
on <newtablename> (
indcol1
,indcol2
)

Copyright (C) Hibbard M. Engler 2005

*/
begin


DECLARE @printline varchar(2000)


print ''create index '' + @newindexname + '' on '' + @newtablename + ''(
''


DECLARE print_cursor CURSOR FOR
SELECT CASE k.keyno WHEN 1 THEN '''' ELSE '','' END + ''['' + c.name
+ '']''
FROM         sysobjects u,sysindexkeys k, syscolumns c
where     u.name = @tablename
 and      u.type=''U''
 and      k.id = u.id 
 and      k.colid=c.colid and k.id=c.id 
 and       k.indid in (
   select i.indid 
   FROM         sysobjects u, sysindexes i
   where u.name = @tablename
     and u.type=''U'' 
     and i.id = u.id
     and i.name = @indexname
     )
ORDER BY k.keyno

OPEN print_cursor

FETCH NEXT FROM print_cursor INTO @printline

WHILE @@FETCH_STATUS = 0
BEGIN
print @printline
   	FETCH NEXT FROM print_cursor INTO @printline
END

CLOSE print_cursor
DEALLOCATE print_cursor



print '')''

end


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_create_index] TO [reporter]
GO
