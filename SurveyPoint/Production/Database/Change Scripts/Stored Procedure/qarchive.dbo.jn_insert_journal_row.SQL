/****** Object:  StoredProcedure [dbo].[jn_insert_journal_row]    Script Date: 08/11/2006 14:12:01 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_insert_journal_row]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_insert_journal_row]
GO
/****** Object:  StoredProcedure [dbo].[jn_insert_journal_row]    Script Date: 08/11/2006 14:12:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_insert_journal_row]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE jn_insert_journal_row(@tablename varchar(255),@fromtab varchar(100), @fromalias varchar(10))
 AS
/* This makes the common code that inserts a insert, update, or delete journal row into the journal table.
Copyright (C) Hibbard M. Engler 2002
*/

begin

print ''
/* now insert the journal */
insert into ''+@tablename+''_jn (
jn_operation,jn_user,jn_datetime,jn_endtime,
jn_notes,jn_appln,jn_session,''

/* the rest of the list */
 EXEC jn_build_column_list @tablename,''''  

print '')
select
'''''' + @fromalias + '''''',current_user,@current_date,CAST(''''2500-12-27 12:00:00.000'''' 
  AS datetime),null,null,@@SPID,''

 EXEC jn_build_column_list @tablename,''''  


print ''from ''+ @fromtab + '' as '' + @fromalias

print ''''


end;


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_insert_journal_row] TO [reporter]
GO
