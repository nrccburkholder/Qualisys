/****** Object:  StoredProcedure [dbo].[jn_build_transfer]    Script Date: 08/11/2006 13:29:20 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_transfer]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_build_transfer]
GO
/****** Object:  StoredProcedure [dbo].[jn_build_transfer]    Script Date: 08/11/2006 13:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_build_transfer]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE jn_build_transfer
   ( @tablename varchar(255),
     @source varchar(255), /* blank if the source is here (usually either the source or the destination but not both will be blank )*/
     @dest varchar(255), /* blank if the destination is here */
     @procname varchar(255) /* if blank or null,  we set it to the tablename prepended with _pn */
)
/* This code builds the transfer of journal information from one system to another
Copyright (C) Hibbard M. Engler 2005
It uses dsome of the journal table creation routines
*/
as
begin

/* set up the proc name */
if isnull(@procname,'''') = ''''
begin
  set @procname = @tablename + ''_pn''
end

set @source = isnull(@source,'''')
set @dest = isnull(@dest,'''')

DECLARE @printline varchar(2000)
declare @sourcetable varchar(200)
declare @desttable varchar(200)

declare @sourcesubselect varchar(300)
declare @sourcesubselecta varchar(300)

if (@source = '''')
  begin
  set @sourcetable = @tablename
  end
else
  begin
  set @sourcetable = @source + ''.'' + @tablename
  end


if (@dest = '''')
  begin
  set @desttable = @tablename
  end
else
  begin
  set @desttable = @dest + ''.'' + @tablename
  end





/* create journal synchronization */

/* drop existing code */
print ''if exists (select * from dbo.sysobjects where id = object_id(N''''[dbo].[''+@procname+'']'''') and xtype in (N''''P''''))
drop procedure [dbo].['' + @procname+'']
go''

print ''
CREATE procedure '' + @procname + ''(@mode int) /* 0 - full, 1 - incremental , 2 - delete from old system
Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.


Table:       '' + @tablename + ''
Source:      '' + @source + ''
Destination: '' + @dest + ''
 */
as
begin

set nocount off
print ''''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''''
print ''''           '' + @tablename + ''''''
''

/* see if there is a journal table -- is so use that for bringing things over.  Otherwise dont!*/

if exists (select ''x'' from sysobjects u
   where  u.name = @tablename+ ''_JN'' AND u.type = ''U'')
begin
	/* temp table */
	print ''

declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
''
/* create the column datatype list for the table */
 EXEC jn_build_declare_datatype @tablename  


	
	print ''
	declare @jn_mindate datetime
	declare @jn_maxdate datetime
	declare @jn_loop_count int
	
	
	if (@mode != 2)
	  begin
	  set nocount on
		if (@mode = 1) 
		  begin
		  /* This mindate will not look at the production server
		  The other mindate will */
		  select @jn_mindate = isnull(max(jn_datetime),''''10-jun-1970'''')
		  from '' + @desttable + ''_jn
		  if @jn_mindate > dateadd(day,-3,getdate())
			begin
			set @jn_mindate = dateadd(day,-3,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''''10-jun-2500'''')
		  from '' + @sourcetable + ''_jn
		  end
		
		print ''''mindate is '''' + convert(varchar(20),@jn_mindate)
	''	
		
	


print ''declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,''

	exec jn_build_column_list @tablename,''''
	
/* if there is a performance extract view,  use the view.  Otherwise use the base
table and order by */

if exists (select ''x'' from sysobjects where name= @tablename + ''_jl''
	and xtype=''V'')
begin
	print ''from '' + @sourcetable + ''_jl where jn_datetime >= @jn_mindate''
end
else
begin
	print ''from '' + @sourcetable + ''_jn where jn_datetime >= @jn_mindate
order by jn_datetime''
end


print ''open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,''

exec jn_build_var_list @tablename

print ''while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print '''''' + @tablename + ''_jn '''' + convert(varchar(10),@jn_loop_count) + '''' '''' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

''


/* delete jn */
	print ''	
		/* replace existing '' + @tablename + ''_jn */
		delete 
		from '' + @desttable + ''_jn
		where ''
	
	exec jn_match_pk_var_cols  @tablename,''''


	
	print ''           and jn_datetime = @jn_datetime
	
	''
	
	
	
	
	/* update _jn */
	print ''
		/* now update the prior end date */
		update '' + @desttable + ''_jn
		set jn_endtime= @jn_datetime
		where ''
	
	exec jn_match_pk_var_cols  @tablename,''''

	
	print ''	and jn_endtime > @jn_datetime
		and jn_datetime <= @jn_datetime
		
		
	
	
	
	
	
	
	''
	
	
	
	
	
	
	
	/* delete main */
	
	print ''
	if @jn_operation = ''''D''''
	begin
		delete from '' + @desttable + ''
		where ''

	exec jn_match_pk_var_cols  @tablename,''''

	print ''end
else
begin
''
	
	
	
	
	/* update  */
	if exists (select ''x'' 
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
	)
	
	begin	
		print ''	
			update '' + @desttable + ''
			set ''
		
		exec jn_set_tab_vars @tablename,''''
		
print ''		where ''

	exec jn_match_pk_var_cols  @tablename,''''

		
		print ''
		
		
		
		''
	
	end
	else
		begin
		print '' /*no updated needed for '' + @tablename + '' because there are no non-primary key fields */
	
	
	''
		end	
	
	
	
	
	/* insert */
	
	
	
	print ''
		
		insert into '' + @desttable +'' ('' 
	
	exec jn_build_column_list @tablename,''''
	
		print '')
		select ''

exec jn_build_var_list @tablename

	
	print ''where not exists (Select ''''x'''' from '' + @desttable + '' where ''
	
	exec jn_match_pk_var_cols  @tablename,''''
	
	print '')



end
''
		
	
	
	
	
	
	
		
	/* insert _jn */
	
	print ''	
	insert into '' + @desttable + ''_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,''
	
	exec jn_build_column_list @tablename,''''
	
		print '')
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,''
exec jn_build_var_list @tablename

print '')

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,''

exec jn_build_var_list @tablename

print ''
end
close read_main
deallocate read_main

  print '''''' + @tablename + ''_jn DONE with '''' + convert(varchar(10),@jn_loop_count) + '''' last date  '''' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else
		begin
	
	
	''
	
	
	
	
	
	/* purge old journals */
	print ''
		select @jn_mindate = isnull(min(jn_datetime),''''10-jun-2500'''')
		from '' + @sourcetable + ''_jn
		
		select @jn_maxdate = isnull(dateadd(day,-2,max(jn_datetime)),''''10-jun-1970'''')
		from '' + @desttable + ''_jn
		
		
		print ''''mindate is '''' + convert(varchar(20),@jn_mindate)
		print ''''maxdate is '''' + convert(varchar(20),@jn_maxdate)
		
		print ''''deleting from production''''
		/* If the row is in both tables,  we can delete it */
		delete a
		from '' + @sourcetable + ''_jn  a,
		'' + @desttable + ''_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and ''
	
	
	exec jn_match_pk_index_cols @tablename,''b''
	
	print ''end''
	end
else

	begin


print '' /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''''no journal: synchronize
Step 1: sync deletes''''

delete a
from '' + @desttable + '' a
where not exists (
select ''''x''''
from '' + @sourcetable + '' b
where ''

exec jn_match_pk_index_cols @tablename,''b''

print '')



''





/* update */
	if exists (select ''x'' 
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
	)
	
begin
	print ''

print '''' step 2: update ''''

	update f 
	set ''
	
	exec jn_set_tab_cols @tablename,''a''
	
	print '' from '' + @desttable + '' f,'' + @sourcetable + '' a
	where ''
	
	exec jn_match_pk_index_cols @tablename,''f''
	
	print ''and (''
	
	exec jn_nomatch_nonindex_cols @tablename,''f''
	
	print '')
	
	
	''
	end	
else
begin
print ''

print '''' Warning- no update needed for this table because the only fields are the primary key''''


''
end


/* insert */
print ''
print '''' Step 3: insert''''
insert into ''+@desttable + ''(''

exec jn_build_column_list @tablename,''''

print '')
select ''

exec jn_build_column_list @tablename,''a.''

print '' from '' + @sourcetable + '' a
where not exists (select ''''x''''
from  '' + @desttable + '' b
 where ''

exec jn_match_pk_index_cols @tablename,''b''

print ''
)''
     

	end


print ''
print ''''           '' + @tablename + '' done''''
print ''''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''''

end


go''



end


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_build_transfer] TO [reporter]
GO
