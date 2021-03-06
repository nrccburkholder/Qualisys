/****** Object:  StoredProcedure [dbo].[jn_make_journal_triggerset]    Script Date: 08/11/2006 14:13:31 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_make_journal_triggerset]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_make_journal_triggerset]
GO
/****** Object:  StoredProcedure [dbo].[jn_make_journal_triggerset]    Script Date: 08/11/2006 14:13:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_make_journal_triggerset]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE jn_make_journal_triggerset
   ( @tablename varchar(255))
as
/* This code builds all the journalized triggers to journalize a table
This is the main table you call.
The result will be a printed output that can be executed.

If a table name is "tab"
then there the following objects will be created:
   tab_ji - a insert trigger on tab that journals the inserts
   tab_ju - a update trigger on tab that journals the updates
   tab_jd - a delete trigger on tab that journals the deletes


see jn_make_journal_table for the other side of the equasion


Version 1.0
Copyright (C) Hibbard M. Engler 2002
*/
begin
exec jn_insert_trigger @tablename
exec jn_update_trigger @tablename
exec jn_delete_trigger @tablename
end

' 
END
GO
GRANT EXECUTE ON [dbo].[jn_make_journal_triggerset] TO [reporter]
GO
