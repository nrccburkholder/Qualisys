/****** Object:  StoredProcedure [dbo].[jn_create_indexes]    Script Date: 08/11/2006 14:10:48 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_create_indexes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_create_indexes]
GO
/****** Object:  StoredProcedure [dbo].[jn_create_indexes]    Script Date: 08/11/2006 14:10:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_create_indexes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure jn_create_indexes(@tablename varchar(255),@postfix varchar(255))
as

begin
declare  listofindexes cursor for
select min(i.name),u.name + @postfix + ''_pi'' + convert(varchar(10),min(i.indid))
   from sysobjects u, sysindexes i
   where u.name = @tablename
     and u.type=''U'' 
     and i.id = u.id
   and dbo.jn_index_colunique(u.id,i.indid) not in (
	    select dbo.jn_index_colunique(u.id,i.indid)
	   FROM         sysobjects u, sysindexes i
	   where u.name = @tablename
	     and u.type=''U'' 
	     and i.id = u.id
	     and i.status & 2048 = 2048
	   union
	   select dbo.jn_index_colunique(u.id,i.indid) 
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
	and dbo.jn_index_colunique(u.id,i.indid) != ''''
        group by u.name,dbo.jn_index_colunique(u.id,i.indid)
ORDER BY min(indid)


declare @iname varchar(255)
declare @inewname varchar(255)
declare @newtablename varchar(255)


set @newtablename = @tablename + @postfix

open listofindexes

fetch listofindexes into @iname,@inewname
while @@fetch_status = 0
  begin
	exec jn_create_index @tablename,@iname,@newtablename, @inewname,0

	fetch listofindexes into @iname,@inewname
	end
close listofindexes
deallocate listofindexes
end

' 
END
GO
GRANT EXECUTE ON [dbo].[jn_create_indexes] TO [reporter]
GO
