/****** Object:  StoredProcedure [dbo].[jn_delete_trigger]    Script Date: 08/11/2006 14:11:42 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_delete_trigger]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_delete_trigger]
GO
/****** Object:  StoredProcedure [dbo].[jn_delete_trigger]    Script Date: 08/11/2006 14:11:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_delete_trigger]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE jn_delete_trigger
   ( @tablename varchar(255))
/* this code builds the delete trigger 
Copyright (C) Hibbard M. Engler 2002
*/
as
begin


DECLARE @printline varchar(2000)
/* create journal table  */

/* initial header */
print ''CREATE TRIGGER '' + @tablename + ''_jd  ON '' + @tablename
print ''FOR DELETE 
AS
begin
DECLARE @current_date datetime

set @current_date = current_timestamp
''


/* delete existing rows if there are multiple dml statementnts happening at the same time */
 EXEC jn_delete_existing_rows @tablename,''deleted'',''d''  


/* now update the prior records end time to be the current time.
 */
 EXEC jn_update_prior_rows @tablename,''deleted'',''d''  


/* now insert the new record */
 EXEC jn_insert_journal_row @tablename,''deleted'',''D''  


/* finish up */
print ''end
go''



end


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_delete_trigger] TO [reporter]
GO
