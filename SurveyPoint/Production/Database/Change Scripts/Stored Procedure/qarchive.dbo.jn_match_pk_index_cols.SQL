/****** Object:  StoredProcedure [dbo].[jn_match_pk_index_cols]    Script Date: 08/11/2006 14:15:31 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_match_pk_index_cols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_match_pk_index_cols]
GO
/****** Object:  StoredProcedure [dbo].[jn_match_pk_index_cols]    Script Date: 08/11/2006 14:15:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_match_pk_index_cols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE jn_match_pk_index_cols
   ( @tablename varchar(255),@matchalias varchar(10))
as
/* this will print out the following section of code:

a.[pkcol1] = i.[pkcol]
and a.[pkcol2] =  j.[pkcol2]


for all  the primary key columns of the given table name.
Actually,  it will look for the primary key,  and if there is no primary key,  it will take the first unique key instead.

*/
begin


DECLARE @printline varchar(2000)


DECLARE print_cursor CURSOR FOR
SELECT CASE k.keyno WHEN 1 THEN ''    '' ELSE ''AND '' END + 
    CASE (cast(c.status AS int) & 8)
        WHEN 8 THEN 
               ''((a.[''+c.name+'']  is null and ''+@matchalias+''.[''+c.name+''] is null) or (a.[''+c.name+''] = ''+@matchalias+''.[''+c.name+'']))''
       ELSE '' a.['' + c.name + '']= ''+@matchalias+''.[''+c.name+'']''
        END
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

end


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_match_pk_index_cols] TO [reporter]
GO
