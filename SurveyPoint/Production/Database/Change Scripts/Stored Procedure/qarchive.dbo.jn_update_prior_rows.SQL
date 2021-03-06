/****** Object:  StoredProcedure [dbo].[jn_update_prior_rows]    Script Date: 08/10/2006 17:03:11 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_update_prior_rows]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[jn_update_prior_rows]
GO
/****** Object:  StoredProcedure [dbo].[jn_update_prior_rows]    Script Date: 08/10/2006 17:03:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[jn_update_prior_rows]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE jn_update_prior_rows(@tablename varchar(255),@fromtab varchar(100), @fromalias varchar(10))
 AS
/* This makes the common code that deleted the existing rows from the journal table - if there is a duplicate row with the same primary key and the same time stamp exaxtly.
This code would fire rarely,  only n the case where two dml statements happen during the same time tick.*/

begin
print ''
/* now update the prior end date */
update ''+@tablename+''_jn
set jn_endtime= @current_date
from ''+@tablename +''_jn as a,''+ @fromtab +'' as ''+ @fromalias + ''
where ''

/* Do the where clause */
 EXEC jn_match_pk_index_cols @tablename,@fromalias  

print ''and a.jn_endtime > @current_date
and a.jn_datetime <= @current_date;'';


end;


' 
END
GO
GRANT EXECUTE ON [dbo].[jn_update_prior_rows] TO [reporter]
GO
