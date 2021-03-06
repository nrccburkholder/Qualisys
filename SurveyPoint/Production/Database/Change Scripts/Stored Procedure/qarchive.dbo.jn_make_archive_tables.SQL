/****** Object:  StoredProcedure [dbo].[jn_make_archive_tables]    Script Date: 08/11/2006 14:12:30 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_make_archive_tables]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_make_archive_tables]
GO
/****** Object:  StoredProcedure [dbo].[jn_make_archive_tables]    Script Date: 08/11/2006 14:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_make_archive_tables]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE jn_make_archive_tables
   ( @tablename varchar(255))
as
begin
/* This code builds all the journalized tables and insexes needed to journalize a table.
And the base table.
The base table will not have foreign keys,  instead it will have indexes.
The journal table will also have the foreign key indexes

All unique indexes on the base table will not be unique in the transision?


The result will be a printed output that can be executed.

If a table name is "tab"
then there the following objects will be created:
   tab_jn - journal table with all tab columns,  plus the who, what, when , where, and why.  Why is left blank in this implementation.
   tab_jx - unique index on the journal table - derived from the unique index of the base table postpended with jn_datetime
   tab_je - a second unique index that is prepended with jn_endtime

Version 1.0
Copyright (C) Hibbard M. Engler 2005
*/

DECLARE @printline varchar(2000)
/* create journal table  */












/* regular tables */
SELECT @printline = ''create table '' + name + '' (''
FROM         sysobjects
WHERE     (type = ''U'') AND (name = @tablename)
print @printline

/* create the column datatype list for the table */
 EXEC jn_build_column_datatype_list @tablename  


/* create unique index on the primary key */
SELECT @printline = '', constraint '' + u.name + ''_pk primary key
  (''
FROM         sysobjects u INNER JOIN
                      sysindexes i ON u.id = i.id
WHERE     (u.type = ''U'') AND (u.name = @tablename) 
print @printline
 EXEC jn_build_pk_index_column_list @tablename  

SELECT @printline = '')''
FROM         sysobjects u INNER JOIN
                      sysindexes i ON u.id = i.id
WHERE     (u.type = ''U'') AND (u.name = @tablename) 
print @printline

print   '');''




/* note - you can create other indexes for performance, if you like. */

exec jn_create_indexes @tablename,''''



















/* journal table */

SELECT @printline = ''create table '' + name + ''_jn (
jn_operation varchar(1) not null,
jn_user varchar(100) not null,
jn_datetime datetime not null,
jn_endtime datetime not null,
jn_notes varchar(240),
jn_appln varchar(30),
jn_session smallint,''
FROM         sysobjects
WHERE     (type = ''U'') AND (name = @tablename)
print @printline

/* create the column datatype list for the table */
 EXEC jn_build_column_datatype_list @tablename  

print  '');''

/* create unique index on endtime */
SELECT @printline = ''create unique index '' + u.name + ''_JE
 on '' + u.name + ''_JN (''
FROM         sysobjects u INNER JOIN
                      sysindexes i ON u.id = i.id
WHERE     (u.type = ''U'') AND (u.name = @tablename) 
print @printline
 EXEC jn_build_pk_index_column_list @tablename  
print   '',jn_endtime);''



/* create unique index on starttime */

SELECT @printline = ''create unique index '' + u.name + ''_JX
 on '' + u.name + ''_JN (''
FROM         sysobjects u INNER JOIN
                      sysindexes i ON u.id = i.id
WHERE     (u.type = ''U'') AND (u.name = @tablename)

print  @printline
 EXEC jn_build_pk_index_column_list @tablename  
print   '',jn_datetime);''

/* note - you can create other indexes for performance, if you like. */

exec jn_create_indexes @tablename,''_jn''

print ''go''
print ''''
end

' 
END
GO
GRANT EXECUTE ON [dbo].[jn_make_archive_tables] TO [reporter]
GO
