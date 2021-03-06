/****** Object:  StoredProcedure [dbo].[jn_delete_existing_rows]    Script Date: 08/11/2006 14:11:13 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_delete_existing_rows]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_delete_existing_rows]
GO
/****** Object:  StoredProcedure [dbo].[jn_delete_existing_rows]    Script Date: 08/11/2006 14:11:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_delete_existing_rows]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE jn_delete_existing_rows(@tablename varchar(255),@fromtab varchar(100), @fromalias varchar(10))
 AS
/* This makes the common code that deleted the existing rows from the journal table - if there is a duplicate row with the same primary key and the same time stamp exaxtly.
This code would fire rarely,  only n the case where two dml statements happen during the same time tick.

Copyright (C) Hibbard M. Engler 2002

*/

begin
print ''
/* first delete existing rows */

delete from ''+ @tablename + ''_jn
from '' + @tablename +''_jn a,'' + @fromtab + '' '' + @fromalias + ''
where ''

/* Do the where clause */
 EXEC jn_match_pk_index_cols @tablename,@fromalias  

print ''and a.jn_datetime = @current_date;''
end;


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_delete_existing_rows] TO [reporter]
GO
