/****** Object:  StoredProcedure [dbo].[jn_set_tab_cols]    Script Date: 08/10/2006 17:03:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_set_tab_cols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_set_tab_cols]
GO
/****** Object:  StoredProcedure [dbo].[jn_set_tab_cols]    Script Date: 08/10/2006 17:03:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_set_tab_cols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE jn_set_tab_cols
   ( @tablename varchar(255),@matchalias varchar(10))
as
/* this will print out the following section of code:

a.[col1] = i.[col]
,a.[col2] =  i.[col2]


for all  the columns of the given table name -- except the primary key columns
Actually,  it will look for the primary key,  and if there is no primary key,  it will take the first unique key instead.

*/
begin


DECLARE @printline varchar(2000)
declare @comma varchar(3)

DECLARE print_cursor CURSOR FOR
SELECT 
   '' f.['' + c.name + '']= ''+@matchalias+''.[''+c.name+'']''
FROM         sysobjects u, syscolumns c
WHERE     u.name = @tablename AND u.type = ''U'' AND u.id = c.id
and colid not in (
/* the column id is not part of the primary key */
SELECT k.colid
FROM         sysobjects u,sysindexkeys k
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
     and i.status & 2048 = 2048
   union
   select i.indid 
   FROM         sysobjects u, sysindexes i
   where u.name = @tablename
     and u.type=''U'' 
     and i.id = u.id
     and i.indid in (select min(j.indid) from sysindexes j
   where j.id = u.id
     and j.status& 2 = 2
     )
   and not exists (
     select ''x'' from sysindexes k
     where k.id = u.id
     and k.status & 2048 = 2048
     )
   )
)
ORDER BY colorder

OPEN print_cursor
set @comma = ''  ''

FETCH NEXT FROM print_cursor INTO @printline

WHILE @@FETCH_STATUS = 0
BEGIN
print @comma + @printline
set @comma = '', ''
   	FETCH NEXT FROM print_cursor INTO @printline

END

CLOSE print_cursor
DEALLOCATE print_cursor

end


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_set_tab_cols] TO [reporter]
GO
